import 'package:flutter/material.dart';
import '../../../../core/l10n/app_text.dart';
import '../widgets/service_collage.dart';

/// Screen 2: Welcome Hero screen. A moving, tilted collage of every service in
/// the app (food, rides, news, explore, business, stay, services, events,
/// community) sits behind the greeting and primary "Get Started" action.
class WelcomeHeroScreen extends StatelessWidget {
  const WelcomeHeroScreen({
    required this.isEnglish,
    required this.onGetStarted,
    required this.onToggleLanguage,
    this.onBack,
    super.key,
  });

  final bool isEnglish;
  final VoidCallback onGetStarted;
  final VoidCallback onToggleLanguage;

  /// When set, a back button is shown (e.g. when the walkthrough is opened
  /// from the profile).
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B130F),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Moving collage of all services.
          Positioned(
            top: -60,
            left: -90,
            right: -90,
            height: height * 0.78,
            child: RepaintBoundary(
              child: Transform.rotate(
                angle: -0.14,
                child: ServiceMarqueeCollage(isEnglish: isEnglish),
              ),
            ),
          ),

          // Dark gradient: keeps the collage visible at the top and fades to
          // a solid base so the text stays readable.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.38, 0.66, 0.84],
                colors: [
                  Colors.black.withValues(alpha: 0.28),
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.9),
                  const Color(0xFF0B130F),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (onBack != null) ...[
                        InkWell(
                          key: const ValueKey('welcome-back'),
                          onTap: onBack,
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.45),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.location_on_rounded, color: Color(0xFF1BAC4B), size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Makambako, Njombe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: onToggleLanguage,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1BAC4B),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isEnglish ? '🇹🇿 SW' : '🇬🇧 EN',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Text(
                    tx(
                      isEnglish,
                      'Karibu kwenye\nMakambako Yetu! 👋',
                      'Welcome to\nMakambako Yetu! 👋',
                    ),
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    tx(
                      isEnglish,
                      'Chakula, usafiri, habari, biashara, malazi na huduma zote za mji wa Makambako — vyote kiganjani mwako.',
                      'Food, rides, news, businesses, stays and every local service in Makambako — all in the palm of your hand.',
                    ),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: onGetStarted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1BAC4B),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: const Color(0xFF1BAC4B).withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        tx(isEnglish, 'Anza Sasa', 'Get Started'),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
