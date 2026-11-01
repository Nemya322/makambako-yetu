import 'package:flutter/material.dart';

import '../../core/l10n/app_text.dart';

/// A discovery category shown on the home grid and explore list.
class CommunityCategory {
  const CommunityCategory({
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

/// Canonical category catalog for Makambako Yetu.
const List<CommunityCategory> categories = [
  CommunityCategory(
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
  CommunityCategory(
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
  CommunityCategory(
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
  CommunityCategory(
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
  CommunityCategory(
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
  CommunityCategory(
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
  CommunityCategory(
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
  CommunityCategory(
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

String categoryName(CommunityCategory category, bool english) {
  return localizedCategoryName(category.id, english);
}

String categorySubtitle(CommunityCategory category, bool english) {
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

/// Categories visible for the current search text and selected filter.
///
/// A category matches when every whitespace-separated search term appears in
/// its localized name, subtitle, aliases, or the fixed location scope.
List<CommunityCategory> visibleCategories({
  required String search,
  String? selectedCategory,
  required bool isEnglish,
}) {
  final searchTerms = search
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((term) => term.isNotEmpty);

  return categories.where((category) {
    final matchesCategory = selectedCategory == null ||
        category.name == selectedCategory ||
        categoryName(category, true) == selectedCategory ||
        categoryName(category, false) == selectedCategory;
    final searchableText = [
      categoryName(category, false),
      categoryName(category, true),
      categorySubtitle(category, false),
      categorySubtitle(category, true),
      ...category.searchTerms,
      ...locationSearchTerms,
    ].join(' ').toLowerCase();
    final matchesSearch = searchTerms.every(searchableText.contains);
    return matchesCategory && matchesSearch;
  }).toList();
}

