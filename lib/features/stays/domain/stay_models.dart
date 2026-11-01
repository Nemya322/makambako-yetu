/// Data models and fixtures for Guest House and Lodge accommodations.
class RoomOption {
  const RoomOption({
    required this.id,
    required this.titleSw,
    required this.titleEn,
    required this.descSw,
    required this.descEn,
    required this.leftSw,
    required this.leftEn,
    required this.pricePerNight,
  });

  final String id;
  final String titleSw;
  final String titleEn;
  final String descSw;
  final String descEn;
  final String leftSw;
  final String leftEn;
  final int pricePerNight;

  static const List<RoomOption> standardRooms = [
    RoomOption(
      id: 'double',
      titleSw: 'Chumba cha Wawili (Double room)',
      titleEn: 'Double room',
      descSw: 'Kitanda 1 kikubwa · Choo na Bafu ya ndani',
      descEn: '1 double bed · Private bathroom',
      leftSw: 'Zimebaki 3 kwa tarehe hizi',
      leftEn: '3 left for these dates',
      pricePerNight: 25000,
    ),
    RoomOption(
      id: 'family',
      titleSw: 'Chumba cha Familia (Family room)',
      titleEn: 'Family room',
      descSw: 'Vitanda 3 vya mtu mmoja · Choo na Bafu ya ndani',
      descEn: '3 single beds · Private bathroom',
      leftSw: 'Kimebaki 1 tu',
      leftEn: 'Only 1 left',
      pricePerNight: 40000,
    ),
  ];
}
