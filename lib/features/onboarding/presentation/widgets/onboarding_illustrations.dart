import 'package:flutter/material.dart';

/// Vector illustration for the "Let's You In" gateway screen. (The slide
/// artwork lives in service_collage.dart.)
/// Illustration for "Let's You In" Gateway Screen.
class GatewayOnboardingIllustration extends StatelessWidget {
  const GatewayOnboardingIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular nature backdrop
            Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8F8EE),
                border: Border.all(color: const Color(0xFFBFE7CE), width: 1.5),
              ),
            ),
            // Connected community ring
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF1BAC4B).withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0xFF1BAC4B), Color(0xFF145C45)],
                    ),
                  ),
                  child: const Icon(
                    Icons.groups_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
            // Floating user badges
            Positioned(
              top: 15,
              right: 40,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.person_pin_circle_rounded, color: Colors.green.shade700, size: 24),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 45,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.verified_rounded, color: Colors.blue.shade600, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
