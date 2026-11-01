import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../data/auth_service.dart';
import '../domain/auth_user.dart';
import 'screens/lets_you_in_screen.dart';
import 'screens/onboarding_carousel_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_hero_screen.dart';

enum OnboardingStep {
  splash,
  welcomeHero,
  carousel,
  letsYouIn,
  signUp,
  signIn,
  otp,
}

/// The overall coordinator for the Onboarding, Sign Up, & Sign In experience.
class OnboardingFlowPage extends StatefulWidget {
  const OnboardingFlowPage({
    required this.onComplete,
    this.initialStep = OnboardingStep.splash,
    this.isEnglish = false,
    this.onToggleLanguage,
    this.authService = const AuthService(),
    this.onExit,
    super.key,
  });

  final void Function(AuthUser user) onComplete;
  final OnboardingStep initialStep;
  final bool isEnglish;
  final VoidCallback? onToggleLanguage;
  final AuthService authService;

  /// Called when the user backs out of the first step (e.g. when the flow was
  /// opened from the profile). When null, the first step has no back control.
  final VoidCallback? onExit;

  @override
  State<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends State<OnboardingFlowPage> {
  late OnboardingStep _currentStep;
  late bool _isEnglish;
  final List<OnboardingStep> _history = [];

  String _pendingName = 'Mwanajamii';
  String _pendingContact = '+255 754 000 000';

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    _isEnglish = widget.isEnglish;
  }

  @override
  void didUpdateWidget(covariant OnboardingFlowPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEnglish != widget.isEnglish) {
      _isEnglish = widget.isEnglish;
    }
  }

  Future<void> _toggleLanguage() async {
    setState(() => _isEnglish = !_isEnglish);
    widget.onToggleLanguage?.call();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(isEnglishKey, _isEnglish);
    } catch (_) {}
  }

  void _goTo(OnboardingStep step, {bool replace = false}) {
    setState(() {
      if (!replace) _history.add(_currentStep);
      _currentStep = step;
    });
  }

  /// True when a back control should be offered on the current step.
  bool get _canGoBack => _history.isNotEmpty || widget.onExit != null;

  void _back() {
    if (_history.isNotEmpty) {
      setState(() => _currentStep = _history.removeLast());
    } else {
      widget.onExit?.call();
    }
  }

  Future<void> _completeWithUser(AuthUser user) async {
    await widget.authService.saveUser(user);
    if (!mounted) return;
    widget.onComplete(user);
  }

  void _onSignUpSubmitted(String name, String phoneOrEmail) {
    _pendingName = name;
    _pendingContact = phoneOrEmail;
    _goTo(OnboardingStep.otp);
  }

  void _onSignInSubmitted(String phoneOrEmail, String password) {
    final user = AuthUser(
      name: 'Mwanajamii wa Makambako',
      phoneOrEmail: phoneOrEmail,
      isGuest: false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tx(
            _isEnglish,
            'Karibu tena kwenye Makambako Yetu!',
            'Welcome back to Makambako Yetu!',
          ),
        ),
        backgroundColor: MakambakoColors.forest,
        duration: const Duration(seconds: 2),
      ),
    );
    _completeWithUser(user);
  }

  void _onOtpVerified() {
    final user = AuthUser(
      name: _pendingName,
      phoneOrEmail: _pendingContact,
      isGuest: false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tx(
            _isEnglish,
            'Akaunti imethibitishwa kikamilifu! Karibu Makambako Yetu.',
            'Account verified successfully! Welcome to Makambako Yetu.',
          ),
        ),
        backgroundColor: const Color(0xFF1BAC4B),
        duration: const Duration(seconds: 2),
      ),
    );
    _completeWithUser(user);
  }

  void _onGuestContinue() {
    _completeWithUser(AuthUser.guest);
  }

  @override
  Widget build(BuildContext context) {
    // System back / back gesture steps through the flow; it only leaves the
    // flow once there is no earlier step.
    return PopScope(
      canPop: _history.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _back();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: _buildStepWidget(),
      ),
    );
  }

  Widget _buildStepWidget() {
    switch (_currentStep) {
      case OnboardingStep.splash:
        return SplashScreen(
          key: const ValueKey('step-splash'),
          onFinish: () => _goTo(OnboardingStep.welcomeHero, replace: true),
        );

      case OnboardingStep.welcomeHero:
        return WelcomeHeroScreen(
          key: const ValueKey('step-welcome-hero'),
          isEnglish: _isEnglish,
          onGetStarted: () => _goTo(OnboardingStep.carousel),
          onToggleLanguage: _toggleLanguage,
          onBack: _canGoBack ? _back : null,
        );

      case OnboardingStep.carousel:
        return OnboardingCarouselScreen(
          key: const ValueKey('step-carousel'),
          isEnglish: _isEnglish,
          onComplete: () => _goTo(OnboardingStep.letsYouIn),
          onBack: _canGoBack ? _back : null,
        );

      case OnboardingStep.letsYouIn:
        return LetsYouInScreen(
          key: const ValueKey('step-lets-you-in'),
          isEnglish: _isEnglish,
          onSignInWithPassword: () => _goTo(OnboardingStep.signIn),
          onSignUp: () => _goTo(OnboardingStep.signUp),
          onContinueWithPhone: () => _goTo(OnboardingStep.signUp),
          onContinueWithGoogle: () {
            _completeWithUser(
              const AuthUser(
                name: 'Google User',
                phoneOrEmail: 'user@gmail.com',
                isGuest: false,
              ),
            );
          },
          onContinueWithApple: () {
            _completeWithUser(
              const AuthUser(
                name: 'Apple User',
                phoneOrEmail: 'user@icloud.com',
                isGuest: false,
              ),
            );
          },
          onContinueAsGuest: _onGuestContinue,
          onBack: _canGoBack ? _back : null,
        );

      case OnboardingStep.signUp:
        return SignUpScreen(
          key: const ValueKey('step-sign-up'),
          isEnglish: _isEnglish,
          onSignUpSubmitted: _onSignUpSubmitted,
          onNavigateToSignIn: () => _goTo(OnboardingStep.signIn),
          onBack: _back,
        );

      case OnboardingStep.signIn:
        return SignInScreen(
          key: const ValueKey('step-sign-in'),
          isEnglish: _isEnglish,
          onSignInSubmitted: _onSignInSubmitted,
          onNavigateToSignUp: () => _goTo(OnboardingStep.signUp),
          onBack: _back,
        );

      case OnboardingStep.otp:
        return OtpVerificationScreen(
          key: const ValueKey('step-otp'),
          isEnglish: _isEnglish,
          phoneOrEmail: _pendingContact,
          onVerified: _onOtpVerified,
          onBack: _back,
        );
    }
  }
}
