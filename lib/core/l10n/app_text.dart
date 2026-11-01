/// Picks the Swahili or English variant of a UI string.
///
/// Interim helper until Flutter's generated localization (ARB) replaces it;
/// every user-facing string must keep both variants side by side.
String tx(bool english, String swahili, String englishText) =>
    english ? englishText : swahili;

/// Shared location scope shown across the app.
const String locationScope = 'Makambako, Njombe';

/// Search terms that always match the app's fixed location scope.
const List<String> locationSearchTerms = [
  'Makambako',
  'Njombe',
  'karibu',
  'nearby',
];

/// Key used for storing the user's language preference across app launches.
const String isEnglishKey = 'mk_yetu.isEnglish';

/// Resolves a category ID to its localized display title.
String localizedCategoryName(String categoryId, bool english) {
  if (!english) {
    return switch (categoryId) {
      'businesses' => 'Biashara',
      'food' => 'Chakula',
      'services' => 'Huduma',
      'transport' => 'Usafiri',
      'accommodation' => 'Malazi',
      'events' => 'Matukio',
      'places' => 'Maeneo',
      'community' => 'Jamii',
      _ => categoryId,
    };
  }
  return switch (categoryId) {
    'businesses' => 'Business',
    'food' => 'Food',
    'services' => 'Services',
    'transport' => 'Transport',
    'accommodation' => 'Accommodation',
    'events' => 'Events',
    'places' => 'Places',
    'community' => 'Community',
    _ => categoryId,
  };
}

/// Resolves a Place's category to its localized string.
String localizedPlaceCategory(dynamic place, bool english) {
  try {
    final catId = (place.categoryId as String?) ?? '';
    if (catId.isNotEmpty) {
      return localizedCategoryName(catId, english);
    }
    return (place.categoryName as String?) ?? '';
  } catch (_) {
    return (place.categoryName as String?) ?? '';
  }
}

