import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mk_yetu_app/core/activity/activity_service.dart';
import 'package:mk_yetu_app/core/activity/booking_record.dart';
import 'package:mk_yetu_app/features/discovery/data/development_fixture_place_repository.dart';
import 'package:mk_yetu_app/features/shell/makambako_home_page.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Cross-Journey Integration & Persistence Tests', () {
    test('ActivityService records, persists, and retrieves typed bookings', () async {
      final service = ActivityService();
      final initial = await service.getBookings();
      expect(initial.isNotEmpty, isTrue, reason: 'Should have initial demo activities');

      final testBooking = BookingRecord(
        id: 'TEST-123',
        type: 'stay',
        title: 'Midland Golden Hotel: Executive Room',
        subtitle: '1 Usiku · Wageni 2',
        amount: 85000,
        status: 'Imethibitishwa',
        createdAt: DateTime.now(),
        placeId: 'mko-midland-hotel',
        metadata: {'nights': 1, 'guests': 2},
      );

      await service.recordBooking(testBooking);

      final updated = await service.getBookings();
      expect(updated.any((b) => b.id == 'TEST-123'), isTrue);
      final found = updated.firstWhere((b) => b.id == 'TEST-123');
      expect(found.amount, 85000);
      expect(found.placeId, 'mko-midland-hotel');
    });

    test('Canonical fixture places lookup works synchronously for map pins and news', () {
      final standKuu = DevelopmentFixturePlaceRepository.findPlaceById('mko-stand-kuu');
      expect(standKuu, isNotNull);
      expect(standKuu!.name, contains('Stand Kuu'));

      final soko = DevelopmentFixturePlaceRepository.findPlaceById('mko-soko-mwembetogwa');
      expect(soko, isNotNull);
      expect(soko!.categoryId, 'businesses');

      final hospital = DevelopmentFixturePlaceRepository.findPlaceById('mko-hospital-st-joseph');
      expect(hospital, isNotNull);
      expect(hospital!.rating, greaterThan(4.0));
    });

    testWidgets('MakambakoHomePage tabs navigate smoothly and back button pops to Home tab', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MakambakoHomePage(
            placeRepository: DevelopmentFixturePlaceRepository(),
            initialIsEnglish: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Starts on Home tab
      expect(find.text('Nyumbani'), findsWidgets);
      expect(find.text('KARIBU NYUMBANI'), findsWidgets);

      // Tap on 'Usafiri' (Ride tab)
      await tester.tap(find.byIcon(Icons.two_wheeler_outlined));
      await tester.pumpAndSettle();

      // Ride stage 1 should be active
      expect(find.byKey(const ValueKey('stage-choose-view')), findsOneWidget);

      // Simulate Android back button trigger on shell PopScope
      final popScopeFinder = find.byWidgetPredicate((w) => w is PopScope);
      final popScope = tester.widget<PopScope>(popScopeFinder.first);
      popScope.onPopInvokedWithResult?.call(false, null);
      await tester.pumpAndSettle();

      // Should return to Home tab (Tab 0)
      expect(find.text('KARIBU NYUMBANI'), findsWidgets);
    });

    testWidgets('Tapping food tab opens FoodDeliveryPage and can back to home', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MakambakoHomePage(
            placeRepository: DevelopmentFixturePlaceRepository(),
            initialIsEnglish: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on 'Chakula' (Food tab)
      await tester.tap(find.byIcon(Icons.lunch_dining_outlined));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('food-feed-page')), findsOneWidget);

      // Android back via shell PopScope
      final popScopeFinder = find.byWidgetPredicate((w) => w is PopScope);
      final popScope = tester.widget<PopScope>(popScopeFinder.first);
      popScope.onPopInvokedWithResult?.call(false, null);
      await tester.pumpAndSettle();

      expect(find.text('KARIBU NYUMBANI'), findsWidgets);
    });
  });
}
