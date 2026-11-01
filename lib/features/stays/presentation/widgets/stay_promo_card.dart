import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';

/// Swift UI styled promo code banner & manual voucher input for lodging discounts.
class StayPromoCard extends StatelessWidget {
  const StayPromoCard({
    required this.isEnglish,
    required this.isPromoApplied,
    required this.appliedPromoCode,
    required this.promoDiscount,
    required this.promoInputController,
    required this.onApplyPromo,
    required this.onRemovePromo,
    super.key,
  });

  final bool isEnglish;
  final bool isPromoApplied;
  final String? appliedPromoCode;
  final int promoDiscount;
  final TextEditingController promoInputController;
  final ValueChanged<String> onApplyPromo;
  final VoidCallback onRemovePromo;

  @override
  Widget build(BuildContext context) {
    final isEn = isEnglish;

    if (isPromoApplied) {
      return Container(
        key: const ValueKey('hotel-promo-applied-badge'),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFF59E0B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_offer_rounded, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$appliedPromoCode · ${tx(isEn, 'Punguzo la 15% Limetumika', '15% Discount Applied')}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF92400E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${tx(isEn, 'Umeokoa', 'You saved')} TSh ${promoDiscount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}!',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFB45309)),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onRemovePromo,
              child: Text(
                tx(isEn, 'Ondoa', 'Remove'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFB45309),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      key: const ValueKey('hotel-promo-input-box'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EDE7)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined, size: 18, color: MakambakoColors.forest),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: promoInputController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: tx(isEn, 'Una kuponi? (mfano LALA15)', 'Have a promo code? (e.g. LALA15)'),
                hintStyle: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ),
          FilledButton(
            onPressed: () {
              final code = promoInputController.text.trim().toUpperCase();
              if (code.isNotEmpty) {
                onApplyPromo(code);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF145C45),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              tx(isEn, 'Tumia', 'Apply'),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
