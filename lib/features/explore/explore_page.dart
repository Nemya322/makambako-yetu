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

/// The Explore tab: universal search, category & ward filters, matching places,
/// category list, and the interactive Makambako town map.
class ExplorePage extends StatelessWidget {
  const ExplorePage({
    required this.isEnglish,
    required this.search,
    required this.selectedCategory,
    required this.searchController,
    required this.placeSearchState,
    required this.hasPlaceSearchResults,
    required this.visibleCategoryList,
    required this.savedCategories,
    required this.onSearchChanged,
    required this.onSelectCategory,
    required this.onRetrySearch,
    required this.onPlaceSelected,
    required this.onToggleSavedCategory,
    this.selectedAreaId,
    this.onSelectArea,
    super.key,
  });

  final bool isEnglish;
  final String search;
  final String? selectedCategory;
  final TextEditingController searchController;
  final PlaceSearchState placeSearchState;
  final bool hasPlaceSearchResults;
  final List<CommunityCategory> visibleCategoryList;
  final Set<String> savedCategories;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onSelectCategory;
  final VoidCallback onRetrySearch;
  final ValueChanged<Place> onPlaceSelected;
  final ValueChanged<String> onToggleSavedCategory;
  final String? selectedAreaId;
  final ValueChanged<String?>? onSelectArea;

  @override
  Widget build(BuildContext context) {
    final categories = visibleCategoryList;
    return ListView(
      key: const PageStorageKey('explore-page'),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        Text(
          tx(isEnglish, 'Gundua', 'Explore'),
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
            'Tafuta huduma na maeneo ya Makambako sehemu moja.',
            'Find Makambako services and places in one place.',
          ),
          style: const TextStyle(color: MakambakoColors.muted, fontSize: 14),
        ),
        const SizedBox(height: 19),
        SearchField(
          key: const ValueKey('explore-search'),
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
        const SizedBox(height: 17),

        // Category Filter Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            CategoryFilterChip(
              label: tx(isEnglish, 'Zote', 'All'),
              selected: selectedCategory == null,
              onTap: () => onSelectCategory(null),
            ),
            ...categories.map(
              (category) => CategoryFilterChip(
                label: categoryName(category, isEnglish),
                selected: selectedCategory == category.name,
                onTap: () => onSelectCategory(
                  selectedCategory == category.name ? null : category.name,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Ward/Neighborhood Horizontal Selector (HCI: Hick's law, intuitive location scoping)
        Row(
          children: [
            const Icon(Icons.location_city_rounded, size: 16, color: MakambakoColors.forest),
            const SizedBox(width: 6),
            Text(
              tx(isEnglish, 'Kata ya Makambako:', 'Makambako Ward:'),
              style: const TextStyle(
                color: MakambakoColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              AreaFilterChip(
                label: tx(isEnglish, 'Mitaa Yote', 'All Wards'),
                selected: selectedAreaId == null,
                onTap: () => onSelectArea?.call(null),
              ),
              const SizedBox(width: 6),
              ...makambakoWards.map(
                (ward) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: AreaFilterChip(
                    label: ward.name,
                    selected: selectedAreaId == ward.id,
                    onTap: () => onSelectArea?.call(
                      selectedAreaId == ward.id ? null : ward.id,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        if (hasPlaceSearchResults) ...[
          SectionHeading(
            title: tx(isEnglish, 'Maeneo yanayolingana', 'Matching places'),
          ),
          PlaceSearchResults(
            state: placeSearchState,
            onRetry: onRetrySearch,
            onPlaceSelected: onPlaceSelected,
            isEnglish: isEnglish,
          ),
        ],

        SectionHeading(
          title: tx(isEnglish, 'Vinjari kategoria', 'Browse categories'),
        ),
        const SizedBox(height: 11),
        if (categories.isEmpty)
          EmptyState(
            icon: Icons.search_off_rounded,
            title: tx(isEnglish, 'Hakuna kilichopatikana', 'Nothing found'),
            message: tx(
              isEnglish,
              'Jaribu neno jingine au ondoa kichujio.',
              'Try another search or clear the filter.',
            ),
          )
        else
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: ExploreCategoryTile(
                category: category,
                isEnglish: isEnglish,
                saved: savedCategories.contains(category.name),
                onTap: () => showCategoryDetails(
                  context,
                  category: category,
                  isEnglish: isEnglish,
                  saved: savedCategories.contains(category.name),
                  onToggleSave: () => onToggleSavedCategory(category.name),
                  onAction: () => onSelectCategory(category.name),
                ),
                onSave: () => onToggleSavedCategory(category.name),
              ),
            ),
          ),
        if ((search.isNotEmpty || selectedCategory != null || selectedAreaId != null) &&
            !hasPlaceSearchResults) ...[
          const SizedBox(height: 20),
          SectionHeading(
            title: tx(isEnglish, 'Maeneo yanayolingana', 'Matching places'),
          ),
          PlaceSearchResults(
            state: placeSearchState,
            onRetry: onRetrySearch,
            onPlaceSelected: onPlaceSelected,
            isEnglish: isEnglish,
          ),
        ],

        // Interactive Makambako Map
        MapProviderUnavailableCard(
          isEnglish: isEnglish,
          onPlaceSelected: onPlaceSelected,
        ),
      ],
    );
  }
}

class CategoryFilterChip extends StatelessWidget {
  const CategoryFilterChip({
    super.key,
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
        color: selected ? Colors.white : MakambakoColors.ink,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.white,
      selectedColor: MakambakoColors.forest,
      side: BorderSide(
        color: selected ? MakambakoColors.forest : const Color(0xFFE6EAE5),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      visualDensity: VisualDensity.compact,
    );
  }
}

class AreaFilterChip extends StatelessWidget {
  const AreaFilterChip({
    super.key,
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
        color: selected ? Colors.white : MakambakoColors.ink,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: const Color(0xFFF1F5F9),
      selectedColor: MakambakoColors.forest,
      side: BorderSide(
        color: selected ? MakambakoColors.forest : const Color(0xFFE2E8F0),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
    );
  }
}
