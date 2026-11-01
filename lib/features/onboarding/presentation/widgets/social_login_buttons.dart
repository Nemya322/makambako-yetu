import 'package:flutter/material.dart';
import '../../../../core/theme/makambako_theme.dart';

/// Full-width social login pill button seen in the "Let's you in" screen.
class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.textColor = MakambakoColors.ink,
    this.borderColor = const Color(0xFFE5EDE7),
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.only(bottom: 14),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact square social icon button used on Sign Up and Sign In screens.
class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    required this.icon,
    required this.onTap,
    super.key,
  });

  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 76,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5EDE7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(child: icon),
      ),
    );
  }
}

/// Clean Google 'G' icon rendered with vector colors.
class GoogleIconWidget extends StatelessWidget {
  const GoogleIconWidget({this.size = 22.0, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: Text(
        'G',
        style: TextStyle(
          color: const Color(0xFF4285F4),
          fontWeight: FontWeight.w900,
          fontSize: size * 1.1,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}

/// Tanzania Phone Icon with flag badge.
class TanzaniaPhoneIconWidget extends StatelessWidget {
  const TanzaniaPhoneIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🇹🇿', style: TextStyle(fontSize: 18)),
        const SizedBox(width: 4),
        Icon(Icons.phone_iphone_rounded, color: Colors.green.shade700, size: 20),
      ],
    );
  }
}
