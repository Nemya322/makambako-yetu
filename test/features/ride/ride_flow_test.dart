import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_yetu_app/features/ride/ride_page.dart';

void main() {
  group('Ride Flow Lifecycle Integration Tests', () {
    testWidgets('boots into Stage 1 Choose and transitions through all 4 stages', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: RidePage(
            isEnglish: true,
            initialPickup: 'Main Market, Makambako',
            initialDestination: 'Bus Stand, Makambako',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Stage 1 (Choose) assertions
      expect(find.byKey(const ValueKey('stage-choose-view')), findsOneWidget);
      expect(find.text('Main Market, Makambako'), findsOneWidget);
      expect(find.text('Bus Stand, Makambako'), findsOneWidget);
      expect(find.byKey(const ValueKey('request-ride-button')), findsOneWidget);

      // Tap Request Ride -> Transitions to Stage 2 (Finding)
      await tester.tap(find.byKey(const ValueKey('request-ride-button')));
      await tester.pump(const Duration(milliseconds: 400));

      // Stage 2 (Finding) assertions
      expect(find.byKey(const ValueKey('stage-finding-view')), findsOneWidget);
      expect(find.text('Finding your rider'), findsOneWidget);

      // Boost fare by 500 TSh
      final boostChip = find.text('+ TSh 500');
      expect(boostChip, findsOneWidget);
      await tester.tap(boostChip);
      await tester.pump(const Duration(milliseconds: 300));

      // Verify boost is reflected in total
      expect(find.textContaining('priority boost active'), findsOneWidget);

      // Wait 3 seconds for matching timer -> Transitions to Stage 3 (Arriving)
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Stage 3 (Arriving) assertions
      expect(find.byKey(const ValueKey('stage-arriving-view')), findsOneWidget);
      expect(find.text('Hassan K.'), findsOneWidget);
      expect(find.text('T 482 DKF'), findsOneWidget);

      // Verify 4-digit security PIN
      for (final digit in ['4', '7', '2', '9']) {
        expect(find.text(digit), findsOneWidget);
      }

      // Tap Simulate Arrival -> Transitions to Stage 4 (Arrived)
      final arrivalBtn = find.byKey(const ValueKey('simulate-arrived-button'));
      expect(arrivalBtn, findsOneWidget);
      await tester.tap(arrivalBtn);
      await tester.pumpAndSettle();

      // Stage 4 (Arrived) assertions
      expect(find.byKey(const ValueKey('stage-arrived-view')), findsOneWidget);
      expect(find.text("You've arrived"), findsOneWidget);

      // Tip driver with 1,000 TSh
      final tip1000 = find.text('TSh 1,000');
      expect(tip1000, findsOneWidget);
      await tester.tap(tip1000);
      await tester.pumpAndSettle();

      // Tap Done -> Resets back to Stage 1 (Choose)
      final finishBtn = find.byKey(const ValueKey('finish-ride-button'));
      expect(finishBtn, findsOneWidget);
      await tester.tap(finishBtn);
      await tester.pumpAndSettle();

      // Back on Stage 1
      expect(find.byKey(const ValueKey('stage-choose-view')), findsOneWidget);
    });

    testWidgets('cancelling during Finding returns immediately to Choose stage', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: RidePage(
            isEnglish: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Request ride
      await tester.tap(find.byKey(const ValueKey('request-ride-button')));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byKey(const ValueKey('stage-finding-view')), findsOneWidget);

      // Tap Cancel request (Ghairi ombi)
      final cancelBtn = find.text('Ghairi ombi');
      expect(cancelBtn, findsOneWidget);
      await tester.tap(cancelBtn);
      await tester.pumpAndSettle();

      // Back on Choose stage
      expect(find.byKey(const ValueKey('stage-choose-view')), findsOneWidget);
    });

    testWidgets('swapping pickup and dropoff updates endpoints', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: RidePage(
            isEnglish: true,
            initialPickup: 'Point A',
            initialDestination: 'Point B',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Point A'), findsOneWidget);
      expect(find.text('Point B'), findsOneWidget);

      // Tap swap icon
      await tester.tap(find.byTooltip('Swap pickup and drop-off'));
      await tester.pumpAndSettle();

      // Endpoints swapped
      expect(find.text('Point B'), findsOneWidget);
      expect(find.text('Point A'), findsOneWidget);
    });
  });
}
