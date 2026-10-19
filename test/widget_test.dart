import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mk_yetu_app/main.dart';

void main() {
  testWidgets('home introduces Makambako Yetu and its local categories', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MakambakoYetuApp());

    expect(find.text('MAKAMBAKO YETU'), findsOneWidget);
    expect(find.text('Makambako,\nyetu sote.'), findsOneWidget);
    expect(find.text('Biashara'), findsOneWidget);
    expect(find.text('Usafiri'), findsOneWidget);
    expect(find.text('Chakula'), findsOneWidget);
    expect(find.text('Malazi'), findsOneWidget);
    expect(find.text('Maeneo'), findsOneWidget);
  });

  testWidgets('language toggle switches the app between Swahili and English', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MakambakoYetuApp());

    expect(find.text('EN'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('language-toggle')));
    await tester.pumpAndSettle();

    expect(find.text('SW'), findsOneWidget);
    expect(find.text('Start exploring'), findsOneWidget);
    expect(find.text('Explore Makambako'), findsOneWidget);
    expect(find.text('Business'), findsOneWidget);
    expect(find.text('Biashara'), findsNothing);
    expect(find.text('Home'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('language-toggle')));
    await tester.pumpAndSettle();

    expect(find.text('EN'), findsOneWidget);
    expect(find.text('Anza kugundua'), findsOneWidget);
    expect(find.text('Biashara'), findsOneWidget);
  });

  testWidgets('universal search matches English aliases across categories', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MakambakoYetuApp());
    await tester.enterText(find.byKey(const ValueKey('home-search')), 'hotel');
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Hoteli na sehemu za kukaa'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
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
    await tester.scrollUntilVisible(
      find.text('Migahawa na sehemu za kula'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Migahawa na sehemu za kula'), findsOneWidget);
    expect(find.text('Hoteli na sehemu za kukaa'), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('explore-search')),
      'Njombe',
    );
    await tester.pumpAndSettle();
    expect(find.text('Maduka na wajasiriamali'), findsOneWidget);
    for (
      var i = 0;
      i < 4 && find.text('Matukio na shughuli za eneo').evaluate().isEmpty;
      i++
    ) {
      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pumpAndSettle();
    }
    expect(find.text('Matukio na shughuli za eneo'), findsOneWidget);
  });

  testWidgets('clearing search restores all discovery categories', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MakambakoYetuApp());
    await tester.enterText(find.byKey(const ValueKey('home-search')), 'hotel');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Futa utafutaji'));
    await tester.pumpAndSettle();

    expect(find.text('Hoteli na sehemu za kukaa'), findsOneWidget);
    expect(find.text('Migahawa na sehemu za kula'), findsOneWidget);
  });

  testWidgets('explore search filters categories and they can be saved', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MakambakoYetuApp());

    await tester.tap(find.text('Gundua'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('explore-search')),
      'Usafiri',
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Usafiri na safari'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Usafiri na safari'), findsOneWidget);
    expect(find.text('Maduka na wajasiriamali'), findsNothing);

    await tester.tap(find.byTooltip('Hifadhi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zilizohifadhiwa'));
    await tester.pumpAndSettle();

    expect(find.text('Usafiri na safari'), findsOneWidget);
  });
}
