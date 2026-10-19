import 'discovery_result.dart';
import 'place.dart';
import 'place_search_request.dart';

abstract interface class PlaceRepository {
  Future<DiscoveryResult<List<Place>>> search(PlaceSearchRequest request);

  Future<DiscoveryResult<List<Place>>> findWithinBounds(
    PlaceBoundsRequest request,
  );

  Future<DiscoveryResult<Place?>> getById(String placeId);
}
