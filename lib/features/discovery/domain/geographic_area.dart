enum GeographicAreaLevel { country, region, district, town, area }

class GeographicArea {
  const GeographicArea({
    required this.id,
    required this.name,
    required this.level,
    this.parentAreaId,
  });

  final String id;
  final String name;
  final GeographicAreaLevel level;
  final String? parentAreaId;
}

class GeoPoint {
  factory GeoPoint({required double latitude, required double longitude}) {
    if (!latitude.isFinite || latitude < -90 || latitude > 90) {
      throw ArgumentError.value(
        latitude,
        'latitude',
        'Must be between -90 and 90.',
      );
    }
    if (!longitude.isFinite || longitude < -180 || longitude > 180) {
      throw ArgumentError.value(
        longitude,
        'longitude',
        'Must be between -180 and 180.',
      );
    }
    return GeoPoint._(latitude, longitude);
  }

  const GeoPoint._(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

class GeoBounds {
  factory GeoBounds({
    required double south,
    required double west,
    required double north,
    required double east,
  }) {
    if (!south.isFinite ||
        !north.isFinite ||
        south < -90 ||
        north > 90 ||
        south > north) {
      throw ArgumentError(
        'Latitude bounds must be ordered and within -90..90.',
      );
    }
    if (!west.isFinite ||
        !east.isFinite ||
        west < -180 ||
        east > 180 ||
        west > east) {
      throw ArgumentError(
        'Longitude bounds must be ordered and within -180..180.',
      );
    }
    return GeoBounds._(south, west, north, east);
  }

  const GeoBounds._(this.south, this.west, this.north, this.east);

  final double south;
  final double west;
  final double north;
  final double east;

  bool contains(GeoPoint point) {
    return point.latitude >= south &&
        point.latitude <= north &&
        point.longitude >= west &&
        point.longitude <= east;
  }
}
