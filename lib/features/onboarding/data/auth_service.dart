import 'package:shared_preferences/shared_preferences.dart';
import '../domain/auth_user.dart';

/// Manages authentication session and onboarding state persistence.
class AuthService {
  const AuthService();

  static const String keyHasCompletedOnboarding = 'mk_yetu.hasCompletedOnboarding';
  static const String keyIsLoggedIn = 'mk_yetu.isLoggedIn';
  static const String keyUserName = 'mk_yetu.userName';
  static const String keyUserPhone = 'mk_yetu.userPhone';
  static const String keyUserWard = 'mk_yetu.userWard';
  static const String keyIsGuest = 'mk_yetu.isGuest';

  /// Checks if the onboarding flow has been finished.
  Future<bool> hasCompletedOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(keyHasCompletedOnboarding) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Sets the onboarding completion flag.
  Future<void> setCompletedOnboarding(bool completed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyHasCompletedOnboarding, completed);
    } catch (_) {
      // Best-effort persistence.
    }
  }

  /// Retrieves the currently signed-in user or null if none.
  Future<AuthUser?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(keyIsLoggedIn) ?? false;
      if (!isLoggedIn) return null;

      return AuthUser(
        name: prefs.getString(keyUserName) ?? 'Mwanajamii wa Makambako',
        phoneOrEmail: prefs.getString(keyUserPhone) ?? '+255 700 000 000',
        isGuest: prefs.getBool(keyIsGuest) ?? false,
        ward: prefs.getString(keyUserWard) ?? 'Makambako Mjini',
      );
    } catch (_) {
      return null;
    }
  }

  /// Persists a logged-in user profile.
  Future<void> saveUser(AuthUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyIsLoggedIn, true);
      await prefs.setString(keyUserName, user.name);
      await prefs.setString(keyUserPhone, user.phoneOrEmail);
      await prefs.setString(keyUserWard, user.ward);
      await prefs.setBool(keyIsGuest, user.isGuest);
      await prefs.setBool(keyHasCompletedOnboarding, true);
    } catch (_) {
      // Best-effort persistence.
    }
  }

  /// Logs out the user and clears login state.
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyIsLoggedIn, false);
      await prefs.remove(keyUserName);
      await prefs.remove(keyUserPhone);
      await prefs.remove(keyUserWard);
      await prefs.setBool(keyIsGuest, false);
    } catch (_) {
      // Best-effort.
    }
  }

  /// Resets onboarding so the intro flow can be previewed again.
  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(keyHasCompletedOnboarding);
      await prefs.remove(keyIsLoggedIn);
    } catch (_) {
      // Best-effort.
    }
  }
}
