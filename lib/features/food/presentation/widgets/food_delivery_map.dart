import 'package:flutter/material.dart';

import '../../../../core/theme/makambako_theme.dart';

/// Ultra-detailed, realistic vector & photorealistic delivery map for food tracking.
///
/// Features:
/// - Photorealistic 3D Makambako town backdrop
/// - Glowing arterial route from restaurant to customer home
/// - Active delivery courier marker with headlight glow and live ETA
/// - Realistic restaurant origin & destination home pins with glass badges
class FoodDeliveryMap extends StatefulWidget {
  const FoodDeliveryMap({
    this.restaurantName = 'Mama Lishe Restaurant',
    this.customerAddress = 'Nyumbani · Makambako',
    this.isEnglish = false,
    this.etaMinutes = 12,
    super.key,
  });

  final String restaurantName;
  final String customerAddress;
  final bool isEnglish;
  final int etaMinutes;

  @override
  State<FoodDeliveryMap> createState() => _FoodDeliveryMapState();
}

class _FoodDeliveryMapState extends State<FoodDeliveryMap> {
  final TransformationController _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _recenter() {
    setState(() {
      _controller.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          // 1. Interactive Photorealistic Town Map Canvas
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _controller,
              minScale: 0.9,
              maxScale: 2.2,
              boundaryMargin: const EdgeInsets.all(50),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // High-resolution Makambako town map
                  Image.asset(
                    'assets/images/makambako_transit_map.jpg',
                    fit: BoxFit.cover,
                    alignment: const Alignment(-0.15, 0.1),
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: const Color(0xFFE2E8F0)),
                  ),

                  // Contrast Vignette
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.35),
                            Colors.black.withValues(alpha: 0.05),
                            Colors.black.withValues(alpha: 0.40),
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Street Label Tag
                  const Positioned(
                    left: 20,
                    top: 48,
                    child: _StreetLabel(text: 'Soko Kuu · Market St'),
                  ),
                  const Positioned(
                    right: 24,
                    bottom: 60,
                    child: _StreetLabel(text: 'Mtaa wa Mwembetogwa'),
                  ),

                  // Glowing Delivery Path
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _FoodDeliveryRoutePainter(),
                    ),
                  ),

                  // Restaurant Origin Marker & Glass Badge
                  Positioned(
                    left: 48,
                    top: 68,
                    child: _DeliveryPointBadge(
                      title: widget.restaurantName,
                      subtitle: widget.isEnglish ? 'Restaurant' : 'Mkahawa',
                      icon: Icons.restaurant_rounded,
                      color: MakambakoColors.forest,
                    ),
                  ),

                  // Customer Destination Marker & Glass Badge
                  Positioned(
                    right: 48,
                    bottom: 45,
                    child: _DeliveryPointBadge(
                      title: widget.customerAddress,
                      subtitle: widget.isEnglish ? 'Drop-off' : 'Utoaji',
                      icon: Icons.home_rounded,
                      color: const Color(0xFFDC2626),
                      alignRight: true,
                    ),
                  ),

                  // Active Delivery Rider Marker (Motorcycle with delivery box)
                  Positioned(
                    left: 170,
                    top: 105,
                    child: _DeliveryRiderMarker(
                      eta: '${widget.etaMinutes} min',
                      isEnglish: widget.isEnglish,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Map Controls (Compass & Recenter)
          Positioned(
            right: 14,
            top: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _GlassIconButton(
                  icon: Icons.explore_rounded,
                  iconColor: const Color(0xFFDC2626),
                  onTap: _recenter,
                ),
                const SizedBox(height: 6),
                _GlassIconButton(
                  icon: Icons.gps_fixed_rounded,
                  iconColor: MakambakoColors.ink,
                  onTap: _recenter,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StreetLabel extends StatelessWidget {
  const _StreetLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Color(0xFF334155),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(icon, size: 16, color: iconColor),
          ),
        ),
      ),
    );
  }
}

class _DeliveryPointBadge extends StatelessWidget {
  const _DeliveryPointBadge({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.alignRight = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: MakambakoColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: EdgeInsets.only(left: alignRight ? 0 : 10, right: alignRight ? 10 : 0),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.45),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 12),
          ),
        ),
      ],
    );
  }
}

class _DeliveryRiderMarker extends StatelessWidget {
  const _DeliveryRiderMarker({
    required this.eta,
    required this.isEnglish,
  });

  final String eta;
  final bool isEnglish;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x38000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delivery_dining_rounded, size: 11, color: Color(0xFFFBBF24)),
              const SizedBox(width: 3),
              Text(
                eta,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
            ),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.two_wheeler_rounded,
            color: Colors.white,
            size: 15,
          ),
        ),
      ],
    );
  }
}

class _FoodDeliveryRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(62, 92);
    final control1 = Offset(size.width * 0.35, 120);
    final control2 = Offset(size.width * 0.50, size.height * 0.55);
    final end = Offset(size.width - 62, size.height - 58);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, end.dx, end.dy);

    // Glowing halo
    final glowPaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: 0.30)
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, glowPaint);

    // Outline
    final outlinePaint = Paint()
      ..color = const Color(0xFF78350F)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, outlinePaint);

    // Core amber line
    final corePaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, corePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
