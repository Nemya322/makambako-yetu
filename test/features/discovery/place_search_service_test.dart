import 'package:flutter_test/flutter_test.dart';
import 'package:mk_yetu_app/features/discovery/domain/discovery_result.dart';
import 'package:mk_yetu_app/features/discovery/domain/geographic_area.dart';
import 'package:mk_yetu_app/features/discovery/domain/place.dart';
import 'package:mk_yetu_app/features/discovery/domain/place_repository.dart';
import 'package:mk_yetu_app/features/discovery/domain/place_search_request.dart';
import 'package:mk_yetu_app/features/discovery/domain/place_search_service.dart';

void main() {
  final area = GeographicArea(
    id: 'area-synthetic-town',
    name: 'Synthetic test town',
    level: GeographicAreaLevel.town,
  );
  final bounds = GeoBounds(south: 0, west: 0, north: 3, east: 3);

  final exactName = _testPlace(
    id: 'place-exact-name',
    name: 'Cafe',
    aliases: const [],
    area: area,
  );
  final prefixName = _testPlace(
    id: 'place-prefix-name',
    name: 'Cafe Mji',
    aliases: const [],
    area: area,
  );
  final exactAlias = _testPlace(
    id: 'place-exact-alias',
    name: 'Kahawa',
    aliases: const ['cafe'],
    area: area,
  );
  final prefixAlias = _testPlace(
    id: 'place-prefix-alias',
    name: 'Kahawa Corner',
    aliases: const ['cafeteria'],
    area: area,
  );
  final partial = _testPlace(
    id: 'place-partial',
    name: 'Mji wa Cafe',
    aliases: const [],
    area: area,
  );
  final descriptionMatch = _testPlace(
    id: 'place-description',
    name: 'Kahawa Nyumbani',
    aliases: const [],
    description: 'Cafe style drinks',
    area: area,
  );
  final addressMatch = _testPlace(
    id: 'place-address',
    name: 'Kahawa Nyumbani',
    aliases: const [],
    address: 'Cafe street',
    area: area,
  );

  test('ranks exact, prefix, alias, partial, and descriptive matches', () {
    final ranked = PlaceSearchRanker.rank([
      descriptionMatch,
      partial,
      prefixAlias,
      exactAlias,
      prefixName,
      exactName,
      addressMatch,
    ], 'cafe');

    expect(ranked.map((place) => place.id), [
      exactName.id,
      prefixName.id,
      exactAlias.id,
      prefixAlias.id,
      partial.id,
      addressMatch.id,
      descriptionMatch.id,
    ]);
  });

  test(
    'case and whitespace do not change matching; ties sort deterministically',
    () {
      final tieA = _testPlace(
        id: 'place-a',
        name: 'Kahawa Mji',
        aliases: const ['cafe'],
        area: area,
      );
      final tieB = _testPlace(
        id: 'place-b',
        name: 'Kahawa Mji',
        aliases: const ['cafe'],
        area: area,
      );

      final ranked = PlaceSearchRanker.rank([tieB, tieA], '  CAFE  ');

      expect(ranked.map((place) => place.id), ['place-a', 'place-b']);
    },
  );

  test(
    'search, bounds results, and canonical lookup share the same ID',
    () async {
      final repository = _TestPlaceRepository([exactName]);
      final service = PlaceSearchService(repository);

      final search = await service.search(
        PlaceSearchRequest(
          query: 'cafe',
          categoryId: exactName.categoryId,
          areaId: area.id,
        ),
      );
      final mapBounds = await service.findWithinBounds(
        PlaceBoundsRequest(
          bounds: bounds,
          categoryId: exactName.categoryId,
          areaId: area.id,
        ),
      );
      final detail = await service.getById(exactName.id);

      expect(
        (search as DiscoverySuccess<List<Place>>).value.single.id,
        exactName.id,
      );
      expect(
        (mapBounds as DiscoverySuccess<List<Place>>).value.single.id,
        exactName.id,
      );
      expect((detail as DiscoverySuccess<Place?>).value?.id, exactName.id);
      expect(repository.lastSearchRequest?.areaId, area.id);
    },
  );

  test('category and manually selected area filters are enforced', () async {
    final otherArea = GeographicArea(
      id: 'area-other-test',
      name: 'Other town',
      level: GeographicAreaLevel.town,
    );
    final otherPlace = _testPlace(
      id: 'place-other-town',
      name: 'Cafe Other',
      aliases: const [],
      area: otherArea,
    );
    final repository = _TestPlaceRepository([exactName, otherPlace]);
    final service = PlaceSearchService(repository);

    final result = await service.search(
      PlaceSearchRequest(
        query: 'cafe',
        categoryId: exactName.categoryId,
        areaId: area.id,
      ),
    );

    expect((result as DiscoverySuccess<List<Place>>).value, [exactName]);
  });

  test(
    'map bounds omit records without coordinates and out-of-bounds records',
    () async {
      final outsideBounds = _testPlace(
        id: 'place-outside-bounds',
        name: 'Cafe Mbali',
        aliases: const [],
        area: area,
        coordinates: GeoPoint(latitude: 5, longitude: 40),
      );
      final noCoordinates = _testPlace(
        id: 'place-no-coordinates',
        name: 'Cafe Bila Alama',
        aliases: const [],
        area: area,
        hasCoordinates: false,
      );
      final service = PlaceSearchService(
        _TestPlaceRepository([exactName, outsideBounds, noCoordinates]),
      );

      final result = await service.findWithinBounds(
        PlaceBoundsRequest(bounds: bounds),
      );

      expect(
        (result as DiscoverySuccess<List<Place>>).value.map(
          (place) => place.id,
        ),
        [exactName.id],
      );
    },
  );

  test(
    'unconfigured data source is distinguishable from an empty result',
    () async {
      final service = PlaceSearchService(_UnconfiguredTestRepository());

      final result = await service.search(const PlaceSearchRequest(query: 'x'));

      expect(result, isA<DiscoveryFailure<List<Place>>>());
      expect(
        (result as DiscoveryFailure<List<Place>>).kind,
        DiscoveryFailureKind.notConfigured,
      );
    },
  );
}

Place _testPlace({
  required String id,
  required String name,
  required List<String> aliases,
  required GeographicArea area,
  String? description,
  String? address,
  GeoPoint? coordinates,
  bool hasCoordinates = true,
}) {
  final now = DateTime.utc(2026);
  return Place(
    id: id,
    entity: BusinessEntityReference('entity-$id'),
    name: name,
    categoryId: 'food',
    categoryName: 'Chakula',
    aliases: aliases,
    description: description,
    location: PlaceLocation(
      id: 'location-$id',
      area: area,
      address: address,
      coordinates: hasCoordinates
          ? coordinates ?? GeoPoint(latitude: 1, longitude: 2)
          : null,
    ),
    provenance: const PlaceProvenance(
      type: PlaceSourceType.developmentFixture,
      label: 'Synthetic test fixture; not a real listing',
    ),
    verificationStatus: PlaceVerificationStatus.developmentFixture,
    createdAt: now,
    updatedAt: now,
  );
}

class _TestPlaceRepository implements PlaceRepository {
  _TestPlaceRepository(this.places);

  final List<Place> places;
  PlaceSearchRequest? lastSearchRequest;

  @override
  Future<DiscoveryResult<Place?>> getById(String placeId) async {
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
    lastSearchRequest = request;
    return DiscoverySuccess(places);
  }
}

class _UnconfiguredTestRepository implements PlaceRepository {
  @override
  Future<DiscoveryResult<Place?>> getById(String placeId) async {
    return const DiscoveryFailure<Place?>(
      kind: DiscoveryFailureKind.notConfigured,
      message: 'No data source',
    );
  }

  @override
  Future<DiscoveryResult<List<Place>>> findWithinBounds(
    PlaceBoundsRequest request,
  ) async {
    return const DiscoveryFailure<List<Place>>(
      kind: DiscoveryFailureKind.notConfigured,
      message: 'No data source',
    );
  }

  @override
  Future<DiscoveryResult<List<Place>>> search(
    PlaceSearchRequest request,
  ) async {
    return const DiscoveryFailure<List<Place>>(
      kind: DiscoveryFailureKind.notConfigured,
      message: 'No data source',
    );
  }
}
