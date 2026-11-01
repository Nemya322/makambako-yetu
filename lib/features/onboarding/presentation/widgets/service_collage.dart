import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';

enum AppServiceId {
  food,
  ride,
  news,
  explore,
  business,
  stay,
  services,
  events,
  community,
}

/// A service offered by Makambako Yetu, used to build the onboarding collage.
class AppService {
  const AppService({
    required this.id,
    required this.icon,
    required this.sw,
    required this.en,
    required this.subSw,
    required this.subEn,
    required this.colors,
  });

  final AppServiceId id;
  final IconData icon;
  final String sw;
  final String en;
  final String subSw;
  final String subEn;
  final List<Color> colors;
}

const List<AppService> appServices = [
  AppService(
    id: AppServiceId.food,
    icon: Icons.restaurant_rounded,
    sw: 'Chakula',
    en: 'Food',
    subSw: 'Agiza hadi mlangoni',
    subEn: 'Delivered to your door',
    colors: [Color(0xFFFF9A44), Color(0xFFE8552B)],
  ),
  AppService(
    id: AppServiceId.ride,
    icon: Icons.two_wheeler_rounded,
    sw: 'Usafiri',
    en: 'Rides',
    subSw: 'Bodaboda na bajaji',
    subEn: 'Bodaboda & bajaji',
    colors: [Color(0xFF2FBF6B), Color(0xFF14804A)],
  ),
  AppService(
    id: AppServiceId.news,
    icon: Icons.newspaper_rounded,
    sw: 'Habari',
    en: 'News',
    subSw: 'Taarifa za mji',
    subEn: 'Town updates',
    colors: [Color(0xFF4C8DFF), Color(0xFF2753C9)],
  ),
  AppService(
    id: AppServiceId.explore,
    icon: Icons.explore_rounded,
    sw: 'Gundua',
    en: 'Explore',
    subSw: 'Maeneo karibu nawe',
    subEn: 'Places near you',
    colors: [Color(0xFF22C7B8), Color(0xFF0E8277)],
  ),
  AppService(
    id: AppServiceId.business,
    icon: Icons.storefront_rounded,
    sw: 'Biashara',
    en: 'Business',
    subSw: 'Maduka na wajasiriamali',
    subEn: 'Shops & entrepreneurs',
    colors: [Color(0xFFB36BFF), Color(0xFF6E2FC4)],
  ),
  AppService(
    id: AppServiceId.stay,
    icon: Icons.hotel_rounded,
    sw: 'Malazi',
    en: 'Stay',
    subSw: 'Hoteli na nyumba za wageni',
    subEn: 'Hotels & guest houses',
    colors: [Color(0xFF6C7BFF), Color(0xFF3541B8)],
  ),
  AppService(
    id: AppServiceId.services,
    icon: Icons.local_hospital_rounded,
    sw: 'Huduma',
    en: 'Services',
    subSw: 'Afya, benki na zaidi',
    subEn: 'Health, banks & more',
    colors: [Color(0xFFFF6B8B), Color(0xFFC72A55)],
  ),
  AppService(
    id: AppServiceId.events,
    icon: Icons.event_rounded,
    sw: 'Matukio',
    en: 'Events',
    subSw: 'Shughuli za eneo',
    subEn: 'Local happenings',
    colors: [Color(0xFFFFC53D), Color(0xFFE08A00)],
  ),
  AppService(
    id: AppServiceId.community,
    icon: Icons.people_alt_rounded,
    sw: 'Jamii',
    en: 'Community',
    subSw: 'Matangazo ya jamii',
    subEn: 'Community notices',
    colors: [Color(0xFF8BC34A), Color(0xFF4F8A1E)],
  ),
];

AppService serviceById(AppServiceId id) =>
    appServices.firstWhere((service) => service.id == id);

class _TileSpec {
  const _TileSpec(this.service, this.height);

  final AppService service;
  final double height;
}

/// A slowly scrolling, tilted wall of service tiles (three columns moving in
/// alternating directions). Used as the animated backdrop of the welcome page.
class ServiceMarqueeCollage extends StatefulWidget {
  const ServiceMarqueeCollage({required this.isEnglish, super.key});

  final bool isEnglish;

  @override
  State<ServiceMarqueeCollage> createState() => _ServiceMarqueeCollageState();
}

class _ServiceMarqueeCollageState extends State<ServiceMarqueeCollage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 40),
  )..repeat();

  static const List<double> _heights = [150, 190, 140, 170, 210, 150, 180, 140, 200];

  List<_TileSpec> _column(int offset) => [
        for (var i = 0; i < appServices.length; i++)
          _TileSpec(
            appServices[(i + offset) % appServices.length],
            _heights[(i * 2 + offset) % _heights.length],
          ),
      ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _MarqueeColumn(
              animation: _controller,
              tiles: _column(0),
              loops: 2,
              isEnglish: widget.isEnglish,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _MarqueeColumn(
              animation: _controller,
              tiles: _column(3),
              loops: 3,
              reverse: true,
              isEnglish: widget.isEnglish,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _MarqueeColumn(
              animation: _controller,
              tiles: _column(6),
              loops: 2,
              isEnglish: widget.isEnglish,
            ),
          ),
        ],
      ),
    );
  }
}

class _MarqueeColumn extends StatelessWidget {
  const _MarqueeColumn({
    required this.animation,
    required this.tiles,
    required this.loops,
    required this.isEnglish,
    this.reverse = false,
  });

  static const double _gap = 10;

  final Animation<double> animation;
  final List<_TileSpec> tiles;
  final int loops;
  final bool isEnglish;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final setHeight =
        tiles.fold<double>(0, (sum, tile) => sum + tile.height + _gap);
    final oneSet = [
      for (final tile in tiles)
        Padding(
          padding: const EdgeInsets.only(bottom: _gap),
          child: SizedBox(
            height: tile.height,
            child: _ServiceTile(service: tile.service, isEnglish: isEnglish),
          ),
        ),
    ];

    return RepaintBoundary(
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topCenter,
          minHeight: 0,
          maxHeight: double.infinity,
          child: AnimatedBuilder(
            animation: animation,
            // Two copies make the loop seamless. RepaintBoundary caches the layout
            // so translating the column doesn't re-render individual tiles.
            child: RepaintBoundary(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [...oneSet, ...oneSet],
              ),
            ),
            builder: (context, child) {
              final progress = (animation.value * loops) % 1.0;
              final dy = reverse
                  ? -setHeight + progress * setHeight
                  : -progress * setHeight;
              return Transform.translate(offset: Offset(0, dy), child: child);
            },
          ),
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service, required this.isEnglish});

  final AppService service;
  final bool isEnglish;

  @override
  Widget build(BuildContext context) {
    final isFood = service.id == AppServiceId.food;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: service.colors,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isFood)
              Image.asset(
                'assets/images/onboarding_hero.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            if (isFood)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
            Positioned(
              right: -16,
              bottom: -16,
              child: Icon(
                service.icon,
                size: 104,
                color: Colors.white.withValues(alpha: 0.17),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.24),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(service.icon, color: Colors.white, size: 21),
                  ),
                  const Spacer(),
                  Text(
                    tx(isEnglish, service.sw, service.en),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    tx(isEnglish, service.subSw, service.subEn),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A highlighted service in the middle with every other app service orbiting
/// around it - a moving collage of everything the app offers.
class ServiceOrbit extends StatefulWidget {
  const ServiceOrbit({required this.focus, super.key});

  final AppServiceId focus;

  @override
  State<ServiceOrbit> createState() => _ServiceOrbitState();
}

class _ServiceOrbitState extends State<ServiceOrbit>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 28),
  )..repeat();

  static const double _extent = 280;
  static const double _radius = 108;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focus = serviceById(widget.focus);
    final others = appServices.where((s) => s.id != widget.focus).toList();

    return SizedBox(
      height: _extent,
      width: double.infinity,
      child: Center(
        child: SizedBox(
          width: _extent,
          height: _extent,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = _controller.value;
              final pulse = math.sin(t * 2 * math.pi * 14);
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: _extent - 40,
                    height: _extent - 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE8F8EE),
                      border: Border.all(
                        color: const Color(0xFFBFE7CE),
                        width: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    width: _radius * 2,
                    height: _radius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1BAC4B).withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                  ),
                  for (var i = 0; i < others.length; i++)
                    _orbitBadge(others[i], i, others.length, t),
                  Transform.scale(
                    scale: 1 + 0.05 * pulse,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: focus.colors,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: focus.colors.last.withValues(alpha: 0.4),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(focus.icon, color: Colors.white, size: 58),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _orbitBadge(AppService service, int index, int count, double t) {
    final angle = (2 * math.pi * index / count) + t * 2 * math.pi;
    final bob = 0.92 + 0.08 * math.sin(t * 2 * math.pi * 14 + index);
    return Transform.translate(
      offset: Offset(math.cos(angle) * _radius, math.sin(angle) * _radius),
      child: Transform.scale(
        scale: bob,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: service.colors,
            ),
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(service.icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
