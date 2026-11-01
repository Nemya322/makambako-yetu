import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../../domain/stay_models.dart';
import '../widgets/stay_hero_header.dart';
import '../widgets/stay_promo_card.dart';

/// Screen 1: Date selection, room selection, promo coupon, and booking CTA.
class StayBookingScreen extends StatelessWidget {
  const StayBookingScreen({
    required this.isEnglish,
    required this.guestHouseName,
    required this.rooms,
    required this.selectedRoomIndex,
    required this.checkInDay,
    required this.checkOutDay,
    required this.nights,
    required this.basePrice,
    required this.promoDiscount,
    required this.totalPrice,
    required this.paidNow,
    required this.payAtCheckIn,
    required this.isPromoApplied,
    required this.appliedPromoCode,
    required this.promoInputController,
    required this.onSelectRoom,
    required this.onSelectDays,
    required this.onApplyPromo,
    required this.onRemovePromo,
    required this.onConfirmBooking,
    this.onBack,
    super.key,
  });

  final bool isEnglish;
  final String guestHouseName;
  final List<RoomOption> rooms;
  final int selectedRoomIndex;
  final int checkInDay;
  final int checkOutDay;
  final int nights;
  final int basePrice;
  final int promoDiscount;
  final int totalPrice;
  final int paidNow;
  final int payAtCheckIn;
  final bool isPromoApplied;
  final String? appliedPromoCode;
  final TextEditingController promoInputController;
  final ValueChanged<int> onSelectRoom;
  final void Function(int inDay, int outDay) onSelectDays;
  final ValueChanged<String> onApplyPromo;
  final VoidCallback onRemovePromo;
  final VoidCallback onConfirmBooking;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final isEn = isEnglish;
    final selectedRoom = rooms[selectedRoomIndex];
    final roomName = tx(isEn, selectedRoom.titleSw, selectedRoom.titleEn);

    return Scaffold(
      key: const ValueKey('guesthouse-booking-screen'),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        physics: const BouncingScrollPhysics(),
        children: [
          StayHeroHeader(onBack: onBack),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel title & Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        guestHouseName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: MakambakoColors.ink,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F0E8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star_rounded, size: 16, color: Color(0xFF145C45)),
                          SizedBox(width: 4),
                          Text(
                            '4.8',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF145C45),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 14, color: MakambakoColors.muted),
                    const SizedBox(width: 4),
                    Text(
                      tx(isEn, 'Eneo la Stand Kuu, Makambako', 'Bus Stand area, Makambako'),
                      style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Amenities
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildAmenityChip(Icons.wifi_rounded, 'Wi-Fi ya bure'),
                    _buildAmenityChip(Icons.power_rounded, 'Jenereta'),
                    _buildAmenityChip(Icons.hot_tub_rounded, 'Maji moto'),
                    _buildAmenityChip(Icons.local_cafe_rounded, 'Chai asubuhi'),
                    _buildAmenityChip(Icons.local_parking_rounded, 'Maegesho'),
                  ],
                ),
                const SizedBox(height: 20),

                // Date summary boxes
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDateSummaryBox(
                        tx(isEn, 'WAGENI', 'GUESTS'),
                        tx(isEn, 'Watu 2', '2 adults'),
                        '$nights ${tx(isEn, 'usiku', 'nights')}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Room Options
                Text(
                  tx(isEn, 'Chagua chumba', 'Choose a room'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),

                ...List.generate(rooms.length, (index) {
                  final room = rooms[index];
                  final isSelected = selectedRoomIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF145C45) : const Color(0xFFE5EDE7),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => onSelectRoom(index),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx(isEn, room.titleSw, room.titleEn),
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      tx(isEn, room.descSw, room.descEn),
                                      style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      tx(isEn, room.leftSw, room.leftEn),
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFB45309)),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'TSh ${room.pricePerNight.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    tx(isEn, 'kwa usiku', 'per night'),
                                    style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 14),

                // Swift UI Styled Promo Code Card
                StayPromoCard(
                  isEnglish: isEn,
                  isPromoApplied: isPromoApplied,
                  appliedPromoCode: appliedPromoCode,
                  promoDiscount: promoDiscount,
                  promoInputController: promoInputController,
                  onApplyPromo: onApplyPromo,
                  onRemovePromo: onRemovePromo,
                ),
                const SizedBox(height: 14),

                // Price Details Breakdown
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAF9),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5EDE7)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$nights ${tx(isEn, 'usiku', 'nights')} × TSh ${rooms[selectedRoomIndex].pricePerNight.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: MakambakoColors.muted),
                          ),
                          Text(
                            'TSh ${basePrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: MakambakoColors.ink),
                          ),
                        ],
                      ),
                      if (isPromoApplied) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${tx(isEn, 'Punguzo la Promo', 'Promo Discount')} ($appliedPromoCode - 15%)',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFB45309)),
                            ),
                            Text(
                              '- TSh ${promoDiscount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFFB45309)),
                            ),
                          ],
                        ),
                      ],
                      const Divider(height: 20, color: Color(0xFFE5EDE7)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tx(isEn, 'Jumla ya Malazi', 'Total stay price'),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: MakambakoColors.ink),
                          ),
                          Text(
                            'TSh ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF145C45)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            key: const ValueKey('confirm-hotel-booking-button'),
            onPressed: onConfirmBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF145C45),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
            ),
            child: Text(
              tx(
                isEn,
                'Weka $roomName · TSh ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                'Book $roomName · TSh ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmenityChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F0E8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: MakambakoColors.forest),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: MakambakoColors.forest),
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
