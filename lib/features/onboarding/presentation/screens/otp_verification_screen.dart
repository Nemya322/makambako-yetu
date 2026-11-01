import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../widgets/custom_keypad.dart';

/// Screen 9: "OTP Code Verification" screen matching the final screen in the design mockup.
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    required this.isEnglish,
    required this.phoneOrEmail,
    required this.onVerified,
    required this.onBack,
    super.key,
  });

  final bool isEnglish;
  final String phoneOrEmail;
  final VoidCallback onVerified;
  final VoidCallback onBack;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _pin = '';
  int _secondsLeft = 55;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() => _secondsLeft = 55);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _onDigitTap(String digit) {
    if (_pin.length < 4) {
      setState(() => _pin += digit);
      if (_pin.length == 4) {
        // Automatically verify when all 4 digits are entered!
        Future.delayed(const Duration(milliseconds: 200), _verify);
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  void _verify() {
    if (_pin.length == 4) {
      widget.onVerified();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tx(
              widget.isEnglish,
              'Tafadhali kamilisha nambari 4 za siri',
              'Please enter all 4 digits',
            ),
          ),
          backgroundColor: MakambakoColors.forest,
        ),
      );
    }
  }

  String _maskContact(String contact) {
    if (contact.length <= 6) return contact;
    final start = contact.substring(0, 7);
    final end = contact.substring(contact.length - 2);
    return '$start *** **$end';
  }

  @override
  Widget build(BuildContext context) {
    final masked = _maskContact(widget.phoneOrEmail);

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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 10),
                  // Title
                  Text(
                    tx(widget.isEnglish, 'Uhakiki wa Nambari ya Siri (OTP)', 'OTP Code Verification'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: MakambakoColors.ink,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Subtitle showing phone/email
                  Text(
                    tx(
                      widget.isEnglish,
                      'Nambari ya uhakiki imetumwa kwa $masked',
                      'Code has been sent to $masked',
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: MakambakoColors.muted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 4 PIN Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      final hasDigit = index < _pin.length;
                      final isCurrent = index == _pin.length;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0xFFE8F8EE)
                              : (hasDigit ? Colors.white : const Color(0xFFF8FAF8)),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCurrent
                                ? const Color(0xFF1BAC4B)
                                : (hasDigit
                                    ? const Color(0xFF1BAC4B)
                                    : const Color(0xFFE5EDE7)),
                            width: isCurrent || hasDigit ? 2 : 1.2,
                          ),
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF1BAC4B).withValues(alpha: 0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          hasDigit ? _pin[index] : '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: MakambakoColors.ink,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // Resend Timer Countdown
                  Center(
                    child: _secondsLeft > 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tx(
                                  widget.isEnglish,
                                  'Tuma tena nambari baada ya ',
                                  'Resend code in ',
                                ),
                                style: const TextStyle(
                                  color: MakambakoColors.muted,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '$_secondsLeft s',
                                style: const TextStyle(
                                  color: Color(0xFF1BAC4B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        : TextButton(
                            onPressed: _startTimer,
                            child: Text(
                              tx(widget.isEnglish, 'Tuma Nambari Upya', 'Resend Code Now'),
                              style: const TextStyle(
                                color: Color(0xFF1BAC4B),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),

                  // Verify Pill Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _pin.length == 4 ? _verify : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1BAC4B),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFBFE7CE),
                        disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                        elevation: _pin.length == 4 ? 2 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        tx(widget.isEnglish, 'Hakiki na Maliza', 'Verify'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom On-Screen Custom Numeric Keypad
            CustomNumericKeypad(
              onDigitTap: _onDigitTap,
              onBackspace: _onBackspace,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
