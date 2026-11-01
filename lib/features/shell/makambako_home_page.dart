import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/l10n/app_text.dart';
import '../catalog/community_category.dart';
import '../discovery/domain/discovery_result.dart';
import '../discovery/domain/place.dart';
import '../discovery/domain/place_repository.dart';
import '../discovery/domain/place_search_request.dart';
import '../discovery/domain/place_search_service.dart';
import '../discovery/presentation/place_detail_page.dart';
import '../discovery/presentation/place_search_results.dart';
import '../explore/explore_page.dart';
import '../food/food_delivery_page.dart';
import '../home/home_page.dart';
import '../news/news_page.dart';
import '../profile/profile_page.dart';
import '../profile/profile_reveal.dart';
import '../ride/ride_page.dart';
import '../services/local_pro_booking_page.dart';
import '../stays/guest_house_booking_page.dart';
import 'widgets/top_bar.dart';

/// App shell: owns cross-tab state (tab, language, search, saved categories,
/// saved places, ward filtering, and place-search state).
class MakambakoHomePage extends StatefulWidget {
  const MakambakoHomePage({
    required this.placeRepository,
    this.initialIsEnglish = false,
    super.key,
  });

  final PlaceRepository placeRepository;
  final bool initialIsEnglish;

  @override
  State<MakambakoHomePage> createState() => _MakambakoHomePageState();
}

class _MakambakoHomePageState extends State<MakambakoHomePage> {
  static const _savedCategoriesKey = 'mk_yetu.savedCategories';
  static const _savedPlacesKey = 'mk_yetu.savedPlaces';
  static const _isEnglishKey = 'mk_yetu.isEnglish';

  late final PlaceSearchService _placeSearch;
  int _selectedTab = 0;
  String _search = '';
  String? _selectedCategory;
  String? _selectedAreaId;
  late bool _isEnglish;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _profileButtonKey = GlobalKey();
  final Set<String> _savedCategories = {};
  final Set<String> _savedPlaceIds = {};
  List<Place> _savedPlacesList = [];
  PlaceSearchState _placeSearchState = const PlaceSearchIdle();
  int _placeSearchRequestId = 0;
  String? _rideDestination;

  @override
  void initState() {
    super.initState();
    _isEnglish = widget.initialIsEnglish;
    _placeSearch = PlaceSearchService(widget.placeRepository);
    _loadPersistedState();
  }

  @override
  void didUpdateWidget(covariant MakambakoHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIsEnglish != widget.initialIsEnglish) {
      _isEnglish = widget.initialIsEnglish;
    }
  }

  /// Restores saved categories, saved places, and language choice.
  Future<void> _loadPersistedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _isEnglish = prefs.getBool(_isEnglishKey) ?? widget.initialIsEnglish;
        _savedCategories
          ..clear()
          ..addAll(prefs.getStringList(_savedCategoriesKey) ?? const []);
        _savedPlaceIds
          ..clear()
          ..addAll(prefs.getStringList(_savedPlacesKey) ?? const []);
      });
      await _refreshSavedPlaces();
    } catch (_) {
      // Best-effort persistence fallback.
    }
  }

  Future<void> _persistState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isEnglishKey, _isEnglish);
      await prefs.setStringList(
        _savedCategoriesKey,
        _savedCategories.toList(),
      );
      await prefs.setStringList(
        _savedPlacesKey,
        _savedPlaceIds.toList(),
      );
    } catch (_) {
      // Best-effort persistence.
    }
  }

  Future<void> _refreshSavedPlaces() async {
    if (_savedPlaceIds.isEmpty) {
      if (mounted) setState(() => _savedPlacesList = []);
      return;
    }
    final places = <Place>[];
    for (final id in _savedPlaceIds) {
      final result = await _placeSearch.getById(id);
      if (result case DiscoverySuccess<Place?>(:final value)) {
        if (value != null) places.add(value);
      }
    }
    if (mounted) {
      setState(() => _savedPlacesList = places);
    }
  }

  String? get _selectedCategoryId {
    for (final category in categories) {
      if (category.name == _selectedCategory) return category.id;
    }
    return null;
  }

  bool get _hasPlaceSearchResults {
    final state = _placeSearchState;
    return state is PlaceSearchLoaded && state.places.isNotEmpty;
  }

  List<CommunityCategory> get _visibleCategoryList => visibleCategories(
        search: _search,
        selectedCategory: _selectedCategory,
        isEnglish: _isEnglish,
      );

  void _onSearchChanged(String value) {
    setState(() {
      _search = value.trim();
      _selectedCategory = null;
    });
    _loadPlaceSearch();
  }

  void _selectCategory(String? categoryName) {
    setState(() => _selectedCategory = categoryName);
    _loadPlaceSearch();
  }

  void _selectArea(String? areaId) {
    setState(() => _selectedAreaId = areaId);
    _loadPlaceSearch();
  }

  void _toggleLanguage() {
    setState(() => _isEnglish = !_isEnglish);
    _persistState();
  }

  void _toggleSavedCategory(String categoryName) {
    setState(() {
      if (!_savedCategories.add(categoryName)) {
        _savedCategories.remove(categoryName);
      }
    });
    _persistState();
  }

  void _removeSavedCategory(String categoryName) {
    setState(() => _savedCategories.remove(categoryName));
    _persistState();
  }

  void _toggleSavedPlace(String placeId) {
    setState(() {
      if (!_savedPlaceIds.add(placeId)) {
        _savedPlaceIds.remove(placeId);
      }
    });
    _persistState();
    _refreshSavedPlaces();
  }

  Future<void> _loadPlaceSearch() async {
    final query = _search.trim();
    final categoryId = _selectedCategoryId;
    final areaId = _selectedAreaId;
    final requestId = ++_placeSearchRequestId;

    if (query.isEmpty && categoryId == null && areaId == null) {
      setState(() => _placeSearchState = const PlaceSearchIdle());
      return;
    }

    final request = PlaceSearchRequest(
      query: query,
      categoryId: categoryId,
      areaId: areaId,
    );
    setState(() => _placeSearchState = const PlaceSearchLoading());

    final result = await _placeSearch.search(request);
    if (!mounted || requestId != _placeSearchRequestId) return;
    setState(() {
      _placeSearchState = switch (result) {
        DiscoverySuccess<List<Place>>(:final value) => PlaceSearchLoaded(value),
        DiscoveryFailure<List<Place>>(:final kind, :final message) =>
          PlaceSearchFailed(
            DiscoveryFailure<List<Place>>(kind: kind, message: message),
          ),
      };
    });
  }

  Future<void> _openPlaceById(String placeId) async {
    final result = await _placeSearch.getById(placeId);
    if (!mounted) return;
    switch (result) {
      case DiscoverySuccess<Place?>(:final value):
        if (value == null) {
          _showMessage(
            tx(
              _isEnglish,
              'Taarifa ya eneo hili haipatikani tena.',
              'This place is no longer available.',
            ),
          );
        } else {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => PlaceDetailPage(
                place: value,
                isEnglish: _isEnglish,
                isSaved: _savedPlaceIds.contains(value.id),
                onToggleSave: () => _toggleSavedPlace(value.id),
                onRideThere: _openRideTo,
              ),
            ),
          );
          _refreshSavedPlaces();
        }
      case DiscoveryFailure<Place?>(:final message):
        _showMessage(message);
    }
  }

  void _openRideTo(String destination) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    setState(() {
      _rideDestination = destination;
      _selectedTab = 1; // Switch to Ride tab
    });
  }

  void _openMapFor(String destination) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    setState(() {
      _search = destination;
      _searchController.text = destination;
      _selectedTab = 3; // Explore tab
    });
    _loadPlaceSearch();
  }

  void _openGuestHouse({String? promoCode, String guestHouseName = 'Sunrise Guest House'}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => GuestHouseBookingPage(
          isEnglish: _isEnglish,
          guestHouseName: guestHouseName,
          initialPromoCode: promoCode,
          onRideThere: (dest) => _openRideTo(dest),
          onViewOnMap: (dest) => _openMapFor(dest),
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _openLocalPros() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => LocalProBookingPage(
          isEnglish: _isEnglish,
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openCategoryFromHome(CommunityCategory category) {
    switch (category.id) {
      case 'transport':
        _selectTab(1);
        break;
      case 'food':
        _selectTab(2);
        break;
      case 'accommodation':
        _openGuestHouse();
        break;
      case 'services':
        _openLocalPros();
        break;
      default:
        setState(() {
          _selectedCategory = category.name;
          _selectedTab = 3; // Switch to Explore tab
        });
        _loadPlaceSearch();
    }
  }

  /// Centre of the top-bar avatar in global coordinates; the profile grows
  /// out of this point.
  Offset _profileOrigin() {
    final box = _profileButtonKey.currentContext?.findRenderObject();
    if (box is RenderBox && box.attached) {
      return box.localToGlobal(box.size.center(Offset.zero));
    }
    final size = MediaQuery.sizeOf(context);
    return Offset(size.width - 38, MediaQuery.paddingOf(context).top + 34);
  }

  void _openProfilePage() {
    _refreshSavedPlaces();
    Navigator.of(context).push(
      ProfileRevealRoute<void>(
        origin: _profileOrigin(),
        builder: (context) => ProfilePage(
          isEnglish: _isEnglish,
          onToggleLanguage: _toggleLanguage,
          savedCategories: _savedCategories,
          savedPlaces: _savedPlacesList,
          onRemoveSavedCategory: _removeSavedCategory,
          onRemoveSavedPlace: _toggleSavedPlace,
          onPlaceSelected: (place) => _openPlaceById(place.id),
          onExploreTab: () {
            Navigator.of(context).pop();
            _selectTab(3);
          },
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectTab(int index) {
    final clearCategory = index == 0 && _selectedCategory != null;
    setState(() {
      _selectedTab = index;
      if (clearCategory) _selectedCategory = null;
    });
    if (clearCategory) _loadPlaceSearch();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedTab == 0 && _search.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_selectedTab != 0) {
            _selectTab(0);
          } else if (_search.isNotEmpty) {
            setState(() {
              _search = '';
              _searchController.clear();
            });
            _loadPlaceSearch();
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TopBar(
                isEnglish: _isEnglish,
                onProfileTap: _openProfilePage,
                onLanguageTap: _toggleLanguage,
                profileButtonKey: _profileButtonKey,
              ),
              Expanded(child: _buildCurrentPage()),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedTab,
          onDestinationSelected: _selectTab,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFE5F0E8),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: tx(_isEnglish, 'Nyumbani', 'Home'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.two_wheeler_outlined),
              selectedIcon: const Icon(Icons.two_wheeler_rounded),
              label: tx(_isEnglish, 'Usafiri', 'Ride'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.lunch_dining_outlined),
              selectedIcon: const Icon(Icons.lunch_dining_rounded),
              label: tx(_isEnglish, 'Chakula', 'Food'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore_rounded),
              label: tx(_isEnglish, 'Gundua', 'Explore'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.newspaper_outlined),
              selectedIcon: const Icon(Icons.newspaper_rounded),
              label: tx(_isEnglish, 'Habari', 'News'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_selectedTab) {
      case 1:
        return RidePage(
          isEnglish: _isEnglish,
          initialDestination: _rideDestination,
          onBack: () => _selectTab(0),
        );
      case 2:
        return FoodDeliveryPage(
          isEnglish: _isEnglish,
          onBackToHome: () => _selectTab(0),
        );
      case 3:
        return ExplorePage(
          isEnglish: _isEnglish,
          search: _search,
          selectedCategory: _selectedCategory,
          selectedAreaId: _selectedAreaId,
          searchController: _searchController,
          placeSearchState: _placeSearchState,
          hasPlaceSearchResults: _hasPlaceSearchResults,
          visibleCategoryList: _visibleCategoryList,
          savedCategories: _savedCategories,
          onSearchChanged: _onSearchChanged,
          onSelectCategory: _selectCategory,
          onSelectArea: _selectArea,
          onRetrySearch: _loadPlaceSearch,
          onPlaceSelected: (place) => _openPlaceById(place.id),
          onToggleSavedCategory: _toggleSavedCategory,
        );
      case 4:
        return NewsPage(
          isEnglish: _isEnglish,
          onPlaceSelected: (place) => _openPlaceById(place.id),
        );
      default:
        return HomePage(
          isEnglish: _isEnglish,
          search: _search,
          searchController: _searchController,
          placeSearchState: _placeSearchState,
          hasPlaceSearchResults: _hasPlaceSearchResults,
          visibleCategoryList: _visibleCategoryList,
          onSearchChanged: _onSearchChanged,
          onRetrySearch: _loadPlaceSearch,
          onPlaceSelected: (place) => _openPlaceById(place.id),
          onExploreTab: () => _selectTab(3),
          onRideTab: () => _selectTab(1),
          onFoodTab: () => _selectTab(2),
          onNewsTab: () => _selectTab(4),
          onStaysOpened: (promo) => _openGuestHouse(promoCode: promo),
          onServicesOpened: _openLocalPros,
          onCategoryOpened: _openCategoryFromHome,
        );
    }
  }
}
