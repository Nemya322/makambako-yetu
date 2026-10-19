import 'discovery_result.dart';
import 'place.dart';
import 'place_repository.dart';
import 'place_search_request.dart';

class PlaceSearchService {
  const PlaceSearchService(this._repository);

  final PlaceRepository _repository;

  Future<DiscoveryResult<List<Place>>> search(
    PlaceSearchRequest request,
  ) async {
    final result = await _repository.search(request);
    if (result case DiscoverySuccess<List<Place>>(:final value)) {
      final places = value
          .where(
            (place) => _matchesFilters(
              place,
              categoryId: request.categoryId,
              areaId: request.areaId,
            ),
          )
          .toList();
      return DiscoverySuccess(PlaceSearchRanker.rank(places, request.query));
    }
    return result;
  }

  Future<DiscoveryResult<List<Place>>> findWithinBounds(
    PlaceBoundsRequest request,
  ) async {
    final result = await _repository.findWithinBounds(request);
    if (result case DiscoverySuccess<List<Place>>(:final value)) {
      final places = value.where((place) {
        final coordinates = place.location.coordinates;
        return coordinates != null &&
            request.bounds.contains(coordinates) &&
            _matchesFilters(
              place,
              categoryId: request.categoryId,
              areaId: request.areaId,
            );
      }).toList()..sort(_comparePlaces);
      return DiscoverySuccess(places);
    }
    return result;
  }

  Future<DiscoveryResult<Place?>> getById(String placeId) {
    return _repository.getById(placeId);
  }

  static bool _matchesFilters(
    Place place, {
    required String? categoryId,
    required String? areaId,
  }) {
    return (categoryId == null || place.categoryId == categoryId) &&
        (areaId == null || place.location.area.id == areaId);
  }
}

class PlaceSearchRanker {
  const PlaceSearchRanker._();

  static List<Place> rank(Iterable<Place> places, String query) {
    final normalizedQuery = _normalize(query);
    final candidates = <({Place place, int rank})>[];

    for (final place in places) {
      final rank = _rank(place, normalizedQuery);
      if (rank != null) candidates.add((place: place, rank: rank));
    }

    candidates.sort((a, b) {
      final rankOrder = b.rank.compareTo(a.rank);
      return rankOrder == 0 ? _comparePlaces(a.place, b.place) : rankOrder;
    });
    return candidates.map((candidate) => candidate.place).toList();
  }

  static int? _rank(Place place, String query) {
    if (query.isEmpty) return 0;

    final name = _normalize(place.name);
    final aliases = place.aliases.map(_normalize).toList();
    final titleFields = [name, ...aliases, _normalize(place.categoryName)];
    final allTitleText = titleFields.join(' ');
    final terms = query.split(' ');

    if (name == query) return 600;
    if (name.startsWith(query)) return 500;
    if (aliases.any((alias) => alias == query)) return 450;
    if (aliases.any((alias) => alias.startsWith(query))) return 400;
    if (terms.every(allTitleText.contains)) return 300;

    final additionalText = _normalize(
      [
        place.description ?? '',
        place.location.displayName ?? '',
        place.location.address ?? '',
      ].join(' '),
    );
    if (terms.every(
      (term) => allTitleText.contains(term) || additionalText.contains(term),
    )) {
      return 100;
    }
    return null;
  }

  static String _normalize(String value) {
    return value.toLowerCase().trim().split(RegExp(r'\s+')).join(' ');
  }
}

int _comparePlaces(Place a, Place b) {
  final nameOrder = a.name.toLowerCase().compareTo(b.name.toLowerCase());
  return nameOrder == 0 ? a.id.compareTo(b.id) : nameOrder;
}
