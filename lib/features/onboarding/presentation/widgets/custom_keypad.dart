import 'package:flutter/material.dart';
import '../../../../core/theme/makambako_theme.dart';

/// Numeric keypad matching the OTP verification screen in the design screenshot.
class CustomNumericKeypad extends StatelessWidget {
  const CustomNumericKeypad({
    required this.onDigitTap,
    required this.onBackspace,
    super.key,
  });

  final ValueChanged<String> onDigitTap;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 12),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 12),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBlankOrDot(),
              _buildKey('0'),
              _buildBackspaceKey(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map(_buildKey).toList(),
    );
  }

  Widget _buildKey(String digit) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onDigitTap(digit),
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: 72,
          height: 52,
          alignment: Alignment.center,
          child: Text(
            digit,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: MakambakoColors.ink,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlankOrDot() {
    return Container(
      width: 72,
      height: 52,
      alignment: Alignment.center,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: MakambakoColors.muted,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onBackspace,
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: 72,
          height: 52,
          alignment: Alignment.center,
          child: const Icon(
            Icons.backspace_outlined,
            color: MakambakoColors.ink,
            size: 22,
          ),
        ),
      ),
    );
  }
}
