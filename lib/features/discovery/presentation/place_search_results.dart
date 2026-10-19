import 'package:flutter/material.dart';

import '../domain/discovery_result.dart';
import '../domain/place.dart';

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
            color: Color(0xFF237A59),
            strokeWidth: 2.5,
          ),
        ),
      ),
      PlaceSearchLoaded(:final places) =>
        places.isEmpty
            ? const _SearchMessage(
                icon: Icons.location_off_outlined,
                title: _tx(
                  isEnglish,
                  'Hakuna maeneo yaliyolingana',
                  'No matching places',
                ),
                message: _tx(
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
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.place_outlined,
                  color: Color(0xFF145C45),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        color: Color(0xFF1D2B25),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${place.categoryName} · ${place.location.area.name}',
                      style: const TextStyle(
                        color: Color(0xFF758179),
                        fontSize: 12,
                      ),
                    ),
                    if (place.isDevelopmentFixture) ...[
                      const SizedBox(height: 6),
                      const Text(
                        _tx(
                          isEnglish,
                          'MAENDELEZO TU · SI BIASHARA HALISI',
                          'DEVELOPMENT ONLY · NOT A REAL BUSINESS',
                        ),
                        style: TextStyle(
                          color: Color(0xFF9A5A00),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.35,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 5),
                      Text(
                        _verificationLabel(place.verificationStatus, isEnglish),
                        style: const TextStyle(
                          color: Color(0xFF758179),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF758179)),
            ],
          ),
        ),
      ),
    );
  }
}

String _verificationLabel(PlaceVerificationStatus status, bool isEnglish) {
  return switch (status) {
    PlaceVerificationStatus.verified =>
      _tx(isEnglish, 'Imethibitishwa', 'Verified'),
    PlaceVerificationStatus.unverified =>
      _tx(isEnglish, 'Haijathibitishwa', 'Unverified'),
    PlaceVerificationStatus.suspended =>
      _tx(isEnglish, 'Imesitishwa', 'Suspended'),
    PlaceVerificationStatus.developmentFixture =>
      _tx(isEnglish, 'Maendeleo tu', 'Development only'),
  };
}

String _tx(bool english, String swahili, String englishText) =>
    english ? englishText : swahili;

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
        _tx(
          isEnglish,
          'Taarifa za maeneo bado hazijaunganishwa',
          'Place data is not connected yet',
        ),
        _tx(
          isEnglish,
          'Chanzo cha rekodi za Makambako hakijachaguliwa. Hakuna biashara '
              'halisi inayoorodheshwa kwa sasa.',
          'A Makambako place-data source has not been selected. No real '
              'businesses are listed yet.',
        ),
      ),
      DiscoveryFailureKind.timeout => (
        _tx(isEnglish, 'Utafutaji umechukua muda mrefu', 'Search timed out'),
        _tx(
          isEnglish,
          'Angalia muunganisho kisha ujaribu tena.',
          'Check your connection and try again.',
        ),
      ),
      DiscoveryFailureKind.serverError => (
        _tx(isEnglish, 'Utafutaji haukupatikana', 'Search is unavailable'),
        _tx(
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
              label: Text(_tx(isEnglish, 'Jaribu tena', 'Try again')),
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
          Icon(icon, size: 32, color: const Color(0xFF237A59)),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1D2B25),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF758179),
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
  const MapProviderUnavailableCard({required this.isEnglish, super.key});

  final bool isEnglish;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1E6),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Icon(Icons.map_outlined, color: Color(0xFF145C45), size: 24),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              _tx(
                isEnglish,
                'Ramani itaonekana baada ya kuchagua mtoa huduma na chanzo cha '
                    'data. Hakuna ramani ya majaribio inayoonyeshwa.',
                'A map will appear after a map provider and data source are '
                    'selected. No mock map is being shown.',
              ),
              style: const TextStyle(
                color: Color(0xFF1D2B25),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
