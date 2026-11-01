import 'package:flutter/material.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../widgets/onboarding_logo.dart';
import '../widgets/social_login_buttons.dart';

/// Screen 8: "Login to Your Account" screen matching the design mockup.
class SignInScreen extends StatefulWidget {
  const SignInScreen({
    required this.isEnglish,
    required this.onSignInSubmitted,
    required this.onNavigateToSignUp,
    required this.onBack,
    super.key,
  });

  final bool isEnglish;
  final void Function(String phoneOrEmail, String password) onSignInSubmitted;
  final VoidCallback onNavigateToSignUp;
  final VoidCallback onBack;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneOrEmailController = TextEditingController(text: '+255 754 123 456');
  final _passwordController = TextEditingController(text: '123456');

  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSignInSubmitted(
        _phoneOrEmailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  void _showForgotPasswordDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tx(widget.isEnglish, 'Umesahau Nenosiri?', 'Forgot Password?')),
        content: Text(
          tx(
            widget.isEnglish,
            'Nambari ya kuweka upya nenosiri itatumwa kwenye nambari yako ya simu kwa njia ya ujumbe mfupi (SMS).',
            'A password reset code will be sent to your phone number via SMS.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(tx(widget.isEnglish, 'Sawa', 'OK')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: MakambakoColors.ink),
          onPressed: widget.onBack,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
            physics: const BouncingScrollPhysics(),
            children: [
              // Centered Speed-Ring Emblem
              const Center(
                child: OnboardingLogo(size: 64, showTitle: false),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                tx(widget.isEnglish, 'Ingia kwenye Akaunti', 'Login to Your Account'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: MakambakoColors.ink,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 28),

              // Phone / Email Field
              TextFormField(
                controller: _phoneOrEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: tx(widget.isEnglish, 'Namba ya Simu au Barua pepe', 'Phone number or Email'),
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    margin: const EdgeInsets.only(right: 8),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇹🇿 +255', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: MakambakoColors.muted),
                      ],
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAF8),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE5EDE7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE5EDE7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF1BAC4B), width: 1.8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return tx(widget.isEnglish, 'Weka namba ya simu au barua pepe', 'Enter phone number or email');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: tx(widget.isEnglish, 'Nenosiri', 'Password'),
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: MakambakoColors.muted),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: MakambakoColors.muted,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAF8),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE5EDE7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE5EDE7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF1BAC4B), width: 1.8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tx(widget.isEnglish, 'Weka nenosiri lako', 'Enter your password');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _rememberMe,
                    activeColor: const Color(0xFF1BAC4B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    onChanged: (val) => setState(() => _rememberMe = val ?? true),
                  ),
                  Text(
                    tx(widget.isEnglish, 'Nikumbuke', 'Remember me'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: MakambakoColors.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Green Sign In Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1BAC4B),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    tx(widget.isEnglish, 'Ingia', 'Sign in'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Forgot Password link
              Center(
                child: TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: Text(
                    tx(widget.isEnglish, 'Umesahau nenosiri?', 'Forgot the password?'),
                    style: const TextStyle(
                      color: Color(0xFF1BAC4B),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Divider: or continue with
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFFE5EDE7))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      tx(widget.isEnglish, 'au endelea na', 'or continue with'),
                      style: const TextStyle(
                        color: MakambakoColors.muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE5EDE7))),
                ],
              ),
              const SizedBox(height: 20),

              // Social Icons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialIconButton(
                    icon: const TanzaniaPhoneIconWidget(),
                    onTap: _submit,
                  ),
                  const SizedBox(width: 18),
                  SocialIconButton(
                    icon: const GoogleIconWidget(size: 24),
                    onTap: _submit,
                  ),
                  const SizedBox(width: 18),
                  SocialIconButton(
                    icon: const Icon(Icons.apple_rounded, size: 28, color: Colors.black),
                    onTap: _submit,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Footer: Don't have an account? Sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tx(widget.isEnglish, 'Huna akaunti? ', "Don't have an account? "),
                    style: const TextStyle(
                      color: MakambakoColors.muted,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onNavigateToSignUp,
                    child: Text(
                      tx(widget.isEnglish, 'Jisajili', 'Sign up'),
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
      ),
    );
  }
}
