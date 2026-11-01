import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mk_yetu_app/features/onboarding/domain/auth_user.dart';
import 'package:mk_yetu_app/features/onboarding/presentation/onboarding_flow_page.dart';
import 'package:mk_yetu_app/features/onboarding/presentation/screens/lets_you_in_screen.dart';
import 'package:mk_yetu_app/features/onboarding/presentation/screens/onboarding_carousel_screen.dart';
import 'package:mk_yetu_app/features/onboarding/presentation/screens/otp_verification_screen.dart';
import 'package:mk_yetu_app/features/onboarding/presentation/screens/sign_in_screen.dart';
import 'package:mk_yetu_app/features/onboarding/presentation/screens/sign_up_screen.dart';
import 'package:mk_yetu_app/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:mk_yetu_app/features/onboarding/presentation/screens/welcome_hero_screen.dart';
import 'package:mk_yetu_app/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('splash screen shows logo and triggers finish', (tester) async {
    var finished = false;
    await tester.pumpWidget(
      MaterialApp(
        home: SplashScreen(
          onFinish: () => finished = true,
          autoTransitionDuration: const Duration(milliseconds: 100),
        ),
      ),
    );

    expect(find.text('Makambako'), findsOneWidget);
    expect(find.text('Yetu'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 150));
    expect(finished, isTrue);
  });

  testWidgets('welcome hero screen shows greeting, location badge and responds to actions', (
    tester,
  ) async {
    var started = false;
    var toggled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: WelcomeHeroScreen(
          isEnglish: false,
          onGetStarted: () => started = true,
          onToggleLanguage: () => toggled = true,
        ),
      ),
    );

    expect(find.text('Makambako, Njombe'), findsOneWidget);
    expect(find.text('Karibu kwenye\nMakambako Yetu! 👋'), findsOneWidget);
    expect(find.text('Anza Sasa'), findsOneWidget);

    await tester.tap(find.text('🇬🇧 EN'));
    expect(toggled, isTrue);

    await tester.tap(find.text('Anza Sasa'));
    expect(started, isTrue);
  });

  testWidgets('onboarding carousel cycles through Food, Rides, and Community slides', (
    tester,
  ) async {
    var completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingCarouselScreen(
          isEnglish: false,
          onComplete: () => completed = true,
        ),
      ),
    );

    // Slide 1: Food
    expect(find.text('Agiza Chakula Kitamu'), findsOneWidget);
    expect(find.text('Endelea'), findsOneWidget);

    // Advance to Slide 2: Rides
    await tester.tap(find.text('Endelea'));
    await _advance(tester);

    expect(find.text('Usafiri wa Haraka na Uhakika'), findsOneWidget);

    // Advance to Slide 3: Community & Explore
    await tester.tap(find.text('Endelea'));
    await _advance(tester);

    expect(find.text('Gundua Mji na Jamii Yetu'), findsOneWidget);
    expect(find.text('Anza Sasa'), findsOneWidget);

    // Complete carousel
    await tester.tap(find.text('Anza Sasa'));
    await _advance(tester);
    expect(completed, isTrue);
  });

  testWidgets('onboarding carousel skip button finishes directly', (tester) async {
    var completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingCarouselScreen(
          isEnglish: false,
          onComplete: () => completed = true,
        ),
      ),
    );

    await tester.tap(find.text('Ruka'));
    await _advance(tester);
    expect(completed, isTrue);
  });

  testWidgets('lets you in screen renders social buttons and triggers sign in / guest', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var signedIn = false;
    var guest = false;
    var signedUp = false;

    await tester.pumpWidget(
      MaterialApp(
        home: LetsYouInScreen(
          isEnglish: false,
          onSignInWithPassword: () => signedIn = true,
          onSignUp: () => signedUp = true,
          onContinueWithPhone: () {},
          onContinueWithGoogle: () {},
          onContinueWithApple: () {},
          onContinueAsGuest: () => guest = true,
        ),
      ),
    );

    expect(find.text('Karibu Ujiunge Nasi'), findsOneWidget);
    expect(find.text('Endelea na Nambari ya Simu'), findsOneWidget);
    expect(find.text('Endelea na Google'), findsOneWidget);
    expect(find.text('Endelea na Apple'), findsOneWidget);

    await tester.ensureVisible(find.text('Ingia kwa Nenosiri'));
    await tester.tap(find.text('Ingia kwa Nenosiri'));
    expect(signedIn, isTrue);

    await tester.ensureVisible(find.text('Endelea kama Mgeni bila Akaunti'));
    await tester.tap(find.text('Endelea kama Mgeni bila Akaunti'));
    expect(guest, isTrue);

    await tester.ensureVisible(find.text('Jisajili'));
    await tester.tap(find.text('Jisajili'));
    expect(signedUp, isTrue);
  });

  testWidgets('sign up screen accepts details and triggers submission', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    String? submittedName;
    String? submittedPhone;

    await tester.pumpWidget(
      MaterialApp(
        home: SignUpScreen(
          isEnglish: false,
          onSignUpSubmitted: (name, phone) {
            submittedName = name;
            submittedPhone = phone;
          },
          onNavigateToSignIn: () {},
          onBack: () {},
        ),
      ),
    );

    expect(find.text('Fungua Akaunti Mpya'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Baraka Mwakyoma');
    await tester.enterText(find.byType(TextFormField).at(1), '0754112233');
    await tester.enterText(find.byType(TextFormField).at(2), 'secretPass123');

    await tester.ensureVisible(find.text('Jisajili'));
    await tester.tap(find.text('Jisajili'));
    await tester.pumpAndSettle();

    expect(submittedName, 'Baraka Mwakyoma');
    expect(submittedPhone, contains('754112233'));
  });

  testWidgets('sign in screen accepts credentials and calls callback', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    String? submittedContact;

    await tester.pumpWidget(
      MaterialApp(
        home: SignInScreen(
          isEnglish: false,
          onSignInSubmitted: (contact, _) => submittedContact = contact,
          onNavigateToSignUp: () {},
          onBack: () {},
        ),
      ),
    );

    expect(find.text('Ingia kwenye Akaunti'), findsOneWidget);

    await tester.ensureVisible(find.text('Ingia'));
    await tester.tap(find.text('Ingia'));
    await tester.pumpAndSettle();

    expect(submittedContact, isNotNull);
  });

  testWidgets('otp verification screen handles digit taps and backspace', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var verified = false;

    await tester.pumpWidget(
      MaterialApp(
        home: OtpVerificationScreen(
          isEnglish: false,
          phoneOrEmail: '+255 754 112 233',
          onVerified: () => verified = true,
          onBack: () {},
        ),
      ),
    );

    expect(find.text('Uhakiki wa Nambari ya Siri (OTP)'), findsOneWidget);

    // Tap 1, 2, 3, 4
    await tester.tap(find.text('1'));
    await tester.pump();
    await tester.tap(find.text('2'));
    await tester.pump();
    await tester.tap(find.text('3'));
    await tester.pump();
    await tester.tap(find.text('4'));
    await tester.pump();

    // Verify auto-triggers on 4 digits
    await tester.pump(const Duration(milliseconds: 300));
    expect(verified, isTrue);
  });

  testWidgets('onboarding flow coordinator completes and returns user', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    AuthUser? completedUser;

    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingFlowPage(
          initialStep: OnboardingStep.letsYouIn,
          onComplete: (user) => completedUser = user,
        ),
      ),
    );

    await tester.ensureVisible(find.text('Endelea kama Mgeni bila Akaunti'));
    await tester.tap(find.text('Endelea kama Mgeni bila Akaunti'));
    await tester.pumpAndSettle();

    expect(completedUser, isNotNull);
    expect(completedUser!.isGuest, isTrue);
  });

  testWidgets('app boots into onboarding when startWithOnboarding is true', (tester) async {
    await tester.pumpWidget(
      const MakambakoYetuApp(startWithOnboarding: true),
    );

    expect(find.text('Makambako'), findsOneWidget);
    expect(find.text('Yetu'), findsOneWidget);
  });

  testWidgets('splash shows a visible loader with percentage and label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SplashScreen(
          onFinish: () {},
          autoTransitionDuration: const Duration(seconds: 2),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byKey(const ValueKey('splash-progress')), findsOneWidget);
    expect(find.textContaining('Inapakia'), findsOneWidget);
    expect(find.textContaining('%'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('welcome hero shows a moving collage of all services', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WelcomeHeroScreen(
          isEnglish: true,
          onGetStarted: () {},
          onToggleLanguage: () {},
        ),
      ),
    );
    await _advance(tester);

    expect(find.text('Food'), findsWidgets);
    expect(find.text('Rides'), findsWidgets);
    expect(find.text('News'), findsWidgets);
    expect(find.byKey(const ValueKey('welcome-back')), findsNothing);
  });

  testWidgets('carousel back goes to the previous slide, then leaves', (tester) async {
    var left = false;
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingCarouselScreen(
          isEnglish: false,
          onComplete: () {},
          onBack: () => left = true,
        ),
      ),
    );

    await tester.tap(find.text('Endelea'));
    await _advance(tester);
    expect(find.text('Usafiri wa Haraka na Uhakika'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('carousel-back')));
    await _advance(tester);
    expect(find.text('Agiza Chakula Kitamu'), findsOneWidget);
    expect(left, isFalse);

    await tester.tap(find.byKey(const ValueKey('carousel-back')));
    await _advance(tester);
    expect(left, isTrue);
  });

  testWidgets('flow opened from the profile can step back and exit', (tester) async {
    var exited = false;
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingFlowPage(
          initialStep: OnboardingStep.welcomeHero,
          onComplete: (_) {},
          onExit: () => exited = true,
        ),
      ),
    );
    await _advance(tester);

    await tester.tap(find.text('Anza Sasa'));
    await _advance(tester);
    expect(find.text('Agiza Chakula Kitamu'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('carousel-back')));
    await _advance(tester);
    expect(find.text('Karibu kwenye\nMakambako Yetu! \u{1F44B}'), findsOneWidget);
    expect(exited, isFalse);

    await tester.tap(find.byKey(const ValueKey('welcome-back')));
    await _advance(tester);
    expect(exited, isTrue);
  });
}

/// Starts and then advances running animations (page transitions need a first
/// frame to begin before time can elapse).
Future<void> _advance(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}
