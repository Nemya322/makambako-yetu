import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/l10n/app_text.dart';
import 'core/theme/makambako_theme.dart';
import 'features/discovery/data/development_fixture_place_repository.dart';
import 'features/discovery/domain/place_repository.dart';
import 'features/onboarding/domain/auth_user.dart';
import 'features/onboarding/presentation/onboarding_flow_page.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'features/shell/makambako_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // By default, start with the loading seconds (Splash) and show the moving
  // collage hero screen on startup as requested.
  bool initialIsEnglish = false;
  try {
    final prefs = await SharedPreferences.getInstance();
    initialIsEnglish = prefs.getBool(isEnglishKey) ?? false;
  } catch (_) {}
  runApp(
    MakambakoYetuApp(
      startWithSplash: true,
      startWithOnboarding: true,
      initialIsEnglish: initialIsEnglish,
    ),
  );
}

/// Root widget of Makambako Yetu.
///
/// When [startWithSplash] is true (default on app launch), the app presents
/// the branded animated splash screen with a progress loader.
/// When [startWithOnboarding] is true, users are welcomed with the moving collage
/// hero and onboarding walkthrough before entering the app.
/// When false (such as in standard unit/widget tests), the app opens directly
/// into the home shell.
class MakambakoYetuApp extends StatefulWidget {
  const MakambakoYetuApp({
    super.key,
    this.placeRepository = const DevelopmentFixturePlaceRepository(),
    this.startWithSplash = false,
    this.startWithOnboarding = false,
    this.initialIsEnglish = false,
  });

  final PlaceRepository placeRepository;
  final bool startWithSplash;
  final bool startWithOnboarding;
  final bool initialIsEnglish;

  @override
  State<MakambakoYetuApp> createState() => _MakambakoYetuAppState();
}

class _MakambakoYetuAppState extends State<MakambakoYetuApp> {
  late bool _showSplash;
  late bool _showOnboarding;
  late bool _isEnglish;

  @override
  void initState() {
    super.initState();
    _showSplash = widget.startWithSplash;
    _showOnboarding = widget.startWithOnboarding;
    _isEnglish = widget.initialIsEnglish;
  }

  void _onSplashFinish() {
    if (mounted) {
      setState(() => _showSplash = false);
    }
  }

  void _onOnboardingComplete(AuthUser user) {
    if (mounted) {
      setState(() => _showOnboarding = false);
    }
  }

  void _toggleLanguage() {
    setState(() => _isEnglish = !_isEnglish);
  }

  @override
  Widget build(BuildContext context) {
    Widget homeWidget;
    if (_showSplash) {
      homeWidget = SplashScreen(
        key: const ValueKey('app-splash'),
        onFinish: _onSplashFinish,
      );
    } else if (_showOnboarding) {
      homeWidget = OnboardingFlowPage(
        initialStep: widget.startWithSplash
            ? OnboardingStep.welcomeHero
            : OnboardingStep.splash,
        isEnglish: _isEnglish,
        onToggleLanguage: _toggleLanguage,
        onComplete: _onOnboardingComplete,
      );
    } else {
      homeWidget = MakambakoHomePage(
        placeRepository: widget.placeRepository,
        initialIsEnglish: _isEnglish,
      );
    }

    return MaterialApp(
      title: 'Makambako Yetu',
      debugShowCheckedModeBanner: false,
      theme: buildMakambakoTheme(),
      home: homeWidget,
    );
  }
}
