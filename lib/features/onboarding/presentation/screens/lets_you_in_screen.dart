import 'package:flutter/material.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../widgets/onboarding_illustrations.dart';
import '../widgets/social_login_buttons.dart';

/// Screen 6: "Let's you in" gateway screen offering social login,
/// phone login, password sign-in, guest access, and sign-up link.
class LetsYouInScreen extends StatelessWidget {
  const LetsYouInScreen({
    required this.isEnglish,
    required this.onSignInWithPassword,
    required this.onSignUp,
    required this.onContinueWithPhone,
    required this.onContinueWithGoogle,
    required this.onContinueWithApple,
    required this.onContinueAsGuest,
    this.onBack,
    super.key,
  });

  final bool isEnglish;
  final VoidCallback onSignInWithPassword;
  final VoidCallback onSignUp;
  final VoidCallback onContinueWithPhone;
  final VoidCallback onContinueWithGoogle;
  final VoidCallback onContinueWithApple;
  final VoidCallback onContinueAsGuest;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: MakambakoColors.ink),
                onPressed: onBack,
              )
            : null,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
          physics: const BouncingScrollPhysics(),
          children: [
            // Top Artwork
            const GatewayOnboardingIllustration(),
            const SizedBox(height: 18),

            // Main Title
            Text(
              tx(isEnglish, 'Karibu Ujiunge Nasi', "Let's you in"),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: MakambakoColors.ink,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),

            // Social Buttons
            SocialLoginButton(
              label: tx(isEnglish, 'Endelea na Nambari ya Simu', 'Continue with Phone Number'),
              icon: const TanzaniaPhoneIconWidget(),
              onTap: onContinueWithPhone,
            ),
            SocialLoginButton(
              label: tx(isEnglish, 'Endelea na Google', 'Continue with Google'),
              icon: const GoogleIconWidget(),
              onTap: onContinueWithGoogle,
            ),
            SocialLoginButton(
              label: tx(isEnglish, 'Endelea na Apple', 'Continue with Apple'),
              icon: const Icon(Icons.apple_rounded, size: 24, color: Colors.black),
              onTap: onContinueWithApple,
            ),

            // Divider: ( or )
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFFE5EDE7), thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      tx(isEnglish, 'au', 'or'),
                      style: const TextStyle(
                        color: MakambakoColors.muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE5EDE7), thickness: 1)),
                ],
              ),
            ),

            // Primary Green Button: Sign in with password
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onSignInWithPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1BAC4B),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  tx(isEnglish, 'Ingia kwa Nenosiri', 'Sign in with password'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Secondary Ghost Button: Continue as Guest
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: onContinueAsGuest,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF237A59),
                ),
                child: Text(
                  tx(isEnglish, 'Endelea kama Mgeni bila Akaunti', 'Explore as Guest without Account'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Footer: Don't have an account? Sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tx(isEnglish, 'Huna akaunti bado? ', "Don't have an account? "),
                  style: const TextStyle(
                    color: MakambakoColors.muted,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: onSignUp,
                  child: Text(
                    tx(isEnglish, 'Jisajili', 'Sign up'),
                    style: const TextStyle(
                      color: Color(0xFF1BAC4B),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
