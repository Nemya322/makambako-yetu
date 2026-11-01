import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mk_yetu_app/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('home introduces Makambako Yetu and its local categories', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MakambakoYetuApp());

    expect(find.text('KARIBU NYUMBANI'), findsOneWidget);
    expect(find.text('Makambako,\nyetu sote.'), findsOneWidget);
    expect(find.text('Biashara'), findsWidgets);
    expect(find.text('Usafiri'), findsWidgets);
    expect(find.text('Chakula'), findsWidgets);
  });

  testWidgets('language toggle switches the app between Swahili and English', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MakambakoYetuApp());

    expect(find.text('EN'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('language-toggle')));
    await tester.pumpAndSettle();

    expect(find.text('SW'), findsOneWidget);
    expect(find.text('WELCOME HOME'), findsOneWidget);
    expect(find.text('Explore Makambako'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('language-toggle')));
    await tester.pumpAndSettle();

    expect(find.text('EN'), findsOneWidget);
    expect(find.text('KARIBU NYUMBANI'), findsOneWidget);
  });

  testWidgets('news tab shows updates and community events', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MakambakoYetuApp());

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Habari'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Habari za Makambako'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Nyumbani'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Makambako,\nyetu sote.'), findsOneWidget);
  });

  testWidgets('universal search matches English aliases across categories', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MakambakoYetuApp());
    await tester.enterText(find.byKey(const ValueKey('home-search')), 'hotel');
    await tester.pumpAndSettle();

    expect(find.text('Hoteli na sehemu za kukaa'), findsOneWidget);
    expect(find.text('Migahawa na sehemu za kula'), findsNothing);

    await tester.tap(find.text('Gundua'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: find.byKey(const ValueKey('explore-search')),
              matching: find.byType(TextField),
            ),
          )
          .controller!
          .text,
      'hotel',
    );

    await tester.enterText(
      find.byKey(const ValueKey('explore-search')),
      'restaurant',
    );
    await tester.pumpAndSettle();

    expect(find.text('Migahawa na sehemu za kula'), findsOneWidget);
    expect(find.text('Hoteli na sehemu za kukaa'), findsNothing);
  });

  testWidgets('clearing search restores all discovery categories', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MakambakoYetuApp());
    await tester.enterText(find.byKey(const ValueKey('home-search')), 'hotel');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Futa utafutaji'));
    await tester.pumpAndSettle();

    expect(find.text('Hoteli na sehemu za kukaa'), findsOneWidget);
    expect(find.text('Migahawa na sehemu za kula'), findsOneWidget);
  });

  testWidgets('explore search filters categories and saves to profile', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MakambakoYetuApp());

    await tester.tap(find.text('Gundua'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('explore-search')),
      'Usafiri',
    );
    await tester.pumpAndSettle();

    expect(find.text('Usafiri na safari'), findsOneWidget);
    expect(find.text('Maduka na wajasiriamali'), findsNothing);

    await tester.tap(find.byTooltip('Hifadhi'));
    await tester.pumpAndSettle();

    // Open Profile via top bar button
    await tester.tap(find.byKey(const ValueKey('topbar-profile-button')));
    await tester.pumpAndSettle();

    expect(find.text('Usafiri'), findsWidgets);
  });

  testWidgets('saved categories and language choice survive a restart', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({
      'mk_yetu.savedCategories': ['Usafiri'],
      'mk_yetu.isEnglish': true,
    });
    await tester.pumpWidget(const MakambakoYetuApp());
    await tester.pumpAndSettle();

    // The language choice is restored to English.
    expect(find.text('SW'), findsOneWidget);
    expect(find.text('Business'), findsWidgets);
    expect(find.text('Biashara'), findsNothing);

    // The saved category is restored in the Profile page.
    await tester.tap(find.byKey(const ValueKey('topbar-profile-button')));
    await tester.pumpAndSettle();
    expect(find.text('Transport'), findsWidgets);
  });

  testWidgets('language toggle inside profile page updates profile and persists', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MakambakoYetuApp());
    await tester.pumpAndSettle();

    // Open Profile via top bar button
    await tester.tap(find.byKey(const ValueKey('topbar-profile-button')));
    await tester.pumpAndSettle();

    expect(find.text('Wasifu na Vilivyohifadhiwa'), findsOneWidget);
    expect(find.text('Mgeni wa Makambako'), findsOneWidget);
    expect(find.text('Lugha ya App'), findsOneWidget);

    // Tap Profile Language Switcher Tile
    await tester.tap(find.byKey(const ValueKey('profile-language-tile')));
    await tester.pumpAndSettle();

    expect(find.text('Profile & Saved'), findsOneWidget);
    expect(find.text('Makambako Guest'), findsOneWidget);
    expect(find.text('App Language'), findsOneWidget);
    expect(find.text('English'), findsWidgets);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('mk_yetu.isEnglish'), isTrue);
  });
}
