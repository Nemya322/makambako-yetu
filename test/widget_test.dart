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
  });

  testWidgets('home search filters the local categories', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MakambakoYetuApp());
    await tester.enterText(find.byType(TextField), 'Usafiri');
    await tester.pumpAndSettle();

    expect(find.text('Usafiri na safari'), findsOneWidget);
    expect(find.text('Maduka na wajasiriamali'), findsNothing);
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

    expect(find.text('Usafiri na safari'), findsOneWidget);
    expect(find.text('Maduka na wajasiriamali'), findsNothing);

    await tester.tap(find.byTooltip('Hifadhi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zilizohifadhiwa'));
    await tester.pumpAndSettle();

    expect(find.text('Usafiri na safari'), findsOneWidget);
  });
}
