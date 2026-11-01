import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';

/// Modal bottom sheet for selecting transit payment method.
class PaymentMethodSheet extends StatelessWidget {
  const PaymentMethodSheet({
    required this.isEnglish,
    required this.currentPaymentMethod,
    required this.onSelectPaymentMethod,
    super.key,
  });

  final bool isEnglish;
  final String currentPaymentMethod;
  final ValueChanged<String> onSelectPaymentMethod;

  static void show({
    required BuildContext context,
    required bool isEnglish,
    required String currentPaymentMethod,
    required ValueChanged<String> onSelectPaymentMethod,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => PaymentMethodSheet(
        isEnglish: isEnglish,
        currentPaymentMethod: currentPaymentMethod,
        onSelectPaymentMethod: (method) {
          onSelectPaymentMethod(method);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tx(isEnglish, 'Chagua Njia ya Malipo', 'Payment Method'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            _buildPaymentTile(
              title: 'Mobile money · 07•• ••• 421',
              subtitle: tx(isEnglish, 'M-Pesa / TigoPesa / Airtel Money', 'Automatic prompt on phone'),
              icon: Icons.smartphone_rounded,
            ),
            _buildPaymentTile(
              title: 'Makambako Wallet',
              subtitle: tx(isEnglish, 'Salio: TSh 12,400', 'Balance: TSh 12,400'),
              icon: Icons.account_balance_wallet_rounded,
            ),
            _buildPaymentTile(
              title: tx(isEnglish, 'Pesa Taslimu', 'Cash on delivery'),
              subtitle: tx(isEnglish, 'Mlipe dereva mwisho wa safari', 'Pay your rider in cash'),
              icon: Icons.payments_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = currentPaymentMethod.startsWith(title.split(' · ').first);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE5F0E8) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: selected ? MakambakoColors.forest : MakambakoColors.ink),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: MakambakoColors.muted)),
      trailing: selected
          ? const Icon(Icons.check_circle_rounded, color: MakambakoColors.forest)
          : null,
      onTap: () => onSelectPaymentMethod(title),
    );
  }
}
