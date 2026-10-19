import 'geographic_area.dart';

enum PlaceEntityType { business, serviceProvider, publicPlace, event }

enum PlaceVerificationStatus {
  verified,
  unverified,
  suspended,
  developmentFixture,
}

enum PlaceSourceType {
  ownerSubmitted,
  officialSource,
  communitySubmitted,
  developmentFixture,
}

sealed class PlaceEntityReference {
  const PlaceEntityReference(this.id);

  final String id;
  PlaceEntityType get type;
}

final class BusinessEntityReference extends PlaceEntityReference {
  const BusinessEntityReference(super.id);

  @override
  PlaceEntityType get type => PlaceEntityType.business;
}

final class ServiceProviderEntityReference extends PlaceEntityReference {
  const ServiceProviderEntityReference(super.id);

  @override
  PlaceEntityType get type => PlaceEntityType.serviceProvider;
}

final class PublicPlaceEntityReference extends PlaceEntityReference {
  const PublicPlaceEntityReference(super.id);

  @override
  PlaceEntityType get type => PlaceEntityType.publicPlace;
}

final class EventEntityReference extends PlaceEntityReference {
  const EventEntityReference(super.id);

  @override
  PlaceEntityType get type => PlaceEntityType.event;
}

class PlaceProvenance {
  const PlaceProvenance({
    required this.type,
    required this.label,
    this.reference,
  });

  final PlaceSourceType type;
  final String label;
  final String? reference;
}

class PlaceLocation {
  const PlaceLocation({
    required this.id,
    required this.area,
    this.displayName,
    this.address,
    this.coordinates,
  });

  final String id;
  final GeographicArea area;
  final String? displayName;
  final String? address;
  final GeoPoint? coordinates;
}

class Place {
  const Place({
    required this.id,
    required this.entity,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.location,
    required this.provenance,
    required this.verificationStatus,
    required this.createdAt,
    required this.updatedAt,
    this.aliases = const [],
    this.description,
  }) : assert(id != ''),
       assert(categoryId != ''),
       assert(categoryName != '');

  /// Stable canonical place ID shared by search results, map markers, and details.
  final String id;

  /// Typed link to the canonical business, service, public place, or event.
  final PlaceEntityReference entity;
  final String name;
  final String categoryId;
  final String categoryName;
  final List<String> aliases;
  final String? description;
  final PlaceLocation location;
  final PlaceProvenance provenance;
  final PlaceVerificationStatus verificationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isDevelopmentFixture =>
      verificationStatus == PlaceVerificationStatus.developmentFixture ||
      provenance.type == PlaceSourceType.developmentFixture;
}
