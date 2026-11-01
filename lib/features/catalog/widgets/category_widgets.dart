import 'package:flutter/material.dart';

import '../../../core/l10n/app_text.dart';
import '../../../core/theme/makambako_theme.dart';
import '../community_category.dart';

/// Rounded category badge used on cards, tiles, and the details sheet.
class CategoryIcon extends StatelessWidget {
  const CategoryIcon({super.key, required this.category, this.size = 42});

  final CommunityCategory category;
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
      child: Icon(
        category.icon,
        color: MakambakoColors.forest,
        size: size * 0.52,
      ),
    );
  }
}

/// Compact category card used in the home grid.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.isEnglish,
    required this.onTap,
  });

  final CommunityCategory category;
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2EDE6)),
          ),
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CategoryIcon(category: category, size: 39),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryName(category, isEnglish),
                    style: const TextStyle(
                      color: MakambakoColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    categorySubtitle(category, isEnglish),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: MakambakoColors.muted,
                      fontSize: 10.5,
                    ),
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

/// Full-width category row used on the explore and saved pages.
class ExploreCategoryTile extends StatelessWidget {
  const ExploreCategoryTile({
    super.key,
    required this.category,
    required this.saved,
    required this.isEnglish,
    required this.onTap,
    required this.onSave,
  });

  final CommunityCategory category;
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
              CategoryIcon(category: category, size: 47),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName(category, isEnglish),
                      style: const TextStyle(
                        color: MakambakoColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categorySubtitle(category, isEnglish),
                      style: const TextStyle(
                        color: MakambakoColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: saved
                    ? tx(
                        isEnglish,
                        'Ondoa kwenye zilizohifadhiwa',
                        'Remove from saved',
                      )
                    : tx(isEnglish, 'Hifadhi', 'Save'),
                onPressed: onSave,
                icon: Icon(
                  saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: MakambakoColors.forest,
                  size: 21,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: MakambakoColors.muted,
                size: 22,
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens the category details sheet with its save/unsave toggle and direct action button.
void showCategoryDetails(
  BuildContext context, {
  required CommunityCategory category,
  required bool isEnglish,
  required bool saved,
  required VoidCallback onToggleSave,
  VoidCallback? onAction,
  String? actionLabel,
}) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CategoryIcon(category: category, size: 52),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  categoryName(category, isEnglish),
                  style: const TextStyle(
                    color: MakambakoColors.ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                tooltip: saved
                    ? tx(
                        isEnglish,
                        'Ondoa kwenye zilizohifadhiwa',
                        'Remove from saved',
                      )
                    : tx(isEnglish, 'Hifadhi', 'Save'),
                onPressed: () {
                  onToggleSave();
                  Navigator.pop(sheetContext);
                },
                icon: Icon(
                  saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: MakambakoColors.forest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: MakambakoColors.page,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: MakambakoColors.green,
                  size: 19,
                ),
                const SizedBox(width: 8),
                const Text(
                  locationScope,
                  style: TextStyle(
                    color: MakambakoColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  tx(isEnglish, 'Eneo la jukwaa', 'Platform area'),
                  style: const TextStyle(
                    color: MakambakoColors.muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            categorySubtitle(category, isEnglish),
            style: const TextStyle(
              color: MakambakoColors.muted,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tx(
              isEnglish,
              'Sehemu hii itakusaidia kugundua taarifa, huduma na biashara za '
                  'Makambako kadri zinavyoongezwa kwenye jukwaa.',
              'This section helps you discover information, services, and businesses '
                  'in Makambako as they are added to the platform.',
            ),
            style: const TextStyle(color: MakambakoColors.ink, fontSize: 13.5, height: 1.5),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.pop(sheetContext);
                onAction?.call();
              },
              icon: Icon(
                switch (category.id) {
                  'transport' => Icons.two_wheeler_rounded,
                  'food' => Icons.lunch_dining_rounded,
                  'accommodation' => Icons.hotel_rounded,
                  'services' => Icons.build_rounded,
                  _ => Icons.search_rounded,
                },
                size: 18,
              ),
              label: Text(
                actionLabel ??
                    switch (category.id) {
                      'transport' => tx(isEnglish, 'Fungua Usafiri', 'Open Ride Hailing'),
                      'food' => tx(isEnglish, 'Agiza Chakula', 'Order Food Delivery'),
                      'accommodation' => tx(isEnglish, 'Weka Chumba cha Wageni', 'Book Guest House'),
                      'services' => tx(isEnglish, 'Tafuta Fundi', 'Find Local Pro'),
                      _ => tx(isEnglish, 'Tazama Maeneo', 'View Matching Places'),
                    },
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: MakambakoColors.forest,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
