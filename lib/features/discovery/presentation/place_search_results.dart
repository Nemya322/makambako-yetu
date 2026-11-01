import 'package:flutter/material.dart';

import '../../../core/l10n/app_text.dart';
import '../../../core/theme/makambako_theme.dart';
import '../data/development_fixture_place_repository.dart';
import '../domain/discovery_result.dart';
import '../domain/place.dart';
import 'place_verification_label.dart';

sealed class PlaceSearchState {
  const PlaceSearchState();
}

final class PlaceSearchIdle extends PlaceSearchState {
  const PlaceSearchIdle();
}

final class PlaceSearchLoading extends PlaceSearchState {
  const PlaceSearchLoading();
}

final class PlaceSearchLoaded extends PlaceSearchState {
  const PlaceSearchLoaded(this.places);

  final List<Place> places;
}

final class PlaceSearchFailed extends PlaceSearchState {
  const PlaceSearchFailed(this.failure);

  final DiscoveryFailure<List<Place>> failure;
}

class PlaceSearchResults extends StatelessWidget {
  const PlaceSearchResults({
    required this.state,
    required this.onRetry,
    required this.onPlaceSelected,
    required this.isEnglish,
    super.key,
  });

  final PlaceSearchState state;
  final VoidCallback onRetry;
  final ValueChanged<Place> onPlaceSelected;
  final bool isEnglish;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      PlaceSearchIdle() => const SizedBox.shrink(),
      PlaceSearchLoading() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(
            color: MakambakoColors.green,
            strokeWidth: 2.5,
          ),
        ),
      ),
      PlaceSearchLoaded(:final places) =>
        places.isEmpty
            ? _SearchMessage(
                icon: Icons.location_off_outlined,
                title: tx(
                  isEnglish,
                  'Hakuna maeneo yaliyolingana',
                  'No matching places',
                ),
                message: tx(
                  isEnglish,
                  'Hakuna rekodi zilizorudishwa kwa utafutaji huu.',
                  'No records were returned for this search.',
                ),
              )
            : Column(
                children: places
                    .map(
                      (place) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PlaceResultCard(
                          place: place,
                          isEnglish: isEnglish,
                          onTap: () => onPlaceSelected(place),
                        ),
                      ),
                    )
                    .toList(),
              ),
      PlaceSearchFailed(:final failure) => _FailureMessage(
        failure: failure,
        onRetry: onRetry,
        isEnglish: isEnglish,
      ),
    };
  }
}

class _PlaceResultCard extends StatelessWidget {
  const _PlaceResultCard({
    required this.place,
    required this.isEnglish,
    required this.onTap,
  });

  final Place place;
  final bool isEnglish;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEAEFE8)),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.place_rounded,
                  color: MakambakoColors.forest,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            style: const TextStyle(
                              color: MakambakoColors.ink,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (place.rating != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, size: 13, color: Color(0xFFD97706)),
                                const SizedBox(width: 2),
                                Text(
                                  place.rating!.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Color(0xFF92400E),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${localizedPlaceCategory(place, isEnglish)} · ${place.location.area.name}',
                          style: const TextStyle(
                            color: MakambakoColors.muted,
                            fontSize: 12,
                          ),
                        ),
                        if (place.phone != null) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.phone_rounded, size: 12, color: MakambakoColors.forest),
                        ],
                        if (place.whatsapp != null) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.chat_bubble_outline_rounded, size: 12, color: Color(0xFF25D366)),
                        ],
                      ],
                    ),
                    if (place.isDevelopmentFixture) ...[
                      const SizedBox(height: 6),
                      Text(
                        tx(
                          isEnglish,
                          'MAENDELEZO TU · SI BIASHARA HALISI',
                          'DEVELOPMENT ONLY · NOT A REAL BUSINESS',
                        ),
                        style: const TextStyle(
                          color: Color(0xFF9A5A00),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.35,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 5),
                      Text(
                        placeVerificationLabel(place.verificationStatus, isEnglish),
                        style: const TextStyle(
                          color: MakambakoColors.forest,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 4),
                child: Icon(Icons.chevron_right_rounded, color: MakambakoColors.muted, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FailureMessage extends StatelessWidget {
  const _FailureMessage({
    required this.failure,
    required this.onRetry,
    required this.isEnglish,
  });

  final DiscoveryFailure<List<Place>> failure;
  final VoidCallback onRetry;
  final bool isEnglish;

  @override
  Widget build(BuildContext context) {
    final (title, message) = switch (failure.kind) {
      DiscoveryFailureKind.notConfigured => (
        tx(
          isEnglish,
          'Taarifa za maeneo bado hazijaunganishwa',
          'Place data is not connected yet',
        ),
        tx(
          isEnglish,
          'Chanzo cha rekodi za Makambako hakijachaguliwa. Hakuna biashara '
              'halisi inayoorodheshwa kwa sasa.',
          'A Makambako place-data source has not been selected. No real '
              'businesses are listed yet.',
        ),
      ),
      DiscoveryFailureKind.timeout => (
        tx(isEnglish, 'Utafutaji umechukua muda mrefu', 'Search timed out'),
        tx(
          isEnglish,
          'Angalia muunganisho kisha ujaribu tena.',
          'Check your connection and try again.',
        ),
      ),
      DiscoveryFailureKind.serverError => (
        tx(isEnglish, 'Utafutaji haukupatikana', 'Search is unavailable'),
        tx(
          isEnglish,
          'Huduma ya taarifa za maeneo imeshindwa. Jaribu tena baadaye.',
          'The place service failed. Please try again later.',
        ),
      ),
    };
    final canRetry = failure.kind != DiscoveryFailureKind.notConfigured;

    return _SearchMessage(
      icon: canRetry ? Icons.wifi_off_rounded : Icons.info_outline_rounded,
      title: title,
      message: message,
      action: canRetry
          ? TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 17),
              label: Text(tx(isEnglish, 'Jaribu tena', 'Try again')),
            )
          : null,
    );
  }
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, size: 32, color: MakambakoColors.green),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: MakambakoColors.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: MakambakoColors.muted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

class MapProviderUnavailableCard extends StatelessWidget {
  const MapProviderUnavailableCard({
    required this.isEnglish,
    this.onPlaceSelected,
    super.key,
  });

  final bool isEnglish;
  final ValueChanged<Place>? onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    return MakambakoTownMapCard(isEnglish: isEnglish, onPlaceSelected: onPlaceSelected);
  }
}

class MakambakoTownMapCard extends StatefulWidget {
  const MakambakoTownMapCard({
    required this.isEnglish,
    this.onPlaceSelected,
    super.key,
  });

  final bool isEnglish;
  final ValueChanged<Place>? onPlaceSelected;

  @override
  State<MakambakoTownMapCard> createState() => _MakambakoTownMapCardState();
}

class _MakambakoTownMapCardState extends State<MakambakoTownMapCard> {
  int _selectedPin = 0;

  static const _landmarks = [
    (
      id: 'mko-stand-kuu',
      name: 'Stand Kuu ya Mabasi',
      nameEn: 'Central Bus Terminal',
      area: 'Stand Kuu',
      coords: '-8.8480, 34.8260',
      icon: Icons.directions_bus_rounded,
      color: Color(0xFF2563EB),
    ),
    (
      id: 'mko-hospital-st-joseph',
      name: 'Hospitali ya Mt. Joseph',
      nameEn: 'St. Joseph Hospital',
      area: 'Lyamkena',
      coords: '-8.8520, 34.8220',
      icon: Icons.local_hospital_rounded,
      color: Color(0xFFDC2626),
    ),
    (
      id: 'mko-soko-mwembetogwa',
      name: 'Soko Kuu Mwembetogwa',
      nameEn: 'Mwembetogwa Market',
      area: 'Mwembetogwa',
      coords: '-8.8465, 34.8290',
      icon: Icons.storefront_rounded,
      color: Color(0xFFD97706),
    ),
    (
      id: 'mko-station-tazara',
      name: 'Kituo cha Reli TAZARA',
      nameEn: 'TAZARA Railway Station',
      area: 'TAZARA',
      coords: '-8.8350, 34.8390',
      icon: Icons.train_rounded,
      color: Color(0xFF7C3AED),
    ),
    (
      id: 'mko-midland-hotel',
      name: 'Midland Golden Hotel',
      nameEn: 'Midland Golden Hotel',
      area: 'Mjimwema',
      coords: '-8.8450, 34.8250',
      icon: Icons.hotel_rounded,
      color: MakambakoColors.forest,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isEnglish = widget.isEnglish;
    final active = _landmarks[_selectedPin];

    return Container(
      margin: const EdgeInsets.only(top: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.map_rounded, color: MakambakoColors.forest, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx(isEnglish, 'Ramani ya Makambako', 'Makambako Town Map'),
                        style: const TextStyle(
                          color: MakambakoColors.ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        tx(isEnglish, 'Njia panda ya Iringa, Mbeya na Songea', 'Junction of Iringa, Mbeya & Songea'),
                        style: const TextStyle(color: MakambakoColors.muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '-8.8475°, 34.8278°',
                    style: TextStyle(
                      color: MakambakoColors.ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Map Canvas Simulation
          Container(
            height: 165,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EFE5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCCE0CB)),
            ),
            child: Stack(
              children: [
                // Stylized Road Grid representing TANZAM Highway & Songea Road
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MakambakoRoadsPainter(),
                  ),
                ),

                // Center Junction Indicator
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      tx(isEnglish, 'Makambako Mjini', 'Makambako Town'),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: MakambakoColors.forest,
                      ),
                    ),
                  ),
                ),

                // Interactive Pin 0: Stand Kuu (West)
                Positioned(
                  left: 40,
                  top: 75,
                  child: _MapPinButton(
                    icon: _landmarks[0].icon,
                    color: _landmarks[0].color,
                    isSelected: _selectedPin == 0,
                    onTap: () => setState(() => _selectedPin = 0),
                  ),
                ),

                // Interactive Pin 1: Hospitali St. Joseph (South-West)
                Positioned(
                  left: 65,
                  bottom: 18,
                  child: _MapPinButton(
                    icon: _landmarks[1].icon,
                    color: _landmarks[1].color,
                    isSelected: _selectedPin == 1,
                    onTap: () => setState(() => _selectedPin = 1),
                  ),
                ),

                // Interactive Pin 2: Soko Kuu Mwembetogwa (East)
                Positioned(
                  right: 48,
                  top: 60,
                  child: _MapPinButton(
                    icon: _landmarks[2].icon,
                    color: _landmarks[2].color,
                    isSelected: _selectedPin == 2,
                    onTap: () => setState(() => _selectedPin = 2),
                  ),
                ),

                // Interactive Pin 3: TAZARA Station (North-East)
                Positioned(
                  right: 32,
                  top: 15,
                  child: _MapPinButton(
                    icon: _landmarks[3].icon,
                    color: _landmarks[3].color,
                    isSelected: _selectedPin == 3,
                    onTap: () => setState(() => _selectedPin = 3),
                  ),
                ),

                // Interactive Pin 4: Midland Hotel (North)
                Positioned(
                  left: 110,
                  top: 25,
                  child: _MapPinButton(
                    icon: _landmarks[4].icon,
                    color: _landmarks[4].color,
                    isSelected: _selectedPin == 4,
                    onTap: () => setState(() => _selectedPin = 4),
                  ),
                ),
              ],
            ),
          ),

          // Active Pin Details
          Padding(
            padding: const EdgeInsets.all(14),
            child: Material(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  final place = DevelopmentFixturePlaceRepository.findPlaceById(active.id);
                  if (place != null && widget.onPlaceSelected != null) {
                    widget.onPlaceSelected!(place);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: active.color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(active.icon, color: active.color, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx(isEnglish, active.name, active.nameEn),
                              style: const TextStyle(
                                color: MakambakoColors.ink,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${tx(isEnglish, 'Kata ya ${active.area}', '${active.area} Ward')} · ${tx(isEnglish, 'Gusa kutazama taarifa', 'Tap for details')}',
                              style: const TextStyle(
                                color: MakambakoColors.forest,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF3E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tx(isEnglish, 'Fungua', 'Open'),
                              style: const TextStyle(
                                color: MakambakoColors.forest,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_rounded, color: MakambakoColors.forest, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPinButton extends StatelessWidget {
  const _MapPinButton({
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isSelected ? 7 : 5),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : color,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: isSelected ? 18 : 14,
          color: isSelected ? Colors.white : color,
        ),
      ),
    );
  }
}

class _MakambakoRoadsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final highwayPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final secondaryPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // TANZAM Highway: Across East to West
    canvas.drawLine(
      Offset(0, size.height * 0.52),
      Offset(size.width, size.height * 0.48),
      highwayPaint,
    );

    // Songea / Njombe Road: Junction to South
    canvas.drawLine(
      Offset(size.width * 0.48, size.height * 0.50),
      Offset(size.width * 0.35, size.height),
      highwayPaint,
    );

    // Road to TAZARA / Iringa: Junction to North-East
    canvas.drawLine(
      Offset(size.width * 0.52, size.height * 0.50),
      Offset(size.width * 0.85, 0),
      secondaryPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
