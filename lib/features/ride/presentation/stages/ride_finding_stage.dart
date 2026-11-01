import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';

/// Stage 2: Finding your rider with live progress, radar info, and fare booster chips.
class RideFindingStage extends StatelessWidget {
  const RideFindingStage({
    required this.isEnglish,
    required this.pickup,
    required this.destination,
    required this.vehicleName,
    required this.totalFare,
    required this.extraFare,
    required this.onBoostFare,
    required this.onCancel,
    super.key,
  });

  final bool isEnglish;
  final String pickup;
  final String destination;
  final String vehicleName;
  final int totalFare;
  final int extraFare;
  final ValueChanged<int> onBoostFare;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isEn = isEnglish;

    return Container(
      key: const ValueKey('stage-finding'),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 18,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            tx(isEn, 'Inatafuta dereva wako', 'Finding your rider'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: MakambakoColors.ink,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            tx(
              isEn,
              'Inauliza madereva 3 wa karibu na Soko Kuu. Kawaida huchukua chini ya dakika 1.',
              'Asking 3 bike riders near Main Market. This usually takes under a minute.',
            ),
            style: const TextStyle(fontSize: 13, color: MakambakoColors.muted, height: 1.4),
          ),
          const SizedBox(height: 16),

          // Animated progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const LinearProgressIndicator(
              minHeight: 5,
              color: Color(0xFF145C45),
              backgroundColor: Color(0xFFE5EDE7),
            ),
          ),
          const SizedBox(height: 18),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF9),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5EDE7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$vehicleName · ${pickup.split(',').first}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'TSh ${totalFare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF145C45),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${tx(isEn, 'Kushuka', 'Drop-off')}: $destination',
                  style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (extraFare > 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    '+ TSh $extraFare ${tx(isEn, 'ongezeko la haraka limetumika', 'priority boost active')}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Fare Booster Title
          Text(
            tx(isEn, 'Ongeza nauli ili upate dereva haraka', 'Boost fare for faster pickup'),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            tx(
              isEn,
              'Madereva hupendelea safari zenye motisha wakati wa msongamano.',
              'Riders are more likely to accept during busy peak hours.',
            ),
            style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
          ),
          const SizedBox(height: 12),

          // Booster chips
          Row(
            children: [
              _buildFareBoosterChip('+ TSh 500', 500),
              const SizedBox(width: 8),
              _buildFareBoosterChip('+ TSh 1,000', 1000),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => onBoostFare(1500),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    tx(isEn, 'Nyingine', 'Other'),
                    style: const TextStyle(color: MakambakoColors.ink, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Cancel request button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                tx(isEn, 'Ghairi ombi', 'Cancel request'),
                style: const TextStyle(
                  color: Color(0xFFDC2626),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFareBoosterChip(String label, int amount) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => onBoostFare(amount),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFCBD5E1)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(
          label,
          style: const TextStyle(color: MakambakoColors.ink, fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
    );
  }
}
