import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';

/// Stage 4: You've arrived, rating, feedback chips, driver tipping, and receipt.
class RideArrivedStage extends StatelessWidget {
  const RideArrivedStage({
    required this.isEnglish,
    required this.destination,
    required this.totalFare,
    required this.rating,
    required this.selectedFeedback,
    required this.selectedTip,
    required this.onRatingChanged,
    required this.onToggleFeedback,
    required this.onSelectTip,
    required this.onFinish,
    super.key,
  });

  final bool isEnglish;
  final String destination;
  final int totalFare;
  final int rating;
  final Set<String> selectedFeedback;
  final int selectedTip;
  final ValueChanged<int> onRatingChanged;
  final ValueChanged<String> onToggleFeedback;
  final ValueChanged<int> onSelectTip;
  final VoidCallback onFinish;

  static const List<Map<String, String>> _feedbackOptions = [
    {'sw': 'Uendeshaji Salama', 'en': 'Safe riding'},
    {'sw': 'Alifika kwa Wakati', 'en': 'On time'},
    {'sw': 'Chombo Kisafi', 'en': 'Clean vehicle'},
    {'sw': 'Njia Nzuri', 'en': 'Great route'},
    {'sw': 'Mwenye Heshima', 'en': 'Polite rider'},
  ];

  @override
  Widget build(BuildContext context) {
    final isEn = isEnglish;

    return Container(
      key: const ValueKey('stage-arrived'),
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
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          // Dark forest hero header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF143D2B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBBF24),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.black, size: 32),
                ),
                const SizedBox(height: 12),
                Text(
                  tx(isEn, 'Umefika Salama', "You've arrived"),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${destination.split(',').first} · 7 min · 1.8 km',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'TSh ${totalFare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    tx(isEn, '✓ Imelipwa kwa Pesa ya Simu', '✓ Paid with mobile money'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver Review Row
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD7EFE6),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text('HK', style: TextStyle(color: Color(0xFF145C45), fontWeight: FontWeight.w900)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx(isEn, 'Safari yako na Hassan ilikuwaje?', 'How was your ride with Hassan?'),
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          Text(
                            tx(isEn, 'Tathmini yako inaboresha usalama wa safari', 'Your rating helps keep rides safe'),
                            style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Interactive 5 stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starNum = index + 1;
                    return IconButton(
                      icon: Icon(
                        starNum <= rating ? Icons.star_rounded : Icons.star_border_rounded,
                        color: const Color(0xFFF59E0B),
                        size: 36,
                      ),
                      onPressed: () => onRatingChanged(starNum),
                    );
                  }),
                ),
                const SizedBox(height: 12),

                // Feedback Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _feedbackOptions.map((opt) {
                    final label = tx(isEn, opt['sw']!, opt['en']!);
                    final tagKey = opt['en']!;
                    final isSelected = selectedFeedback.contains(tagKey);

                    return FilterChip(
                      selected: isSelected,
                      label: Text(label),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : MakambakoColors.ink,
                      ),
                      backgroundColor: const Color(0xFFF1F5F9),
                      selectedColor: const Color(0xFF145C45),
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide.none,
                      onSelected: (_) => onToggleFeedback(tagKey),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Tip Section
                Text(
                  tx(isEn, 'Ongeza bakshishi kwa Hassan', 'Add a tip for Hassan'),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildTipChip(label: 'TSh 0', tipAmount: 0),
                    const SizedBox(width: 8),
                    _buildTipChip(label: 'TSh 500', tipAmount: 500),
                    const SizedBox(width: 8),
                    _buildTipChip(label: 'TSh 1,000', tipAmount: 1000),
                    const SizedBox(width: 8),
                    _buildTipChip(label: 'TSh 2,000', tipAmount: 2000),
                  ],
                ),
                const SizedBox(height: 22),

                // Done Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    key: const ValueKey('finish-ride-button'),
                    onPressed: onFinish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF145C45),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                    ),
                    child: Text(
                      tx(isEn, 'Maliza Safari', 'Done'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipChip({required String label, required int tipAmount}) {
    final isSelected = selectedTip == tipAmount;
    return Expanded(
      child: OutlinedButton(
        onPressed: () => onSelectTip(tipAmount),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF145C45) : Colors.transparent,
          side: BorderSide(
            color: isSelected ? const Color(0xFF145C45) : const Color(0xFFCBD5E1),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.white : MakambakoColors.ink,
          ),
        ),
      ),
    );
  }
}
