import 'package:flutter/material.dart';
import '../../../../core/theme/makambako_theme.dart';

/// App emblem and logo matching the speed-ring style from the design.
class OnboardingLogo extends StatelessWidget {
  const OnboardingLogo({
    super.key,
    this.size = 76.0,
    this.showTitle = true,
    this.isLight = false,
  });

  final double size;
  final bool showTitle;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size, size * 0.75),
          painter: _SpeedRingLogoPainter(),
        ),
        if (showTitle) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Makambako',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: size * 0.38,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: isLight ? Colors.white : MakambakoColors.ink,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Yetu',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: size * 0.38,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: const Color(0xFF1BAC4B),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Custom painter for the green speed-ring icon seen in the design mockup.
class _SpeedRingLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.65, size.height * 0.5);
    final radius = size.height * 0.42;

    // Outer speed lines on the left
    final speedPaint = Paint()
      ..color = const Color(0xFF1BAC4B)
      ..strokeWidth = size.height * 0.08
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dashY1 = size.height * 0.30;
    final dashY2 = size.height * 0.50;
    final dashY3 = size.height * 0.70;

    canvas.drawLine(
      Offset(size.width * 0.05, dashY1),
      Offset(size.width * 0.38, dashY1),
      speedPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, dashY2),
      Offset(size.width * 0.45, dashY2),
      speedPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.08, dashY3),
      Offset(size.width * 0.36, dashY3),
      speedPaint,
    );

    // Green circular ring
    final ringPaint = Paint()
      ..color = const Color(0xFF1BAC4B)
      ..strokeWidth = size.height * 0.12
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, ringPaint);

    // Inner filled circle with gold/yellow accent (resembling local coin / transport badge)
    final innerPaint = Paint()
      ..color = const Color(0xFFFFB800)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.62, innerPaint);

    // Small center dot / symbol
    final centerDotPaint = Paint()
      ..color = const Color(0xFF145C45)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.28, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
