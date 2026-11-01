import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_yetu_app/features/discovery/data/development_fixture_place_repository.dart';
import 'package:mk_yetu_app/features/stays/guest_house_booking_page.dart';
import 'package:mk_yetu_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('GuestHouseBookingPage Standalone Operation', () {
    testWidgets('operates independently without initial promo code', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: GuestHouseBookingPage(
            isEnglish: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check header and default Double room
      expect(find.text('Sunrise Guest House'), findsOneWidget);
      expect(find.text('Double room'), findsWidgets);

      // Verify promo input box is visible and no promo is applied yet
      final inputBox = find.byKey(const ValueKey('hotel-promo-input-box'));
      await tester.scrollUntilVisible(inputBox, 200, scrollable: find.byType(Scrollable).first);
      expect(inputBox, findsOneWidget);
      expect(find.byKey(const ValueKey('hotel-promo-applied-badge')), findsNothing);

      // Enter promo code manually
      await tester.enterText(find.byType(TextField), 'LALA15');
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Promo badge should now appear with 15% discount
      final appliedBadge = find.byKey(const ValueKey('hotel-promo-applied-badge'));
      expect(appliedBadge, findsOneWidget);
      expect(find.textContaining('15% Discount Applied'), findsOneWidget);

      // Remove promo
      final removeBtn = find.text('Remove');
      await tester.scrollUntilVisible(removeBtn, 150, scrollable: find.byType(Scrollable).first);
      await tester.tap(removeBtn);
      await tester.pumpAndSettle();

      // Promo badge is gone, input is restored
      expect(find.byKey(const ValueKey('hotel-promo-applied-badge')), findsNothing);
      expect(find.byKey(const ValueKey('hotel-promo-input-box')), findsOneWidget);

      // Dismiss any active SnackBar before confirming
      ScaffoldMessenger.of(tester.element(find.byType(GuestHouseBookingPage))).clearSnackBars();
      await tester.pumpAndSettle();

      // Complete booking
      await tester.tap(find.byKey(const ValueKey('confirm-hotel-booking-button')));
      await tester.pumpAndSettle();

      // Verify booking confirmation screen with booking ID
      expect(find.text('SG-48213'), findsOneWidget);
      expect(find.textContaining('Sunrise Guest House'), findsWidgets);
    });

    testWidgets('operates with pre-applied promo code', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: GuestHouseBookingPage(
            isEnglish: false,
            initialPromoCode: 'LALA15',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Promo should be pre-applied automatically
      expect(find.byKey(const ValueKey('hotel-promo-applied-badge')), findsOneWidget);
      expect(find.textContaining('Punguzo la 15% Limetumika'), findsOneWidget);

      // Confirm booking with promo applied
      await tester.tap(find.byKey(const ValueKey('confirm-hotel-booking-button')));
      await tester.pumpAndSettle();

      // Verify confirmation screen shows applied promo savings
      expect(find.text('SG-48213'), findsOneWidget);
      expect(find.textContaining('LALA15'), findsOneWidget);
    });
  });

  group('Home Page to Accommodation Promo Integration', () {
    testWidgets('tapping Stays promo card on Home opens GuestHouseBookingPage with promo applied', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MakambakoYetuApp(
          placeRepository: DevelopmentFixturePlaceRepository(),
          startWithSplash: false,
          startWithOnboarding: false,
          initialIsEnglish: false,
        ),
      );
      await tester.pumpAndSettle();

      // Find the promo button on the Home page and ensure it's visible
      final promoButton = find.byKey(const ValueKey('home-book-stay-promo-button'));
      await tester.scrollUntilVisible(promoButton, 300, scrollable: find.byType(Scrollable).first);
      expect(promoButton, findsOneWidget);

      // Tap the promo button
      await tester.tap(promoButton);
      await tester.pumpAndSettle();

      // Should have navigated to GuestHouseBookingPage with LALA15 pre-applied
      expect(find.byKey(const ValueKey('guesthouse-booking-screen')), findsOneWidget);
      expect(find.byKey(const ValueKey('hotel-promo-applied-badge')), findsOneWidget);
      expect(find.textContaining('LALA15'), findsWidgets);
      expect(find.textContaining('Punguzo la 15% Limetumika'), findsOneWidget);

      // Verify back navigation returns to Home page safely
      await tester.tap(find.byKey(const ValueKey('guesthouse-back-button')));
      await tester.pumpAndSettle();

      // Back on Home page at previous scroll position
      expect(find.byKey(const ValueKey('home-book-stay-promo-button')), findsOneWidget);
    });

    testWidgets('tapping Stays quick action button on Home opens GuestHouse with promo code', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MakambakoYetuApp(
          placeRepository: DevelopmentFixturePlaceRepository(),
          startWithSplash: false,
          startWithOnboarding: false,
          initialIsEnglish: false,
        ),
      );
      await tester.pumpAndSettle();

      // Tap Quick Services Stays button using unique key
      final staysAction = find.byKey(const ValueKey('quick-service-stays'));
      expect(staysAction, findsOneWidget);
      await tester.tap(staysAction);
      await tester.pumpAndSettle();

      // Opens GuestHouseBookingPage with promo code
      expect(find.byKey(const ValueKey('guesthouse-booking-screen')), findsOneWidget);
      expect(find.byKey(const ValueKey('hotel-promo-applied-badge')), findsOneWidget);
      expect(find.textContaining('LALA15'), findsWidgets);
    });
  });
}
