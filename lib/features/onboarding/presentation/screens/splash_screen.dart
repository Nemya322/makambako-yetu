import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../widgets/onboarding_logo.dart';

/// Screen 1: Splash screen with the logo and a clearly visible progress loader
/// (ring with live percentage plus a "loading" label).
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    required this.onFinish,
    this.autoTransitionDuration = const Duration(milliseconds: 2800),
    super.key,
  });

  final VoidCallback onFinish;
  final Duration autoTransitionDuration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  Timer? _timer;
  late final AnimationController _enterController;
  late final AnimationController _progressController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _progressController = AnimationController(
      vsync: this,
      duration: widget.autoTransitionDuration,
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _timer = Timer(widget.autoTransitionDuration, () {
      if (mounted) widget.onFinish();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _enterController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enter = CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOutBack,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onFinish,
        child: SafeArea(
          child: Stack(
            children: [
              // Soft pulsing halo behind the logo.
              Center(
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) {
                    final t = Curves.easeInOut.transform(_pulseController.value);
                    return Container(
                      width: 190 + 40 * t,
                      height: 190 + 40 * t,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1BAC4B).withValues(alpha: 0.07 + 0.05 * (1 - t)),
                      ),
                    );
                  },
                ),
              ),

              // Logo + tagline
              Center(
                child: ScaleTransition(
                  scale: enter,
                  child: FadeTransition(
                    opacity: _enterController,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OnboardingLogo(size: 96, showTitle: true),
                        SizedBox(height: 8),
                        Text(
                          'Huduma na maisha ya mji wa Makambako',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: MakambakoColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Loader: determinate ring with percentage + label + bar.
              Positioned(
                bottom: 44,
                left: 40,
                right: 40,
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, _) {
                    final value = Curves.easeInOut.transform(_progressController.value);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 76,
                          height: 76,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox.expand(
                                child: CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 6,
                                  strokeCap: StrokeCap.round,
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF1BAC4B),
                                  ),
                                  backgroundColor: const Color(0xFFD6EFDF),
                                ),
                              ),
                              Text(
                                '${(value * 100).round()}%',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: MakambakoColors.forest,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            key: const ValueKey('splash-progress'),
                            value: value,
                            minHeight: 8,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF1BAC4B),
                            ),
                            backgroundColor: const Color(0xFFD6EFDF),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Inapakia… Tafadhali subiri',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: MakambakoColors.forest,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
