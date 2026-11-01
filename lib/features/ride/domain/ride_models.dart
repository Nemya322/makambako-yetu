import 'package:flutter/material.dart';

/// 4-stage Ride Hailing workflow states matching Pages 1-4 of the activity workflow.
enum RideStage {
  /// Page 1: Select pickup, dropoff, ride type, payment, and request
  choose,

  /// Page 2: Animated radar search with fare booster chips (+500, +1000)
  finding,

  /// Page 3: Driver assigned & arriving with 4-digit TRIP PIN [4 7 2 9]
  arriving,

  /// Page 4: Arrival celebration, rating stars, feedback chips, tip & receipt
  arrived,
}

/// Vehicle category option available in Makambako.
class VehicleOption {
  const VehicleOption({
    required this.id,
    required this.titleSw,
    required this.titleEn,
    required this.tagSw,
    required this.tagEn,
    required this.timeSw,
    required this.timeEn,
    required this.basePrice,
    required this.icon,
  });

  final String id;
  final String titleSw;
  final String titleEn;
  final String tagSw;
  final String tagEn;
  final String timeSw;
  final String timeEn;
  final int basePrice;
  final IconData icon;

  static const List<VehicleOption> standardVehicles = [
    VehicleOption(
      id: 'bike',
      titleSw: 'Bodaboda',
      titleEn: 'Bike',
      tagSw: 'Ya haraka · abiria 1',
      tagEn: 'Fastest · 1 rider',
      timeSw: 'dak 3 karibu',
      timeEn: '3 min away',
      basePrice: 1500,
      icon: Icons.two_wheeler_rounded,
    ),
    VehicleOption(
      id: 'tuktuk',
      titleSw: 'Bajaji',
      titleEn: 'Tuk-tuk',
      tagSw: 'Hadi abiria 3',
      tagEn: 'Up to 3 riders',
      timeSw: 'dak 5 karibu',
      timeEn: '5 min away',
      basePrice: 2500,
      icon: Icons.electric_rickshaw_rounded,
    ),
    VehicleOption(
      id: 'car',
      titleSw: 'Gari',
      titleEn: 'Car',
      tagSw: 'Hadi abiria 4 · Nafasi zaidi',
      tagEn: 'Up to 4 riders · Extra room',
      timeSw: 'dak 8 karibu',
      timeEn: '8 min away',
      basePrice: 5000,
      icon: Icons.directions_car_rounded,
    ),
  ];
}

/// Assigned driver profile for active rides.
class DriverDetails {
  const DriverDetails({
    required this.name,
    required this.initials,
    required this.rating,
    required this.totalTrips,
    required this.plateNumber,
    required this.vehicleDescriptionSw,
    required this.vehicleDescriptionEn,
    required this.tripPin,
    required this.phoneNumber,
  });

  final String name;
  final String initials;
  final double rating;
  final int totalTrips;
  final String plateNumber;
  final String vehicleDescriptionSw;
  final String vehicleDescriptionEn;
  final List<String> tripPin;
  final String phoneNumber;

  static const defaultDriver = DriverDetails(
    name: 'Hassan K.',
    initials: 'HK',
    rating: 4.9,
    totalTrips: 1240,
    plateNumber: 'T 482 DKF',
    vehicleDescriptionSw: 'Pikipiki Nyekundu',
    vehicleDescriptionEn: 'Red bike',
    tripPin: ['4', '7', '2', '9'],
    phoneNumber: '+255 768 123 456',
  );
}

/// Popular pickup and drop-off landmarks in Makambako.
class MakambakoTransitLocations {
  static const List<String> popularSpots = [
    'Main Market, Makambako',
    'Bus Stand, Makambako',
    'Joseph Hospital, Lyamkena',
    'Royal Hotel, Makambako',
    'Mji Mwema Highway',
    'Mwembetogwa Stand Ndogo',
  ];
}
