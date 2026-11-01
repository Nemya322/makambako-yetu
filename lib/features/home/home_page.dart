import 'package:flutter/material.dart';

import '../../core/l10n/app_text.dart';
import '../../core/theme/makambako_theme.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/search_field.dart';
import '../../core/widgets/section_heading.dart';
import '../catalog/community_category.dart';
import '../catalog/widgets/category_widgets.dart';
import '../discovery/data/development_fixture_place_repository.dart';
import '../discovery/domain/place.dart';
import '../discovery/presentation/place_search_results.dart';

/// The Home tab: welcome banner, quick services bar, universal search, place results,
/// featured places, food delivery highlight, and aligned category grid.
class HomePage extends StatelessWidget {
  const HomePage({
    required this.isEnglish,
    required this.search,
    required this.searchController,
    required this.placeSearchState,
    required this.hasPlaceSearchResults,
    required this.visibleCategoryList,
    required this.onSearchChanged,
    required this.onRetrySearch,
    required this.onPlaceSelected,
    required this.onExploreTab,
    required this.onCategoryOpened,
    this.onRideTab,
    this.onFoodTab,
    this.onNewsTab,
    this.onStaysOpened,
    this.onServicesOpened,
    super.key,
  });

  final bool isEnglish;
  final String search;
  final TextEditingController searchController;
  final PlaceSearchState placeSearchState;
  final bool hasPlaceSearchResults;
  final List<CommunityCategory> visibleCategoryList;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onRetrySearch;
  final ValueChanged<Place> onPlaceSelected;
  final VoidCallback onExploreTab;
  final ValueChanged<CommunityCategory> onCategoryOpened;
  final VoidCallback? onRideTab;
  final VoidCallback? onFoodTab;
  final VoidCallback? onNewsTab;
  final ValueChanged<String?>? onStaysOpened;
  final VoidCallback? onServicesOpened;

  @override
  Widget build(BuildContext context) {
    final categories = visibleCategoryList;

    return ListView(
      key: const PageStorageKey('home-page'),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        // Welcome Banner
        WelcomeBanner(isEnglish: isEnglish, onExplore: onExploreTab),
        const SizedBox(height: 16),

        // Quick Service Action Bar (Ride, Food, Stays, Services, News, Explore)
        _QuickServicesBar(
          isEnglish: isEnglish,
          onRide: onRideTab ?? onExploreTab,
          onFood: onFoodTab ?? onExploreTab,
          onStays: () => onStaysOpened?.call('LALA15'),
          onServices: onServicesOpened ?? onExploreTab,
          onNews: onNewsTab ?? onExploreTab,
          onExplore: onExploreTab,
        ),
        const SizedBox(height: 18),

        // Universal Search
        SearchField(
          key: const ValueKey('home-search'),
          controller: searchController,
          isEnglish: isEnglish,
          onChanged: onSearchChanged,
        ),
        if (placeSearchState is PlaceSearchLoading)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(
              color: MakambakoColors.green,
              backgroundColor: Color(0xFFE5F0E8),
              minHeight: 2,
            ),
          ),

        // Search Results
        if (search.isNotEmpty && hasPlaceSearchResults) ...[
          const SizedBox(height: 18),
          SectionHeading(
            title: tx(isEnglish, 'Matokeo ya maeneo', 'Place results'),
          ),
          const SizedBox(height: 10),
          PlaceSearchResults(
            state: placeSearchState,
            onRetry: onRetrySearch,
            onPlaceSelected: onPlaceSelected,
            isEnglish: isEnglish,
          ),
        ],

        // Featured Makambako Landmarks (Realigned for clean layout)
        if (search.isEmpty) ...[
          const SizedBox(height: 22),
          SectionHeading(
            title: tx(isEnglish, 'Maeneo Muhimu Makambako', 'Featured Makambako Spots'),
            action: tx(isEnglish, 'Ramani', 'Map'),
            onAction: onExploreTab,
          ),
          const SizedBox(height: 12),
          _FeaturedPlacesScroller(
            isEnglish: isEnglish,
            onPlaceSelected: onPlaceSelected,
            onRideRequested: onRideTab,
          ),

          // Food Delivery Highlight Banner
          const SizedBox(height: 22),
          _FoodHighlightStrip(
            isEnglish: isEnglish,
            onOrderNow: onFoodTab ?? onExploreTab,
          ),
        ],

        // Aligned Category Grid
        const SizedBox(height: 24),
        SectionHeading(
          title: tx(isEnglish, 'Vinjari Makambako', 'Explore Makambako'),
          action: tx(isEnglish, 'Ona zote', 'See all'),
          onAction: onExploreTab,
        ),
        const SizedBox(height: 12),
        if (categories.isEmpty)
          EmptyState(
            icon: Icons.search_off_rounded,
            title: tx(isEnglish, 'Hakuna kilichopatikana', 'Nothing found'),
            message: tx(
              isEnglish,
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
              childAspectRatio: 1.36,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(
                category: category,
                isEnglish: isEnglish,
                onTap: () => onCategoryOpened(category),
              );
            },
          ),
        const SizedBox(height: 20),

        // Stays & Accommodations Promo Card (Integrated with promo LALA15)
        if (search.isEmpty) ...[
          _StaysPromoCard(
            isEnglish: isEnglish,
            onBookStay: (promo) => onStaysOpened?.call(promo),
          ),
          const SizedBox(height: 20),
        ],

        if (search.isNotEmpty && !hasPlaceSearchResults) ...[
          SectionHeading(
            title: tx(isEnglish, 'Matokeo ya maeneo', 'Place results'),
          ),
          const SizedBox(height: 10),
          PlaceSearchResults(
            state: placeSearchState,
            onRetry: onRetrySearch,
            onPlaceSelected: onPlaceSelected,
            isEnglish: isEnglish,
          ),
        ],

        CommunityCard(isEnglish: isEnglish, onTap: onNewsTab ?? onExploreTab),
      ],
    );
  }
}

/// Quick action buttons on Home for Ride, Food, Stays, Services, News, and Directory.
class _QuickServicesBar extends StatelessWidget {
  const _QuickServicesBar({
    required this.isEnglish,
    required this.onRide,
    required this.onFood,
    required this.onNews,
    required this.onExplore,
    this.onStays,
    this.onServices,
  });

  final bool isEnglish;
  final VoidCallback onRide;
  final VoidCallback onFood;
  final VoidCallback onNews;
  final VoidCallback onExplore;
  final VoidCallback? onStays;
  final VoidCallback? onServices;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildServiceItem(
            icon: Icons.two_wheeler_rounded,
            color: const Color(0xFF145C45),
            bgColor: const Color(0xFFE5F0E8),
            label: tx(isEnglish, 'Usafiri', 'Rides'),
            onTap: onRide,
          ),
          const SizedBox(width: 10),
          _buildServiceItem(
            icon: Icons.lunch_dining_rounded,
            color: const Color(0xFFD97706),
            bgColor: const Color(0xFFFEF3C7),
            label: tx(isEnglish, 'Chakula', 'Food'),
            onTap: onFood,
          ),
          const SizedBox(width: 10),
          _buildServiceItem(
            key: const ValueKey('quick-service-stays'),
            icon: Icons.hotel_rounded,
            color: const Color(0xFF4F46E5),
            bgColor: const Color(0xFFEEF2FF),
            label: tx(isEnglish, 'Malazi', 'Stays'),
            badge: '15% OFF',
            onTap: onStays ?? onExplore,
          ),
          const SizedBox(width: 10),
          _buildServiceItem(
            icon: Icons.handyman_rounded,
            color: const Color(0xFF0D9488),
            bgColor: const Color(0xFFCCFBF1),
            label: tx(isEnglish, 'Huduma', 'Services'),
            onTap: onServices ?? onExplore,
          ),
          const SizedBox(width: 10),
          _buildServiceItem(
            icon: Icons.newspaper_rounded,
            color: const Color(0xFF2563EB),
            bgColor: const Color(0xFFDBEAFE),
            label: tx(isEnglish, 'Habari', 'News'),
            onTap: onNews,
          ),
          const SizedBox(width: 10),
          _buildServiceItem(
            icon: Icons.map_rounded,
            color: const Color(0xFF7C3AED),
            bgColor: const Color(0xFFEDE9FE),
            label: tx(isEnglish, 'Ramani', 'Map'),
            onTap: onExplore,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem({
    Key? key,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String label,
    required VoidCallback onTap,
    String? badge,
  }) {
    return Material(
      key: key,
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 82,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE6EFE8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  if (badge != null)
                    Positioned(
                      top: -4,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: MakambakoColors.ink,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Swift UI Styled Accommodation / Stays Promo Banner linking to GuestHouseBookingPage
class _StaysPromoCard extends StatelessWidget {
  const _StaysPromoCard({
    required this.isEnglish,
    required this.onBookStay,
  });

  final bool isEnglish;
  final ValueChanged<String?> onBookStay;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2B1D), Color(0xFF1E3A5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F2B1D).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.hotel_rounded,
              size: 130,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_offer_rounded, size: 12, color: Colors.black),
                          const SizedBox(width: 4),
                          Text(
                            tx(isEnglish, 'PUNGUZO 15% • KODI: LALA15', '15% OFF • CODE: LALA15'),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, size: 13, color: Color(0xFFFBBF24)),
                          SizedBox(width: 3),
                          Text(
                            '4.8',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  tx(isEnglish, 'Malazi & Hoteli za Makambako', 'Stays & Lodges in Makambako'),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tx(
                    isEnglish,
                    'Sunrise, Midland & Lodges safi mjini zenye maji moto, Wi-Fi na usalama.',
                    'Sunrise, Midland & town lodges with hot shower, Wi-Fi & security.',
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx(isEnglish, 'Kuanzia', 'From'),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'TSh 21,250',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFBBF24),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '/ usiku',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    FilledButton.icon(
                      key: const ValueKey('home-book-stay-promo-button'),
                      onPressed: () => onBookStay('LALA15'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFBBF24),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.black),
                      label: Text(
                        tx(isEnglish, 'Weka Chumba', 'Book Stay'),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Aligned, modern featured spot cards with clear hierarchy.
class _FeaturedPlacesScroller extends StatelessWidget {
  const _FeaturedPlacesScroller({
    required this.isEnglish,
    required this.onPlaceSelected,
    this.onRideRequested,
  });

  final bool isEnglish;
  final ValueChanged<Place> onPlaceSelected;
  final VoidCallback? onRideRequested;

  @override
  Widget build(BuildContext context) {
    final places = DevelopmentFixturePlaceRepository.featuredPlaces;

    return SizedBox(
      height: 156,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index == places.length - 1 ? 0 : 12,
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => onPlaceSelected(place),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2EDE6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF3E9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              localizedPlaceCategory(place, isEnglish),
                              style: const TextStyle(
                                color: MakambakoColors.forest,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (place.rating != null)
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 15, color: Color(0xFFD97706)),
                                const SizedBox(width: 2),
                                Text(
                                  place.rating!.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      Text(
                        place.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MakambakoColors.ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          height: 1.25,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 13, color: MakambakoColors.muted),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              place.location.area.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: MakambakoColors.muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F6F2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  tx(isEnglish, 'Tazama', 'View'),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: MakambakoColors.forest,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Icon(Icons.arrow_forward_rounded, size: 12, color: MakambakoColors.forest),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Food highlight card encouraging users to order delivery.
class _FoodHighlightStrip extends StatelessWidget {
  const _FoodHighlightStrip({
    required this.isEnglish,
    required this.onOrderNow,
  });

  final bool isEnglish;
  final VoidCallback onOrderNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2EDE6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.lunch_dining_rounded,
              color: Color(0xFFD97706),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx(isEnglish, 'Njaa inakusumbua Makambako?', 'Hungry in Makambako?'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: MakambakoColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tx(
                    isEnglish,
                    'Chips Mayai, Nyama Choma & Kuku moto (dakika 20)',
                    'Hot Chips Mayai, BBQ & Chicken in 20 mins',
                  ),
                  style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: onOrderNow,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF145C45),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              tx(isEnglish, 'Agiza', 'Order'),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({
    super.key,
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
          colors: [MakambakoColors.forest, Color(0xFF27805B)],
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
                  tx(isEnglish, 'KARIBU NYUMBANI', 'WELCOME HOME'),
                  style: const TextStyle(
                    color: Color(0xFFE8F3C8),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                tx(isEnglish, 'Makambako,\nyetu sote.', 'Makambako,\nour home.'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                tx(
                  isEnglish,
                  'Biashara, huduma na maeneo — yote ya Makambako sehemu moja.',
                  'Businesses, services, and places — all of Makambako in one place.',
                ),
                style: const TextStyle(
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
                  foregroundColor: MakambakoColors.forest,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tx(isEnglish, 'Anza kugundua', 'Start exploring'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 16),
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

class CommunityCard extends StatelessWidget {
  const CommunityCard({super.key, required this.isEnglish, required this.onTap});

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
                  Icons.newspaper_rounded,
                  color: MakambakoColors.forest,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx(isEnglish, 'Habari na Matangazo ya Jamii', 'Community News & Bulletins'),
                      style: const TextStyle(
                        color: MakambakoColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tx(
                        isEnglish,
                        'Pata taarifa za masoko, mnada na matukio ya Makambako.',
                        'Get live market days, auction and town updates.',
                      ),
                      style: const TextStyle(
                        color: MakambakoColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: MakambakoColors.forest,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
