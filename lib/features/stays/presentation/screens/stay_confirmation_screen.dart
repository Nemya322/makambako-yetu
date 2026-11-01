import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../../domain/stay_models.dart';

/// Screen 2: "Your room is booked" confirmation screen matching Page 9 of the activity workflow.
class StayConfirmationScreen extends StatelessWidget {
  const StayConfirmationScreen({
    required this.isEnglish,
    required this.guestHouseName,
    required this.room,
    required this.checkInDay,
    required this.checkOutDay,
    required this.totalPrice,
    required this.paidNow,
    required this.payAtCheckIn,
    required this.isPromoApplied,
    required this.appliedPromoCode,
    required this.promoDiscount,
    this.onRideThere,
    this.onViewOnMap,
    required this.onDone,
    super.key,
  });

  final bool isEnglish;
  final String guestHouseName;
  final RoomOption room;
  final int checkInDay;
  final int checkOutDay;
  final int totalPrice;
  final int paidNow;
  final int payAtCheckIn;
  final bool isPromoApplied;
  final String? appliedPromoCode;
  final int promoDiscount;
  final ValueChanged<String>? onRideThere;
  final ValueChanged<String>? onViewOnMap;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final isEn = isEnglish;

    return Scaffold(
      key: const ValueKey('guesthouse-confirmation-screen'),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          // Dark forest green hero header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF143D2B),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBBF24),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.black, size: 32),
                ),
                const SizedBox(height: 14),
                Text(
                  tx(isEn, 'Chumba kimewekwa!', 'Your room is booked'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tx(isEn, 'Tumetuma uthibitisho kwa SMS: 07•• ••• 421', 'We sent the confirmation by SMS to 07•• ••• 421'),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5EDE7)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5EDE5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.hotel_rounded, color: MakambakoColors.forest, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  guestHouseName,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  tx(isEn, room.titleSw, room.titleEn),
                                  style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                                ),
                                Text(
                                  tx(isEn, 'Eneo la Stand Kuu, Makambako', 'Bus Stand area, Makambako'),
                                  style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateSummaryBox(
                              tx(isEn, 'KUINGIA', 'CHECK-IN'),
                              'Sat $checkInDay Nov',
                              tx(isEn, 'Kuanzia 12:00', 'From 12:00'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildDateSummaryBox(
                              tx(isEn, 'KUTOKA', 'CHECK-OUT'),
                              'Mon $checkOutDay Nov',
                              tx(isEn, 'Hadi 10:00', 'By 10:00'),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // BOOKING CODE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx(isEn, 'NAMBARI YA KUHIFADHI', 'BOOKING CODE'),
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: MakambakoColors.muted),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'SG-48213',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5F0E8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, color: Color(0xFF145C45), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  tx(isEn, 'Imethibitishwa', 'Confirmed'),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF145C45)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Applied Promo Savings Banner
                if (isPromoApplied)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: Color(0xFFB45309), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$appliedPromoCode: ${tx(isEn, 'Umeokoa', 'Saved')} TSh ${promoDiscount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Ride There Button (Integrates directly into Ride Hailing)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (onRideThere != null) {
                        onRideThere!(guestHouseName);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              tx(
                                isEn,
                                'Inafungua huduma ya Usafiri kwenda $guestHouseName...',
                                'Opening Ride service to $guestHouseName...',
                              ),
                            ),
                            backgroundColor: const Color(0xFF145C45),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.two_wheeler_rounded, size: 20),
                    label: Text(
                      tx(isEn, 'Omba Usafiri kwenda Hapa', 'Ride there'),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF145C45),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // View on Map Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (onViewOnMap != null) {
                        onViewOnMap!(guestHouseName);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(tx(isEn, 'Inafungua ramani ya kuelekea $guestHouseName...', 'Opening directions to $guestHouseName...')),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.directions_rounded, size: 18),
                    label: Text(
                      tx(isEn, 'Tazama kwenye Ramani', 'View on Map'),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      foregroundColor: MakambakoColors.ink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Done / Back to Home Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: onDone,
                    child: Text(
                      tx(isEn, 'Rudi Nyumbani', 'Back to Home'),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: MakambakoColors.muted),
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

  Widget _buildDateSummaryBox(String label, String value, String sub) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5EDE7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: MakambakoColors.muted),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: const TextStyle(fontSize: 10, color: MakambakoColors.muted),
          ),
        ],
      ),
    );
  }
}
