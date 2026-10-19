import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_yetu_app/features/discovery/domain/discovery_result.dart';
import 'package:mk_yetu_app/features/discovery/domain/geographic_area.dart';
import 'package:mk_yetu_app/features/discovery/domain/place.dart';
import 'package:mk_yetu_app/features/discovery/domain/place_repository.dart';
import 'package:mk_yetu_app/features/discovery/domain/place_search_request.dart';
import 'package:mk_yetu_app/main.dart';

void main() {
  testWidgets('search selection opens the same labelled development record', (
    tester,
  ) async {
    final place = _developmentFixture();
    await tester.pumpWidget(
      MakambakoYetuApp(placeRepository: _WidgetPlaceRepository([place])),
    );
    await tester.enterText(find.byKey(const ValueKey('home-search')), 'kahawa');
    await tester.pumpAndSettle();

    expect(find.text('Kahawa ya Mfano'), findsOneWidget);
    expect(find.text('MAENDELEZO TU · SI BIASHARA HALISI'), findsOneWidget);
    await tester.tap(find.text('Kahawa ya Mfano'));
    await tester.pumpAndSettle();

    expect(
      find.text('REKODI YA MAENDELEZO TU — SI BIASHARA ILIYOTHIBITISHWA'),
      findsOneWidget,
    );
    expect(find.text('Chanzo: Synthetic test fixture'), findsOneWidget);
    expect(_WidgetPlaceRepository.lastLookedUpId, place.id);
  });

  testWidgets('a true empty result differs from an unconfigured source', (
    tester,
  ) async {
    await tester.pumpWidget(
      MakambakoYetuApp(placeRepository: _WidgetPlaceRepository([])),
    );
    await tester.enterText(find.byKey(const ValueKey('home-search')), 'kahawa');
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Hakuna maeneo yaliyolingana'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Hakuna maeneo yaliyolingana'), findsOneWidget);
    expect(find.text('Taarifa za maeneo bado hazijaunganishwa'), findsNothing);
  });

  testWidgets('the app default reports missing source, not zero matches', (
    tester,
  ) async {
    await tester.pumpWidget(const MakambakoYetuApp());
    await tester.enterText(find.byKey(const ValueKey('home-search')), 'kahawa');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Taarifa za maeneo bado hazijaunganishwa'),
      250,
      scrollable: find.byType(Scrollable).first,
    );

    expect(
      find.text('Taarifa za maeneo bado hazijaunganishwa'),
      findsOneWidget,
    );
    expect(find.text('Hakuna maeneo yaliyolingana'), findsNothing);
  });

  testWidgets('timeout is shown distinctly and provides retry', (tester) async {
    final repository = _WidgetPlaceRepository(
      const [],
      failure: const DiscoveryFailure<List<Place>>(
        kind: DiscoveryFailureKind.timeout,
        message: 'Request timed out',
      ),
    );
    await tester.pumpWidget(MakambakoYetuApp(placeRepository: repository));
    await tester.enterText(find.byKey(const ValueKey('home-search')), 'kahawa');
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Utafutaji umechukua muda mrefu'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Utafutaji umechukua muda mrefu'), findsOneWidget);
    expect(find.text('Hakuna maeneo yaliyolingana'), findsNothing);
    expect(find.text('Jaribu tena'), findsOneWidget);
  });

  testWidgets('loading is distinct from empty and server-error states', (
    tester,
  ) async {
    final pendingSearch = Completer<DiscoveryResult<List<Place>>>();
    final repository = _WidgetPlaceRepository(
      const [],
      pendingSearch: pendingSearch,
    );
    await tester.pumpWidget(MakambakoYetuApp(placeRepository: repository));
    await tester.enterText(find.byKey(const ValueKey('home-search')), 'kahawa');
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    pendingSearch.complete(
      const DiscoveryFailure<List<Place>>(
        kind: DiscoveryFailureKind.serverError,
        message: 'Server is unavailable',
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Utafutaji haukupatikana'),
      250,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Utafutaji haukupatikana'), findsOneWidget);
    expect(find.text('Utafutaji umechukua muda mrefu'), findsNothing);
    expect(find.text('Hakuna maeneo yaliyolingana'), findsNothing);
  });
}

Place _developmentFixture() {
  final now = DateTime.utc(2026);
  return Place(
    id: 'test-place-kahawa',
    entity: const BusinessEntityReference('test-business-kahawa'),
    name: 'Kahawa ya Mfano',
    categoryId: 'food',
    categoryName: 'Chakula',
    aliases: const ['kahawa', 'cafe'],
    location: const PlaceLocation(
      id: 'test-location-kahawa',
      area: GeographicArea(
        id: 'test-area-synthetic-town',
        name: 'Synthetic test town',
        level: GeographicAreaLevel.town,
      ),
    ),
    provenance: const PlaceProvenance(
      type: PlaceSourceType.developmentFixture,
      label: 'Synthetic test fixture',
    ),
    verificationStatus: PlaceVerificationStatus.developmentFixture,
    createdAt: now,
    updatedAt: now,
  );
}

class _WidgetPlaceRepository implements PlaceRepository {
  _WidgetPlaceRepository(this.places, {this.failure, this.pendingSearch});

  final List<Place> places;
  final DiscoveryFailure<List<Place>>? failure;
  final Completer<DiscoveryResult<List<Place>>>? pendingSearch;
  static String? lastLookedUpId;

  @override
  Future<DiscoveryResult<Place?>> getById(String placeId) async {
    lastLookedUpId = placeId;
    for (final place in places) {
      if (place.id == placeId) return DiscoverySuccess(place);
    }
    return const DiscoverySuccess(null);
  }

  @override
  Future<DiscoveryResult<List<Place>>> findWithinBounds(
    PlaceBoundsRequest request,
  ) async {
    return DiscoverySuccess(places);
  }

  @override
  Future<DiscoveryResult<List<Place>>> search(
    PlaceSearchRequest request,
  ) async {
    if (pendingSearch != null) return pendingSearch!.future;
    return failure ?? DiscoverySuccess(places);
  }
}
