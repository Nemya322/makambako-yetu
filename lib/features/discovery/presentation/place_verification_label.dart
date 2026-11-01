import '../../../core/l10n/app_text.dart';
import '../domain/place.dart';

/// Localized label for a place verification status.
String placeVerificationLabel(PlaceVerificationStatus status, bool isEnglish) {
  return switch (status) {
    PlaceVerificationStatus.verified =>
      tx(isEnglish, 'Imethibitishwa', 'Verified'),
    PlaceVerificationStatus.unverified =>
      tx(isEnglish, 'Haijathibitishwa', 'Unverified'),
    PlaceVerificationStatus.suspended =>
      tx(isEnglish, 'Imesitishwa', 'Suspended'),
    PlaceVerificationStatus.developmentFixture =>
      tx(isEnglish, 'Maendeleo tu', 'Development only'),
  };
}
