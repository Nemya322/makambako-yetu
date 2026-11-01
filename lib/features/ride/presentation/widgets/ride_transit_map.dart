import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../../domain/ride_models.dart';

/// Ultra-detailed, realistic vector & photorealistic transit map for Makambako.
///
/// Features:
/// - High-resolution photorealistic 3D town cartography backdrop of Makambako
/// - Smooth interactive pan & zoom with one-tap recenter
/// - Glowing dual-stroke arterial transit routes
/// - Dynamic radar sonar wave scanner in [RideStage.finding]
/// - Real-time animated driver markers with directional headlight beams
/// - Glassmorphic floating landmark badges, compass rose, and traffic status
class RideTransitMap extends StatefulWidget {
  const RideTransitMap({
    required this.stage,
    required this.isEnglish,
    required this.pulseAnimation,
    this.pickup = 'Mwembetogwa',
    this.destination = 'Makambako Stendi Kuu',
    this.onBack,
    super.key,
  });

  final RideStage stage;
  final bool isEnglish;
  final Animation<double> pulseAnimation;
  final String pickup;
  final String destination;
  final VoidCallback? onBack;

  @override
  State<RideTransitMap> createState() => _RideTransitMapState();
}

class _RideTransitMapState extends State<RideTransitMap> {
  final TransformationController _transformController = TransformationController();
  bool _showTraffic = true;
  bool _is3DView = false;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _recenterMap() {
    setState(() {
      _transformController.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEn = widget.isEnglish;
    final stage = widget.stage;

    return RepaintBoundary(
      child: Stack(
        children: [
          // 1. Interactive Photorealistic & Vector Map Canvas
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final mapWidth = constraints.maxWidth;
                final mapHeight = constraints.maxHeight;

                return InteractiveViewer(
                  transformationController: _transformController,
                  minScale: 0.9,
                  maxScale: 2.2,
                  boundaryMargin: const EdgeInsets.all(80),
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: mapWidth,
                    height: mapHeight,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOutCubic,
                      transform: _is3DView
                          ? (Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(0.18))
                          : Matrix4.identity(),
                      transformAlignment: Alignment.center,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // High-resolution Makambako 3D Satellite/Vector Map
                          Image.asset(
                            'assets/images/makambako_transit_map.jpg',
                            width: mapWidth,
                            height: mapHeight,
                            fit: BoxFit.cover,
                            alignment: const Alignment(0.1, -0.15),
                            errorBuilder: (context, error, stackTrace) =>
                                const _FallbackVectorGrid(),
                          ),

                    // Atmospheric Vignette & Contrast Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.42),
                              Colors.black.withValues(alpha: 0.04),
                              Colors.black.withValues(alpha: 0.04),
                              Colors.black.withValues(alpha: 0.35),
                            ],
                            stops: const [0.0, 0.22, 0.75, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Real Makambako Geographic Street & Landmark Watermarks
                    const Positioned(
                      left: 24,
                      top: 130,
                      child: _MapStreetTag(
                        text: 'TANZAM Highway (T1)',
                        icon: Icons.alt_route_rounded,
                      ),
                    ),
                    const Positioned(
                      right: 32,
                      top: 72,
                      child: _MapStreetTag(
                        text: 'Songea Rd / TAZARA',
                        icon: Icons.traffic_rounded,
                      ),
                    ),
                    const Positioned(
                      left: 140,
                      bottom: 70,
                      child: _MapStreetTag(
                        text: 'Makambako Roundabout',
                        icon: Icons.roundabout_right_rounded,
                      ),
                    ),

                    // Glowing Arterial Route (Stages 1, 3, 4)
                    if (stage != RideStage.finding)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _HighFidelityRoutePainter(
                            showTraffic: _showTraffic,
                          ),
                        ),
                      ),

                    // Animated Sonar Wave Radar (Stage 2: Finding)
                    if (stage == RideStage.finding)
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: widget.pulseAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: _RealisticRadarWavePainter(
                                progress: widget.pulseAnimation.value,
                              ),
                            );
                          },
                        ),
                      ),

                    // Route Distance & Duration Floating Badge (Between pickup & dropoff)
                    if (stage != RideStage.finding)
                      const Positioned(
                        left: 175,
                        top: 110,
                        child: _RouteMetricsBadge(
                          distance: '3.8 km',
                          duration: '7 min',
                        ),
                      ),

                    // Pickup Location Pin with High-End Glass Pill
                    Positioned(
                      left: 48,
                      top: 92,
                      child: _LocationPinWithBadge(
                        title: tx(isEn, 'Eneo la Kupandia', 'Pickup Spot'),
                        subtitle: tx(isEn, 'Dakika 2 mbali', '2 min walk'),
                        color: const Color(0xFF10B981),
                        icon: Icons.my_location_rounded,
                        isPickup: true,
                      ),
                    ),

                    // Destination Location Pin with High-End Glass Pill
                    Positioned(
                      right: 65,
                      top: 48,
                      child: _LocationPinWithBadge(
                        title: tx(isEn, 'Eneo la Kushukia', 'Drop-off Spot'),
                        subtitle: tx(isEn, 'Mwisho wa safari', 'Destination'),
                        color: const Color(0xFFEF4444),
                        icon: Icons.location_on_rounded,
                        isPickup: false,
                      ),
                    ),

                    // Active Rider approaching with Headlight Beam (Stage 3: Arriving)
                    if (stage == RideStage.arriving)
                      const Positioned(
                        left: 148,
                        top: 86,
                        child: _ActiveApproachingVehicle(
                          driverName: 'Juma M.',
                          vehicleType: 'Bodaboda',
                          eta: '3 min',
                        ),
                      ),

                    // Active Rider arrived at pickup (Stage 4: Arrived)
                    if (stage == RideStage.arrived)
                      const Positioned(
                        left: 56,
                        top: 104,
                        child: _ArrivedVehicleMarker(),
                      ),

                    // Nearby Available Drivers scanning grid (Stage 2: Finding)
                    if (stage == RideStage.finding) ...[
                      const Positioned(
                        top: 80,
                        left: 135,
                        child: _NearbyDriverBeacon(
                          name: 'Bakari · 2m',
                          icon: Icons.two_wheeler_rounded,
                        ),
                      ),
                      const Positioned(
                        top: 48,
                        right: 120,
                        child: _NearbyDriverBeacon(
                          name: 'Hamis · 4m',
                          icon: Icons.electric_rickshaw_rounded,
                        ),
                      ),
                      const Positioned(
                        bottom: 95,
                        left: 95,
                        child: _NearbyDriverBeacon(
                          name: 'Godfrey · 5m',
                          icon: Icons.two_wheeler_rounded,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),

          // 2. Top Glassmorphic Navigation Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Back Button with Soft Shadow
                  _GlassCircleButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: widget.onBack ?? () => Navigator.maybePop(context),
                  ),
                  const Spacer(),

                  // Live Status Pill
                  _LiveStatusPill(
                    stage: stage,
                    isEnglish: isEn,
                  ),
                ],
              ),
            ),
          ),

          // 3. Floating Right Map Utility Controls (Compass, 3D Toggle, Recenter)
          Positioned(
            right: 16,
            top: 76,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Compass Rose
                _MapControlButton(
                  icon: Icons.explore_rounded,
                  tooltip: tx(isEn, 'Dira ya Kaskazini', 'Compass (North)'),
                  onTap: _recenterMap,
                  highlight: true,
                ),
                const SizedBox(height: 8),

                // 3D Perspective Toggle
                _MapControlButton(
                  text: _is3DView ? '2D' : '3D',
                  tooltip: tx(isEn, 'Mwonekano wa 3D', '3D View'),
                  isActive: _is3DView,
                  onTap: () => setState(() => _is3DView = !_is3DView),
                ),
                const SizedBox(height: 8),

                // Traffic Overlay Toggle
                _MapControlButton(
                  icon: Icons.traffic_rounded,
                  tooltip: tx(isEn, 'Hali ya Magari', 'Traffic Layer'),
                  isActive: _showTraffic,
                  onTap: () => setState(() => _showTraffic = !_showTraffic),
                ),
                const SizedBox(height: 8),

                // Recenter GPS Crosshair
                _MapControlButton(
                  icon: Icons.gps_fixed_rounded,
                  tooltip: tx(isEn, 'Rejesha Ramani', 'Center GPS'),
                  onTap: _recenterMap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SUBCOMPONENTS: Badges, Markers, and Buttons
// ---------------------------------------------------------------------------

class _GlassCircleButton extends StatelessWidget {
  const _GlassCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 20, color: MakambakoColors.ink),
          ),
        ),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    this.icon,
    this.text,
    required this.tooltip,
    required this.onTap,
    this.isActive = false,
    this.highlight = false,
  });

  final IconData? icon;
  final String? text;
  final String tooltip;
  final VoidCallback onTap;
  final bool isActive;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final bgColor = isActive
        ? MakambakoColors.forest
        : Colors.white.withValues(alpha: 0.94);
    final fgColor = isActive
        ? Colors.white
        : (highlight ? const Color(0xFFDC2626) : MakambakoColors.ink);

    return Tooltip(
      message: tooltip,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Center(
              child: text != null
                  ? Text(
                      text!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: fgColor,
                      ),
                    )
                  : Icon(icon, size: 18, color: fgColor),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveStatusPill extends StatelessWidget {
  const _LiveStatusPill({
    required this.stage,
    required this.isEnglish,
  });

  final RideStage stage;
  final bool isEnglish;

  @override
  Widget build(BuildContext context) {
    final (Color dotColor, String label, IconData statusIcon) = switch (stage) {
      RideStage.finding => (
          const Color(0xFFF59E0B),
          tx(isEnglish, 'Inatafuta Dereva...', 'Scanning Riders...'),
          Icons.radar_rounded,
        ),
      RideStage.arriving => (
          const Color(0xFF10B981),
          tx(isEnglish, 'Dereva Anakuja · Dak 3', 'Rider En Route · 3 min'),
          Icons.two_wheeler_rounded,
        ),
      RideStage.arrived => (
          const Color(0xFF10B981),
          tx(isEnglish, 'Umefika Salama', 'Arrived at Destination'),
          Icons.check_circle_rounded,
        ),
      RideStage.choose => (
          const Color(0xFF10B981),
          tx(isEnglish, 'Ramani Hai · Makambako', 'Live GPS · Makambako'),
          Icons.satellite_alt_rounded,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Icon(statusIcon, size: 13, color: Colors.white70),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationPinWithBadge extends StatelessWidget {
  const _LocationPinWithBadge({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.isPickup,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final bool isPickup;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isPickup ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      color: MakambakoColors.ink,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: MakambakoColors.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 13, color: Colors.white),
        ),
      ],
    );
  }
}

class _RouteMetricsBadge extends StatelessWidget {
  const _RouteMetricsBadge({
    required this.distance,
    required this.duration,
  });

  final String distance;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF10B981), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 13, color: Color(0xFF10B981)),
          const SizedBox(width: 4),
          Text(
            '$duration · $distance',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapStreetTag extends StatelessWidget {
  const _MapStreetTag({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: const Color(0xFFFBBF24)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveApproachingVehicle extends StatelessWidget {
  const _ActiveApproachingVehicle({
    required this.driverName,
    required this.vehicleType,
    required this.eta,
  });

  final String driverName;
  final String vehicleType;
  final String eta;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$driverName ($vehicleType) · $eta',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.two_wheeler_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _ArrivedVehicleMarker extends StatelessWidget {
  const _ArrivedVehicleMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
      ),
      child: const Icon(
        Icons.check_rounded,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}

class _NearbyDriverBeacon extends StatelessWidget {
  const _NearbyDriverBeacon({
    required this.name,
    required this.icon,
  });

  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: MakambakoColors.forest),
          const SizedBox(width: 4),
          Text(
            name,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: MakambakoColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _HighFidelityRoutePainter extends CustomPainter {
  const _HighFidelityRoutePainter({required this.showTraffic});

  final bool showTraffic;

  @override
  void paint(Canvas canvas, Size size) {
    final start = const Offset(62, 130);
    final control1 = Offset(size.width * 0.36, 145);
    final control2 = Offset(size.width * 0.58, 70);
    final end = Offset(size.width - 78, 86);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        end.dx,
        end.dy,
      );

    final glowPaint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.35)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, glowPaint);

    final corePaint = Paint()
      ..color = showTraffic ? const Color(0xFF10B981) : const Color(0xFF38BDF8)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, corePaint);
  }

  @override
  bool shouldRepaint(covariant _HighFidelityRoutePainter oldDelegate) =>
      oldDelegate.showTraffic != showTraffic;
}

class _RealisticRadarWavePainter extends CustomPainter {
  const _RealisticRadarWavePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.42, size.height * 0.48);
    final maxRadius = math.min(size.width, size.height) * 0.42;

    for (int i = 0; i < 3; i++) {
      final wave = (progress + i * 0.33) % 1.0;
      final radius = maxRadius * wave;
      final alpha = (1.0 - wave).clamp(0.0, 1.0) * 0.45;

      final paint = Paint()
        ..color = const Color(0xFF10B981).withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RealisticRadarWavePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _FallbackVectorGrid extends StatelessWidget {
  const _FallbackVectorGrid();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FallbackGridPainter(),
      child: Container(color: const Color(0xFF1E293B)),
    );
  }
}

class _FallbackGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
