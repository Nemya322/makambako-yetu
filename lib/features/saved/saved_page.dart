import 'package:flutter/material.dart';

import '../../core/l10n/app_text.dart';
import '../../core/theme/makambako_theme.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/section_heading.dart';
import '../catalog/community_category.dart';
import '../catalog/widgets/category_widgets.dart';
import '../discovery/domain/place.dart';

/// The Saved tab: bookmarked places and categories with instant retrieval and removal.
class SavedPage extends StatelessWidget {
  const SavedPage({
    required this.isEnglish,
    required this.savedCategories,
    required this.onRemoveSavedCategory,
    required this.onExploreTab,
    this.savedPlaces = const [],
    this.onRemoveSavedPlace,
    this.onPlaceSelected,
    super.key,
  });

  final bool isEnglish;
  final Set<String> savedCategories;
  final ValueChanged<String> onRemoveSavedCategory;
  final VoidCallback onExploreTab;
  final List<Place> savedPlaces;
  final ValueChanged<String>? onRemoveSavedPlace;
  final ValueChanged<Place>? onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    final savedCatList = categories
        .where((category) => savedCategories.contains(category.name))
        .toList();
    final hasNoSavedItems = savedCatList.isEmpty && savedPlaces.isEmpty;

    return ListView(
      key: const PageStorageKey('saved-page'),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        Text(
          tx(isEnglish, 'Zilizohifadhiwa', 'Saved'),
          style: const TextStyle(
            color: MakambakoColors.ink,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          tx(
            isEnglish,
            'Maeneo na huduma ulizoweka pembeni kwa ajili yako.',
            'Places and services you have saved for later.',
          ),
          style: const TextStyle(color: MakambakoColors.muted, fontSize: 14),
        ),
        const SizedBox(height: 20),
        if (hasNoSavedItems) ...[
          EmptyState(
            icon: Icons.bookmark_border_rounded,
            title: tx(
              isEnglish,
              'Bado hujahifadhi chochote',
              'Nothing saved yet',
            ),
            message: tx(
              isEnglish,
              'Gundua maeneo na uguse alama ya kuhifadhi ili uyaone hapa.',
              'Explore places and tap the bookmark icon to save them here.',
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: FilledButton.icon(
              onPressed: onExploreTab,
              icon: const Icon(Icons.explore_rounded, size: 18),
              label: Text(tx(isEnglish, 'Anza kugundua', 'Start exploring')),
              style: FilledButton.styleFrom(
                backgroundColor: MakambakoColors.forest,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ] else ...[
          // Saved Places Section
          if (savedPlaces.isNotEmpty) ...[
            SectionHeading(
              title: tx(isEnglish, 'Maeneo Yaliyohifadhiwa', 'Saved Places'),
            ),
            const SizedBox(height: 10),
            ...savedPlaces.map(
              (place) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    onTap: () => onPlaceSelected?.call(place),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF3E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.place_rounded, color: MakambakoColors.forest, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place.name,
                                  style: const TextStyle(
                                    color: MakambakoColors.ink,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${localizedPlaceCategory(place, isEnglish)} · ${place.location.area.name}',
                                  style: const TextStyle(color: MakambakoColors.muted, fontSize: 12),
                                ),
                                if (place.phone != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone_rounded, size: 11, color: MakambakoColors.forest),
                                      const SizedBox(width: 4),
                                      Text(
                                        place.phone!,
                                        style: const TextStyle(color: MakambakoColors.muted, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.bookmark_remove_rounded, color: Color(0xFFEF4444), size: 22),
                            tooltip: tx(isEnglish, 'Ondoa', 'Remove'),
                            onPressed: () => onRemoveSavedPlace?.call(place.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Saved Categories Section
          if (savedCatList.isNotEmpty) ...[
            SectionHeading(
              title: tx(isEnglish, 'Kategoria Zilizohifadhiwa', 'Saved Categories'),
            ),
            const SizedBox(height: 10),
            ...savedCatList.map(
              (category) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: ExploreCategoryTile(
                  category: category,
                  saved: true,
                  isEnglish: isEnglish,
                  onTap: () => showCategoryDetails(
                    context,
                    category: category,
                    isEnglish: isEnglish,
                    saved: true,
                    onToggleSave: () => onRemoveSavedCategory(category.name),
                    onAction: onExploreTab,
                  ),
                  onSave: () => onRemoveSavedCategory(category.name),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
