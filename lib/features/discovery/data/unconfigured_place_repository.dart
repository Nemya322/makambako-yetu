import '../domain/discovery_result.dart';
import '../domain/place.dart';
import '../domain/place_repository.dart';
import '../domain/place_search_request.dart';

/// Makes the missing approved data service explicit instead of returning
/// an empty success that could be mistaken for a verified zero-result search.
class UnconfiguredPlaceRepository implements PlaceRepository {
  const UnconfiguredPlaceRepository();

  DiscoveryFailure<T> _failure<T>() {
    return DiscoveryFailure<T>(
      kind: DiscoveryFailureKind.notConfigured,
      message: 'No approved place data source is configured.',
    );
  }

  @override
  Future<DiscoveryResult<Place?>> getById(String placeId) async {
    return _failure<Place?>();
  }

  @override
  Future<DiscoveryResult<List<Place>>> findWithinBounds(
    PlaceBoundsRequest request,
  ) async {
    return _failure<List<Place>>();
  }

  @override
  Future<DiscoveryResult<List<Place>>> search(
    PlaceSearchRequest request,
  ) async {
    return _failure<List<Place>>();
  }
}
