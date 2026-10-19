import 'package:flutter/material.dart';

import 'features/discovery/data/unconfigured_place_repository.dart';
import 'features/discovery/domain/discovery_result.dart';
import 'features/discovery/domain/place.dart';
import 'features/discovery/domain/place_repository.dart';
import 'features/discovery/domain/place_search_request.dart';
import 'features/discovery/domain/place_search_service.dart';
import 'features/discovery/presentation/place_search_results.dart';

void main() {
  runApp(const MakambakoYetuApp());
}

const _forest = Color(0xFF145C45);
const _green = Color(0xFF237A59);
const _page = Color(0xFFF5F7F2);
const _ink = Color(0xFF1D2B25);
const _muted = Color(0xFF758179);
const _locationScope = 'Makambako, Njombe';
const _locationSearchTerms = ['Makambako', 'Njombe', 'karibu', 'nearby'];

String _tx(bool english, String swahili, String englishText) =>
    english ? englishText : swahili;

String _categoryName(_CommunityCategory category, bool english) {
  if (!english) return category.name;
  return switch (category.id) {
    'businesses' => 'Business',
    'food' => 'Food',
    'services' => 'Services',
    'transport' => 'Transport',
    'accommodation' => 'Accommodation',
    'events' => 'Events',
    'places' => 'Places',
    'community' => 'Community',
    _ => category.name,
  };
}

String _categorySubtitle(_CommunityCategory category, bool english) {
  if (!english) return category.subtitle;
  return switch (category.id) {
    'businesses' => 'Shops and local entrepreneurs',
    'food' => 'Restaurants and places to eat',
    'services' => 'Personal and business services',
    'transport' => 'Transport and travel',
    'accommodation' => 'Hotels and places to stay',
    'events' => 'Local events and activities',
    'places' => 'Places and map information',
    'community' => 'Community information',
    _ => category.subtitle,
  };
}

class MakambakoYetuApp extends StatelessWidget {
  const MakambakoYetuApp({
    super.key,
    this.placeRepository = const UnconfiguredPlaceRepository(),
  });

  final PlaceRepository placeRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makambako Yetu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _page,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _green,
          primary: _forest,
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
      home: MakambakoHomePage(placeRepository: placeRepository),
    );
  }
}

class _CommunityCategory {
  const _CommunityCategory({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.searchTerms,
  });

  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<String> searchTerms;
}

const _categories = [
  _CommunityCategory(
    id: 'businesses',
    name: 'Biashara',
    subtitle: 'Maduka na wajasiriamali',
    icon: Icons.storefront_rounded,
    color: Color(0xFFEAF3E9),
    searchTerms: [
      'shop',
      'shops',
      'store',
      'soko',
      'market',
      'bidhaa',
      'product',
      'products',
    ],
  ),
  _CommunityCategory(
    id: 'food',
    name: 'Chakula',
    subtitle: 'Migahawa na sehemu za kula',
    icon: Icons.restaurant_rounded,
    color: Color(0xFFFFF1DA),
    searchTerms: [
      'food',
      'restaurant',
      'restaurants',
      'mgahawa',
      'migahawa',
      'cafe',
      'kahawa',
    ],
  ),
  _CommunityCategory(
    id: 'services',
    name: 'Huduma',
    subtitle: 'Huduma za watu na biashara',
    icon: Icons.handshake_outlined,
    color: Color(0xFFEAF3E9),
    searchTerms: [
      'service',
      'services',
      'fundi',
      'kliniki',
      'clinic',
      'afya',
      'health',
      'bank',
      'salon',
    ],
  ),
  _CommunityCategory(
    id: 'transport',
    name: 'Usafiri',
    subtitle: 'Usafiri na safari',
    icon: Icons.directions_bus_rounded,
    color: Color(0xFFE8EFF9),
    searchTerms: [
      'transport',
      'bus',
      'basi',
      'daladala',
      'taxi',
      'teksi',
      'safari',
      'travel',
    ],
  ),
  _CommunityCategory(
    id: 'accommodation',
    name: 'Malazi',
    subtitle: 'Hoteli na sehemu za kukaa',
    icon: Icons.hotel_rounded,
    color: Color(0xFFE8EFF9),
    searchTerms: [
      'hotel',
      'hoteli',
      'lodge',
      'guesthouse',
      'guest house',
      'accommodation',
      'stay',
      'kukaa',
    ],
  ),
  _CommunityCategory(
    id: 'events',
    name: 'Matukio',
    subtitle: 'Matukio na shughuli za eneo',
    icon: Icons.event_rounded,
    color: Color(0xFFF5EAF1),
    searchTerms: [
      'event',
      'events',
      'tamasha',
      'sherehe',
      'mkutano',
      'activity',
      'activities',
    ],
  ),
  _CommunityCategory(
    id: 'places',
    name: 'Maeneo',
    subtitle: 'Maeneo na taarifa za ramani',
    icon: Icons.map_outlined,
    color: Color(0xFFE8EFF9),
    searchTerms: [
      'map',
      'maps',
      'ramani',
      'place',
      'places',
      'location',
      'eneo',
      'nearby',
      'karibu',
      'address',
      'anwani',
    ],
  ),
  _CommunityCategory(
    id: 'community',
    name: 'Jamii',
    subtitle: 'Taarifa za jamii',
    icon: Icons.people_alt_outlined,
    color: Color(0xFFF5EAF1),
    searchTerms: [
      'community',
      'taarifa',
      'updates',
      'notice',
      'matangazo',
      'maendeleo',
    ],
  ),
];

class MakambakoHomePage extends StatefulWidget {
  const MakambakoHomePage({required this.placeRepository, super.key});

  final PlaceRepository placeRepository;

  @override
  State<MakambakoHomePage> createState() => _MakambakoHomePageState();
}

class _MakambakoHomePageState extends State<MakambakoHomePage> {
  late final PlaceSearchService _placeSearch;
  int _selectedTab = 0;
  String _search = '';
  String? _selectedCategory;
  bool _isEnglish = false;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _savedCategories = {};
  PlaceSearchState _placeSearchState = const PlaceSearchIdle();
  int _placeSearchRequestId = 0;

  @override
  void initState() {
    super.initState();
    _placeSearch = PlaceSearchService(widget.placeRepository);
  }

  String? get _selectedCategoryId {
    for (final category in _categories) {
      if (category.name == _selectedCategory) return category.id;
    }
    return null;
  }

  bool get _hasPlaceSearchResults {
    final state = _placeSearchState;
    return state is PlaceSearchLoaded && state.places.isNotEmpty;
  }

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

  void _toggleLanguage() {
    setState(() => _isEnglish = !_isEnglish);
  }

  Future<void> _loadPlaceSearch() async {
    final query = _search.trim();
    final categoryId = _selectedCategoryId;
    final requestId = ++_placeSearchRequestId;

    if (query.isEmpty && categoryId == null) {
      setState(() => _placeSearchState = const PlaceSearchIdle());
      return;
    }

    final request = PlaceSearchRequest(query: query, categoryId: categoryId);
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
            _tx(
              _isEnglish,
              'Taarifa ya eneo hili haipatikani tena.',
              'This place is no longer available.',
            ),
          );
        } else {
          _showPlaceDetails(value);
        }
      case DiscoveryFailure<Place?>(:final message):
        _showMessage(message);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showPlaceDetails(Place place) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              place.name,
              style: const TextStyle(
                color: _ink,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${place.categoryName} · ${place.location.area.name}',
              style: const TextStyle(color: _muted, fontSize: 13),
            ),
            if (place.isDevelopmentFixture) ...[
              const SizedBox(height: 14),
              Text(
                _tx(
                  _isEnglish,
                  'REKODI YA MAENDELEZO TU — SI BIASHARA ILIYOTHIBITISHWA',
                  'DEVELOPMENT RECORD ONLY — NOT A VERIFIED BUSINESS',
                ),
                style: const TextStyle(
                  color: Color(0xFF9A5A00),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
            if (place.description case final description?) ...[
              const SizedBox(height: 14),
              Text(description, style: const TextStyle(color: _ink)),
            ],
            if (place.location.address case final address?) ...[
              const SizedBox(height: 12),
              Text(address, style: const TextStyle(color: _muted)),
            ],
            const SizedBox(height: 12),
            Text(
              '${_tx(_isEnglish, 'Hali', 'Status')}: '
              '${_placeVerificationLabel(place.verificationStatus)}',
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              '${_tx(_isEnglish, 'Chanzo', 'Source')}: '
              '${place.provenance.label}',
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  List<_CommunityCategory> get _visibleCategories {
    final searchTerms = _search
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty);

    return _categories.where((category) {
      final matchesCategory =
          _selectedCategory == null || category.name == _selectedCategory;
      final searchableText = [
        _categoryName(category, _isEnglish),
        category.subtitle,
        ...category.searchTerms,
        ..._locationSearchTerms,
      ].join(' ').toLowerCase();
      final matchesSearch = searchTerms.every(searchableText.contains);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showCategory(_CommunityCategory category) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _CategoryIcon(category: category, size: 52),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _categoryName(category, _isEnglish),
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: _savedCategories.contains(category.name)
                      ? _tx(
                          _isEnglish,
                          'Ondoa kwenye zilizohifadhiwa',
                          'Remove from saved',
                        )
                      : _tx(_isEnglish, 'Hifadhi', 'Save'),
                  onPressed: () {
                    setState(() {
                      if (!_savedCategories.add(category.name)) {
                        _savedCategories.remove(category.name);
                      }
                    });
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    _savedCategories.contains(category.name)
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: _forest,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _page,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: _green, size: 19),
                  const SizedBox(width: 8),
                  const Text(
                    _locationScope,
                    style: TextStyle(
                      color: _ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _tx(_isEnglish, 'Eneo la jukwaa', 'Platform area'),
                    style: const TextStyle(color: _muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _categorySubtitle(category, _isEnglish),
              style: const TextStyle(color: _muted, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 12),
            Text(
              _tx(
                _isEnglish,
                'Sehemu hii itakusaidia kugundua taarifa na rasilimali za '
                    'Makambako kadri zinavyoongezwa kwenye jukwaa.',
                'This section will help you discover Makambako information '
                    'and resources as they are added to the platform.',
              ),
              style: TextStyle(color: _ink, fontSize: 14, height: 1.5),
            ),
          ],
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              isEnglish: _isEnglish,
              onProfileTap: () => _selectTab(3),
              onLanguageTap: _toggleLanguage,
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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: _tx(_isEnglish, 'Nyumbani', 'Home'),
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: _tx(_isEnglish, 'Gundua', 'Explore'),
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: _tx(_isEnglish, 'Zilizohifadhiwa', 'Saved'),
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: _tx(_isEnglish, 'Wasifu', 'Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_selectedTab) {
      case 1:
        return _buildExplorePage();
      case 2:
        return _buildSavedPage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  String _placeVerificationLabel(PlaceVerificationStatus status) {
    return switch (status) {
      PlaceVerificationStatus.verified =>
        _tx(_isEnglish, 'Imethibitishwa', 'Verified'),
      PlaceVerificationStatus.unverified =>
        _tx(_isEnglish, 'Haijathibitishwa', 'Unverified'),
      PlaceVerificationStatus.suspended =>
        _tx(_isEnglish, 'Imesitishwa', 'Suspended'),
      PlaceVerificationStatus.developmentFixture =>
        _tx(_isEnglish, 'Maendeleo tu', 'Development only'),
    };
  }

  Widget _buildHomePage() {
    final categories = _visibleCategories;

    return ListView(
      key: const PageStorageKey('home-page'),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        _WelcomeBanner(
          isEnglish: _isEnglish,
          onExplore: () => _selectTab(1),
        ),
        const SizedBox(height: 22),
        _SearchField(
          key: const ValueKey('home-search'),
          controller: _searchController,
          isEnglish: _isEnglish,
          onChanged: _onSearchChanged,
        ),
        if (_placeSearchState is PlaceSearchLoading)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(
              color: _green,
              backgroundColor: Color(0xFFE5F0E8),
              minHeight: 2,
            ),
          ),
        if (_search.isNotEmpty && _hasPlaceSearchResults) ...[
          const SizedBox(height: 17),
          _SectionHeading(
            title: _tx(_isEnglish, 'Matokeo ya maeneo', 'Place results'),
          ),
          PlaceSearchResults(
            state: _placeSearchState,
            onRetry: _loadPlaceSearch,
            onPlaceSelected: (place) => _openPlaceById(place.id),
            isEnglish: _isEnglish,
          ),
        ],
        const SizedBox(height: 25),
        _SectionHeading(
          title: _tx(_isEnglish, 'Vinjari Makambako', 'Explore Makambako'),
          action: _tx(_isEnglish, 'Ona zote', 'See all'),
          onAction: () => _selectTab(1),
        ),
        const SizedBox(height: 13),
        if (categories.isEmpty)
          _EmptyState(
            icon: Icons.search_off_rounded,
            title: _tx(_isEnglish, 'Hakuna kilichopatikana', 'Nothing found'),
            message: _tx(
              _isEnglish,
              'Jaribu neno jingine.',
              'Try another search.',
            ),
          )
        else
          GridView.builder(
            itemCount: categories.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryCard(
                category: category,
                isEnglish: _isEnglish,
                onTap: () {
                  setState(() {
                    _selectedCategory = category.name;
                    _selectedTab = 1;
                  });
                  _loadPlaceSearch();
                },
              );
            },
          ),
        const SizedBox(height: 22),
        if (_search.isNotEmpty && !_hasPlaceSearchResults) ...[
          _SectionHeading(
            title: _tx(_isEnglish, 'Matokeo ya maeneo', 'Place results'),
          ),
          PlaceSearchResults(
            state: _placeSearchState,
            onRetry: _loadPlaceSearch,
            onPlaceSelected: (place) => _openPlaceById(place.id),
            isEnglish: _isEnglish,
          ),
        ],
        _CommunityCard(
          isEnglish: _isEnglish,
          onTap: () => _selectTab(1),
        ),
      ],
    );
  }

  Widget _buildExplorePage() {
    final categories = _visibleCategories;
    return ListView(
      key: const PageStorageKey('explore-page'),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        Text(
          _tx(_isEnglish, 'Gundua', 'Explore'),
          style: TextStyle(
            color: _ink,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          _tx(
            _isEnglish,
            'Tafuta huduma na maeneo ya Makambako sehemu moja.',
            'Find Makambako services and places in one place.',
          ),
          style: TextStyle(color: _muted, fontSize: 14),
        ),
        const SizedBox(height: 19),
        _SearchField(
          key: const ValueKey('explore-search'),
          controller: _searchController,
          isEnglish: _isEnglish,
          onChanged: _onSearchChanged,
        ),
        if (_placeSearchState is PlaceSearchLoading)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(
              color: _green,
              backgroundColor: Color(0xFFE5F0E8),
              minHeight: 2,
            ),
          ),
        const SizedBox(height: 17),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: _tx(_isEnglish, 'Zote', 'All'),
              selected: _selectedCategory == null,
              onTap: () => _selectCategory(null),
            ),
            ..._categories.map(
              (category) => _FilterChip(
                label: _categoryName(category, _isEnglish),
                selected: _selectedCategory == category.name,
                onTap: () => _selectCategory(
                  _selectedCategory == category.name ? null : category.name,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (_hasPlaceSearchResults) ...[
          _SectionHeading(
            title: _tx(_isEnglish, 'Maeneo yanayolingana', 'Matching places'),
          ),
          PlaceSearchResults(
            state: _placeSearchState,
            onRetry: _loadPlaceSearch,
            onPlaceSelected: (place) => _openPlaceById(place.id),
            isEnglish: _isEnglish,
          ),
        ],
        _SectionHeading(
          title: _tx(_isEnglish, 'Vinjari kategoria', 'Browse categories'),
        ),
        const SizedBox(height: 11),
        if (categories.isEmpty)
          _EmptyState(
            icon: Icons.search_off_rounded,
            title: _tx(_isEnglish, 'Hakuna kilichopatikana', 'Nothing found'),
            message: _tx(
              _isEnglish,
              'Jaribu neno jingine au ondoa kichujio.',
              'Try another search or clear the filter.',
            ),
          )
        else
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: _ExploreCategoryTile(
                category: category,
                isEnglish: _isEnglish,
                saved: _savedCategories.contains(category.name),
                onTap: () => _showCategory(category),
                onSave: () => setState(() {
                  if (!_savedCategories.add(category.name)) {
                    _savedCategories.remove(category.name);
                  }
                }),
              ),
            ),
          ),
        if ((_search.isNotEmpty || _selectedCategory != null) &&
            !_hasPlaceSearchResults) ...[
          const SizedBox(height: 20),
          _SectionHeading(
            title: _tx(_isEnglish, 'Maeneo yanayolingana', 'Matching places'),
          ),
          PlaceSearchResults(
            state: _placeSearchState,
            onRetry: _loadPlaceSearch,
            onPlaceSelected: (place) => _openPlaceById(place.id),
            isEnglish: _isEnglish,
          ),
        ],
        MapProviderUnavailableCard(isEnglish: _isEnglish),
      ],
    );
  }

  Widget _buildSavedPage() {
    final saved = _categories
        .where((category) => _savedCategories.contains(category.name))
        .toList();
    return ListView(
      key: const PageStorageKey('saved-page'),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        Text(
          _tx(_isEnglish, 'Zilizohifadhiwa', 'Saved'),
          style: TextStyle(
            color: _ink,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          _tx(
            _isEnglish,
            'Vitu ulivyoweka pembeni kwa ajili yako.',
            'Items you have saved for later.',
          ),
          style: TextStyle(color: _muted, fontSize: 14),
        ),
        const SizedBox(height: 20),
        if (saved.isEmpty)
          _EmptyState(
            icon: Icons.bookmark_border_rounded,
            title: _tx(_isEnglish, 'Bado hujahifadhi chochote', 'Nothing saved yet'),
            message: _tx(
              _isEnglish,
              'Gundua kategoria na uguse alama ya kuhifadhi.',
              'Explore categories and tap the bookmark icon to save.',
            ),
          )
        else
          ...saved.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: _ExploreCategoryTile(
                category: category,
                saved: true,
                isEnglish: _isEnglish,
                onTap: () => _showCategory(category),
                onSave: () =>
                    setState(() => _savedCategories.remove(category.name)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfilePage() {
    return ListView(
      key: const PageStorageKey('profile-page'),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        Text(
          _tx(_isEnglish, 'Wasifu', 'Profile'),
          style: TextStyle(
            color: _ink,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Color(0xFFE5F0E8),
                child: Icon(Icons.person_rounded, color: _forest, size: 34),
              ),
              SizedBox(height: 13),
              Text(
                _tx(_isEnglish, 'Karibu Makambako Yetu', 'Welcome to Makambako Yetu'),
                style: TextStyle(
                  color: _ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6),
              Text(
                _tx(
                  _isEnglish,
                  'Jukwaa la kuunganisha jamii ya Makambako.',
                  'A platform connecting the Makambako community.',
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, height: 1.45),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _ProfileOption(
          icon: Icons.info_outline_rounded,
          label: _tx(_isEnglish, 'Kuhusu Makambako Yetu', 'About Makambako Yetu'),
          onTap: () => showAboutDialog(
            context: context,
            applicationName: 'Makambako Yetu',
            applicationVersion: '1.0.0',
            children: [
              Text(
                _tx(
                  _isEnglish,
                  'Jukwaa la kugundua biashara, huduma na taarifa za jamii.',
                  'A platform to discover businesses, services, and community information.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.isEnglish,
    required this.onProfileTap,
    required this.onLanguageTap,
  });

  final bool isEnglish;
  final VoidCallback onProfileTap;
  final VoidCallback onLanguageTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _forest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.location_city_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MAKAMBAKO YETU',
                  style: TextStyle(
                    color: _forest,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.05,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: _green, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      _locationScope,
                      style: const TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            child: InkWell(
              key: const ValueKey('language-toggle'),
              borderRadius: BorderRadius.circular(13),
              onTap: onLanguageTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.translate_rounded, color: _forest, size: 17),
                    const SizedBox(width: 4),
                    Text(
                      isEnglish ? 'SW' : 'EN',
                      style: const TextStyle(
                        color: _forest,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            tooltip: _tx(isEnglish, 'Wasifu', 'Profile'),
            onPressed: onProfileTap,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _forest,
            ),
            icon: const Icon(Icons.person_outline_rounded),
          ),
        ],
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({
    required this.isEnglish,
    required this.onExplore,
  });

  final bool isEnglish;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(21, 22, 21, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_forest, Color(0xFF27805B)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -42,
            top: -58,
            child: Container(
              width: 155,
              height: 155,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: -82,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.11),
                  width: 22,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _tx(isEnglish, 'KARIBU NYUMBANI', 'WELCOME HOME'),
                  style: TextStyle(
                    color: Color(0xFFE8F3C8),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _tx(isEnglish, 'Makambako,\nyetu sote.', 'Makambako,\nour home.'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _tx(
                  isEnglish,
                  'Biashara, huduma na maeneo — yote ya Makambako sehemu moja.',
                  'Businesses, services, and places — all of Makambako in one place.',
                ),
                style: TextStyle(
                  color: Color(0xFFD7E8DD),
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: onExplore,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE7F0D1),
                  foregroundColor: _forest,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _tx(isEnglish, 'Anza kugundua', 'Start exploring'),
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    super.key,
    required this.controller,
    required this.isEnglish,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool isEnglish;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: _tx(
          isEnglish,
          'Tafuta biashara, chakula, huduma, maeneo...',
          'Search businesses, food, services, places...',
        ),
        hintStyle: const TextStyle(color: _muted, fontSize: 14),
        prefixIcon: const Icon(Icons.search_rounded, color: _green),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: _tx(isEnglish, 'Futa utafutaji', 'Clear search'),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
                icon: const Icon(Icons.close_rounded, color: _muted),
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE9EDE8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _green, width: 1.4),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (action case final label?)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: _green,
              visualDensity: VisualDensity.compact,
            ),
            child: Row(
              children: [
                Text(label, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 3),
                const Icon(Icons.arrow_forward_ios_rounded, size: 11),
              ],
            ),
          ),
      ],
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category, this.size = 42});

  final _CommunityCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: category.color,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Icon(category.icon, color: _forest, size: size * 0.52),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.isEnglish,
    required this.onTap,
  });

  final _CommunityCategory category;
  final bool isEnglish;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CategoryIcon(category: category, size: 39),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _categoryName(category, isEnglish),
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _categorySubtitle(category, isEnglish),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _muted, fontSize: 10.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({required this.isEnglish, required this.onTap});

  final bool isEnglish;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEAF1E6),
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.diversity_3_rounded,
                  color: _forest,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _tx(isEnglish, 'Nguvu ya jamii yetu', 'Our community'),
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _tx(
                        isEnglish,
                        'Sehemu moja ya kuanza kugundua.',
                        'One place to start exploring.',
                      ),
                      style: const TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: _forest, size: 19),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      labelStyle: TextStyle(
        color: selected ? Colors.white : _ink,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.white,
      selectedColor: _forest,
      side: BorderSide(color: selected ? _forest : const Color(0xFFE6EAE5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _ExploreCategoryTile extends StatelessWidget {
  const _ExploreCategoryTile({
    required this.category,
    required this.saved,
    required this.isEnglish,
    required this.onTap,
    required this.onSave,
  });

  final _CommunityCategory category;
  final bool saved;
  final bool isEnglish;
  final VoidCallback onTap;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 13, 7, 13),
          child: Row(
            children: [
              _CategoryIcon(category: category, size: 47),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _categoryName(category, isEnglish),
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _categorySubtitle(category, isEnglish),
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: saved
                    ? _tx(
                        isEnglish,
                        'Ondoa kwenye zilizohifadhiwa',
                        'Remove from saved',
                      )
                    : _tx(isEnglish, 'Hifadhi', 'Save'),
                onPressed: onSave,
                icon: Icon(
                  saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: _forest,
                  size: 21,
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: _muted, size: 22),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 18),
      child: Column(
        children: [
          Icon(icon, color: _green, size: 42),
          const SizedBox(height: 13),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: ListTile(
        leading: Icon(icon, color: _forest),
        title: Text(
          label,
          style: const TextStyle(color: _ink, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: _muted),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
