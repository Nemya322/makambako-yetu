import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/activity/activity_service.dart';
import '../../core/activity/booking_record.dart';
import '../../core/l10n/app_text.dart';
import '../../core/theme/makambako_theme.dart';
import '../../core/widgets/empty_state.dart';
import '../catalog/community_category.dart';
import '../discovery/domain/place.dart';
import '../onboarding/data/auth_service.dart';
import '../onboarding/domain/auth_user.dart';
import '../onboarding/presentation/onboarding_flow_page.dart';
import 'profile_reveal.dart';

/// The Profile page: profile information, saved places & categories,
/// onboarding walkthrough launcher, and app settings. Accessed via top-right button.
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.isEnglish,
    this.savedCategories = const {},
    this.savedPlaces = const [],
    this.onRemoveSavedCategory,
    this.onRemoveSavedPlace,
    this.onPlaceSelected,
    this.onExploreTab,
    this.onClose,
    this.onToggleLanguage,
    this.authService = const AuthService(),
    super.key,
  });

  final bool isEnglish;
  final Set<String> savedCategories;
  final List<Place> savedPlaces;
  final ValueChanged<String>? onRemoveSavedCategory;
  final ValueChanged<String>? onRemoveSavedPlace;
  final ValueChanged<Place>? onPlaceSelected;
  final VoidCallback? onExploreTab;
  final VoidCallback? onClose;
  final VoidCallback? onToggleLanguage;
  final AuthService authService;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthUser? _currentUser;
  bool _isLoadingUser = true;
  late bool _isEnglish;
  List<BookingRecord> _bookings = [];

  @override
  void initState() {
    super.initState();
    _isEnglish = widget.isEnglish;
    _loadUser();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final bookings = await ActivityService().getBookings();
    if (mounted) {
      setState(() {
        _bookings = bookings;
      });
    }
  }

  void _openBookingDetails(BookingRecord booking) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F0E8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      booking.id,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: MakambakoColors.forest,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      booking.status,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: MakambakoColors.forest,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                booking.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: MakambakoColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                booking.subtitle,
                style: const TextStyle(fontSize: 13, color: MakambakoColors.muted),
              ),
              const Divider(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tx(_isEnglish, 'Jumla ya Gharama', 'Total Amount'),
                    style: const TextStyle(fontSize: 14, color: MakambakoColors.muted),
                  ),
                  Text(
                    'TZS ${booking.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: MakambakoColors.ink,
                    ),
                  ),
                ],
              ),
              if (booking.metadata.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx(_isEnglish, 'Maelezo ya Agizo', 'Order Breakdown'),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: MakambakoColors.muted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...booking.metadata.entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${e.key}:',
                                style: const TextStyle(fontSize: 12, color: MakambakoColors.ink),
                              ),
                              Flexible(
                                child: Text(
                                  '${e.value}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: MakambakoColors.ink,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: FilledButton.styleFrom(
                    backgroundColor: MakambakoColors.forest,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(tx(_isEnglish, 'Funga', 'Close')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEnglish != widget.isEnglish) {
      _isEnglish = widget.isEnglish;
    }
  }

  Future<void> _toggleLanguage() async {
    setState(() => _isEnglish = !_isEnglish);
    widget.onToggleLanguage?.call();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(isEnglishKey, _isEnglish);
    } catch (_) {}
  }

  Future<void> _loadUser() async {
    final user = await widget.authService.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
        _isLoadingUser = false;
      });
    }
  }

  Future<void> _openOnboarding(OnboardingStep initialStep) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeContext) => Scaffold(
          body: OnboardingFlowPage(
            initialStep: initialStep,
            isEnglish: _isEnglish,
            authService: widget.authService,
            onToggleLanguage: _toggleLanguage,
            onExit: () => Navigator.of(routeContext).pop(),
            onComplete: (user) {
              Navigator.of(routeContext).pop();
              _loadUser();
            },
          ),
        ),
      ),
    );
    _loadUser();
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tx(_isEnglish, 'Toka kwenye Akaunti?', 'Sign Out?')),
        content: Text(
          tx(
            _isEnglish,
            'Je, una uhakika unataka kutoka kwenye akaunti yako?',
            'Are you sure you want to sign out of your account?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(tx(_isEnglish, 'Ghairi', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
            ),
            child: Text(tx(_isEnglish, 'Toka', 'Sign Out')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.authService.logout();
      await _loadUser();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              tx(_isEnglish, 'Umetoka kwenye akaunti.', 'Signed out successfully.'),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedCatList = categories
        .where((category) => widget.savedCategories.contains(category.name))
        .toList();
    final hasNoSavedItems = savedCatList.isEmpty && widget.savedPlaces.isEmpty;

    final isGuest = _currentUser == null || _currentUser!.isGuest;
    final userName = isGuest
        ? tx(_isEnglish, 'Mgeni wa Makambako', 'Makambako Guest')
        : (_currentUser!.name == 'Mwanajamii wa Makambako'
            ? tx(_isEnglish, 'Mwanajamii wa Makambako', 'Makambako Resident')
            : _currentUser!.name);
    final userSubtitle = !isGuest
        ? _currentUser!.phoneOrEmail
        : tx(_isEnglish, 'Akaunti ya Mgeni (Bonyeza Kuingia)', 'Guest Explorer (Tap to Sign In)');

    return Scaffold(
      backgroundColor: MakambakoColors.page,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: widget.onClose != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: MakambakoColors.forest),
                onPressed: widget.onClose,
              )
            : null,
        title: Text(
          tx(_isEnglish, 'Wasifu na Vilivyohifadhiwa', 'Profile & Saved'),
          style: const TextStyle(
            color: MakambakoColors.forest,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Material(
                color: const Color(0xFFEAF3E9),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  key: const ValueKey('profile-language-toggle'),
                  onTap: _toggleLanguage,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.translate_rounded,
                          color: MakambakoColors.forest,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isEnglish ? 'SW' : 'EN',
                          style: const TextStyle(
                            color: MakambakoColors.forest,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: ListView(
        key: const PageStorageKey('profile-page'),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          // Profile User Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE5EDE7)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // The avatar flies from the top bar and enlarges into the
                // profile picture (shared Hero).
                Hero(
                  tag: profileAvatarHeroTag,
                  child: SizedBox(
                    width: 92,
                    height: 92,
                    child: ProfileAvatar(isGuest: isGuest),
                  ),
                ),
                const SizedBox(height: 14),
                RouteStagger(
                  begin: 0.4,
                  end: 0.85,
                  child: Column(
                    children: [
                      Text(
                        _isLoadingUser ? '...' : userName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: MakambakoColors.ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userSubtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: MakambakoColors.muted,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5F0E8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 13,
                              color: MakambakoColors.forest,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _currentUser?.ward == 'Makambako Mjini'
                                  ? tx(_isEnglish, 'Makambako Mjini', 'Makambako Town')
                                  : (_currentUser?.ward ?? locationScope),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: MakambakoColors.forest,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Sign In / Sign Out or Register Action Bar
                RouteStagger(
                  begin: 0.55,
                  child: Row(
                  children: [
                    if (isGuest) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _openOnboarding(OnboardingStep.signIn),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1BAC4B)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.login_rounded, size: 18, color: Color(0xFF1BAC4B)),
                          label: Text(
                            tx(_isEnglish, 'Ingia', 'Sign In'),
                            style: const TextStyle(color: Color(0xFF1BAC4B), fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openOnboarding(OnboardingStep.signUp),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1BAC4B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.person_add_rounded, size: 18),
                          label: Text(
                            tx(_isEnglish, 'Jisajili', 'Sign Up'),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _handleLogout,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red.shade700,
                            side: BorderSide(color: Colors.red.shade200),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.logout_rounded, size: 18),
                          label: Text(
                            tx(_isEnglish, 'Toka kwenye Akaunti', 'Sign Out'),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Section Header: Recent Activity & Bookings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long_rounded, color: MakambakoColors.forest, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        tx(_isEnglish, 'Shughuli na Maagizo', 'Recent Activity'),
                        style: const TextStyle(
                          color: MakambakoColors.ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDFE8E2)),
                ),
                child: Text(
                  '${_bookings.length} ${tx(_isEnglish, 'maagizo', 'items')}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: MakambakoColors.forest,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_bookings.isNotEmpty) ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _bookings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final b = _bookings[index];
                final icon = switch (b.type) {
                  'stay' => Icons.hotel_rounded,
                  'food' => Icons.lunch_dining_rounded,
                  'ride' => Icons.two_wheeler_rounded,
                  'service' => Icons.build_rounded,
                  _ => Icons.receipt_rounded,
                };
                final color = switch (b.type) {
                  'stay' => MakambakoColors.forest,
                  'food' => const Color(0xFFE8552B),
                  'ride' => const Color(0xFF2563EB),
                  'service' => const Color(0xFF7C3AED),
                  _ => MakambakoColors.forest,
                };

                return Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE5EDE7)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _openBookingDetails(b),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(icon, color: color, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        b.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13.5,
                                          color: MakambakoColors.ink,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAF3E9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        b.status,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: MakambakoColors.forest,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  b.subtitle,
                                  style: const TextStyle(fontSize: 11.5, color: MakambakoColors.muted),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'TZS ${b.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: MakambakoColors.forest,
                                      ),
                                    ),
                                    Text(
                                      '${b.createdAt.day}/${b.createdAt.month}/${b.createdAt.year}',
                                      style: const TextStyle(fontSize: 10.5, color: MakambakoColors.muted),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 22),
          ],

          // Section Header: Saved Items (Zilizohifadhiwa)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.bookmark_rounded, color: MakambakoColors.forest, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    tx(_isEnglish, 'Zilizohifadhiwa', 'Saved Items'),
                    style: const TextStyle(
                      color: MakambakoColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDFE8E2)),
                ),
                child: Text(
                  '${widget.savedPlaces.length + savedCatList.length} ${tx(_isEnglish, 'vitu', 'saved')}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: MakambakoColors.forest,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Saved Items Container
          if (hasNoSavedItems)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5EDE7)),
              ),
              child: EmptyState(
                icon: Icons.bookmark_border_rounded,
                title: tx(
                  _isEnglish,
                  'Bado hujachagua maeneo au huduma',
                  'No saved places or categories yet',
                ),
                message: tx(
                  _isEnglish,
                  'Unapogundua huduma, migahawa, au maduka ya Makambako, bonyeza alama ya kitabu kuhifadhi hapa.',
                  'When exploring Makambako places or services, tap the bookmark icon to save them here for quick access.',
                ),
              ),
            ),

          if (widget.savedPlaces.isNotEmpty) ...[
            Text(
              tx(_isEnglish, 'Maeneo Yaliyohifadhiwa', 'Saved Places'),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: MakambakoColors.muted,
              ),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.savedPlaces.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final place = widget.savedPlaces[index];
                final subtitleText = place.location.address ??
                    place.location.displayName ??
                    localizedPlaceCategory(place, _isEnglish);
                return Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE5EDE7)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE5F0E8),
                      child: Icon(Icons.place_rounded, color: Colors.green.shade800),
                    ),
                    title: Text(
                      place.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    subtitle: Text(
                      subtitleText,
                      style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark_remove_rounded, color: Colors.red),
                      onPressed: () => widget.onRemoveSavedPlace?.call(place.id),
                    ),
                    onTap: () => widget.onPlaceSelected?.call(place),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],

          if (savedCatList.isNotEmpty) ...[
            Text(
              tx(_isEnglish, 'Kategoria Zilizohifadhiwa', 'Saved Categories'),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: MakambakoColors.muted,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: savedCatList.map((cat) {
                return Chip(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFDFE8E2)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  label: Text(
                    categoryName(cat, _isEnglish),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: MakambakoColors.forest,
                    ),
                  ),
                  deleteIcon: const Icon(Icons.close_rounded, size: 15),
                  onDeleted: () => widget.onRemoveSavedCategory?.call(cat.name),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 26),

          // App Walkthrough & Settings Section
          Text(
            tx(_isEnglish, 'Mwongozo na Mipangilio', 'Walkthrough & Settings'),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: MakambakoColors.ink,
            ),
          ),
          const SizedBox(height: 10),

          Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: Color(0xFFE5EDE7)),
            ),
            child: Column(
              children: [
                // App Language Switcher Tile
                ListTile(
                  key: const ValueKey('profile-language-tile'),
                  leading: const Icon(Icons.translate_rounded, color: Color(0xFF1BAC4B)),
                  title: Text(
                    tx(_isEnglish, 'Lugha ya App', 'App Language'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: Text(
                    _isEnglish
                        ? 'English (Bonyeza kubadili Kiswahili)'
                        : 'Kiswahili (Tap to switch to English)',
                    style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F0E8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _isEnglish ? 'English' : 'Kiswahili',
                      style: const TextStyle(
                        color: MakambakoColors.forest,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  onTap: _toggleLanguage,
                ),
                const Divider(height: 1, indent: 56),

                // Launch Onboarding Walkthrough Tile
                ListTile(
                  leading: const Icon(Icons.auto_stories_rounded, color: Color(0xFF1BAC4B)),
                  title: Text(
                    tx(_isEnglish, 'Mwongozo wa App (Onboarding)', 'App Walkthrough (Onboarding)'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: Text(
                    tx(_isEnglish, 'Tazama utangulizi na huduma za Makambako', 'Review town features & services walkthrough'),
                    style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _openOnboarding(OnboardingStep.welcomeHero),
                ),
                const Divider(height: 1, indent: 56),

                // Reset Onboarding & Moving Collage Tile
                ListTile(
                  leading: const Icon(Icons.refresh_rounded, color: Color(0xFFE8552B)),
                  title: Text(
                    tx(_isEnglish, 'Weka Upya Utangulizi & Collage', 'Reset Intro & Moving Collage'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: Text(
                    tx(
                      _isEnglish,
                      'Onyesha tena splash ya sekunde na collage app inapofunguliwa',
                      'Show loading seconds and moving collage again on launch',
                    ),
                    style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    await widget.authService.resetOnboarding();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            tx(
                              _isEnglish,
                              'Utangulizi umewekwa upya! Utaona Splash na Collage app ikifunguliwa.',
                              'Intro reset! Splash loading and moving collage will appear again.',
                            ),
                          ),
                          backgroundColor: const Color(0xFF1BAC4B),
                        ),
                      );
                    }
                  },
                ),
                const Divider(height: 1, indent: 56),

                // About Dialog
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded, color: MakambakoColors.forest),
                  title: Text(
                    tx(_isEnglish, 'Kuhusu Makambako Yetu', 'About Makambako Yetu'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: Text(
                    tx(_isEnglish, 'Toleo 1.2.0 • Jukwaa la Mji', 'Version 1.2.0 • Town Platform'),
                    style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Makambako Yetu',
                      applicationVersion: '1.2.0',
                      children: [
                        Text(
                          tx(
                            _isEnglish,
                            'Makambako Yetu huunganisha usafiri wa Bodaboda/Bajaji, chakula, habari, na biashara za mji mzima wa Makambako na Mkoa wa Njombe.',
                            'Makambako Yetu unites ride hailing, food delivery, local news, and businesses across Makambako town and Njombe region.',
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),

                // Support Contact
                ListTile(
                  leading: const Icon(Icons.support_agent_rounded, color: MakambakoColors.forest),
                  title: Text(
                    tx(_isEnglish, 'Msaada na Mawasiliano', 'Help & Contact Support'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: const Text(
                    '+255 768 000 000 • Makambako, Njombe',
                    style: TextStyle(fontSize: 11, color: MakambakoColors.muted),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          tx(
                            _isEnglish,
                            'Ofisi za Makambako Yetu: Karibu na Stand Kuu.',
                            'Makambako Yetu office: Near Central Bus Terminal.',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

