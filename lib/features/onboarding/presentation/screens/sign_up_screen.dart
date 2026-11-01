import 'package:flutter/material.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../widgets/onboarding_logo.dart';
import '../widgets/social_login_buttons.dart';

/// Screen 7: "Create New Account" sign up screen matching the design mockup.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    required this.isEnglish,
    required this.onSignUpSubmitted,
    required this.onNavigateToSignIn,
    required this.onBack,
    super.key,
  });

  final bool isEnglish;
  final void Function(String name, String phoneOrEmail) onSignUpSubmitted;
  final VoidCallback onNavigateToSignIn;
  final VoidCallback onBack;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final formattedPhone = phone.startsWith('+255')
          ? phone
          : (phone.startsWith('0') ? '+255 ${phone.substring(1)}' : '+255 $phone');

      widget.onSignUpSubmitted(name, formattedPhone);
    }
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
                tx(widget.isEnglish, 'Fungua Akaunti Mpya', 'Create New Account'),
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

              // Full Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: tx(widget.isEnglish, 'Jina Kamili', 'Full Name'),
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: MakambakoColors.muted),
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
                    return tx(widget.isEnglish, 'Tafadhali weka jina lako', 'Please enter your name');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone / Email Field with Tanzania Country Code Badge
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: tx(widget.isEnglish, '712 345 678 au Barua pepe', '712 345 678 or Email'),
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
                    return tx(widget.isEnglish, 'Tafadhali weka nambari ya simu', 'Please enter your phone number');
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
                  if (value == null || value.length < 4) {
                    return tx(widget.isEnglish, 'Nenosiri liwe na herufi angalau 4', 'Password must be at least 4 characters');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Remember Me Checkbox
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

              // Green Sign Up Button
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
                    tx(widget.isEnglish, 'Jisajili', 'Sign up'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

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

              // Footer: Already have an account? Sign in
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tx(widget.isEnglish, 'Tayari una akaunti? ', 'Already have an account? '),
                    style: const TextStyle(
                      color: MakambakoColors.muted,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onNavigateToSignIn,
                    child: Text(
                      tx(widget.isEnglish, 'Ingia', 'Sign in'),
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
