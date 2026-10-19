import 'geographic_area.dart';

class PlaceSearchRequest {
  const PlaceSearchRequest({this.query = '', this.categoryId, this.areaId});

  final String query;
  final String? categoryId;

  /// A manually selected canonical area ID; device location is never required.
  final String? areaId;
}

class PlaceBoundsRequest {
  const PlaceBoundsRequest({
    required this.bounds,
    this.categoryId,
    this.areaId,
  });

  final GeoBounds bounds;
  final String? categoryId;
  final String? areaId;
}
