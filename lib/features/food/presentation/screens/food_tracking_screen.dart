import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../widgets/food_delivery_map.dart';
import '../widgets/food_tracking_stepper.dart';

/// Screen 4: Live food delivery tracking with vector map, 4-stage stepper, and driver PIN [5 1 8].
class FoodTrackingScreen extends StatelessWidget {
  const FoodTrackingScreen({
    required this.isEnglish,
    required this.restaurantName,
    required this.cartItemCount,
    required this.cartTotal,
    required this.onBrowseMore,
    super.key,
  });

  final bool isEnglish;
  final String restaurantName;
  final int cartItemCount;
  final int cartTotal;
  final VoidCallback onBrowseMore;

  @override
  Widget build(BuildContext context) {
    final isEn = isEnglish;

    return Scaffold(
      backgroundColor: const Color(0xFFE4EDE5),
      body: Stack(
        children: [
          // Modular Vector Delivery Map
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: FoodDeliveryMap(
              restaurantName: restaurantName,
              isEnglish: isEn,
            ),
          ),

          // Bottom Tracking Sheet
          Positioned(
            top: 240,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
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
                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tx(isEn, 'Chakula chako kiko njiani', 'Your food is on the way'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: MakambakoColors.ink),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5F0E8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tx(isEn, 'Kwa wakati', 'On time'),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: MakambakoColors.forest),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tx(isEn, 'Makadirio 14:42 · Agizo #MY-2041', 'Estimated 14:42 · Order #MY-2041'),
                    style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                  ),
                  const SizedBox(height: 16),

                  // 4-Stage Swift UI Stepper (Clean horizontal & vertical hierarchy)
                  FoodTrackingStepper(isEnglish: isEn),
                  const SizedBox(height: 18),

                  // Driver Details Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xFFE2E8F0),
                              child: Icon(Icons.person_rounded, color: MakambakoColors.ink),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Hassan K.', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                                  Text(
                                    tx(isEn, 'Pikipiki Nyekundu · T 482 DKF', 'Red bike · T 482 DKF'),
                                    style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.star_rounded, size: 14, color: Color(0xFFD97706)),
                                  SizedBox(width: 2),
                                  Text('4.9', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Calling Hassan K. (+255 768 123 456)...')),
                                  );
                                },
                                icon: const Icon(Icons.phone_rounded, size: 16),
                                label: Text(tx(isEn, 'Piga simu dereva', 'Call rider')),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                                  foregroundColor: MakambakoColors.ink,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Chat: I will meet you at the gate.')),
                                  );
                                },
                                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                                label: Text(tx(isEn, 'Meseji', 'Message')),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                                  foregroundColor: MakambakoColors.ink,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Delivery PIN Highlight Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFED7AA)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            tx(isEn, 'Mpe namba hii dereva ili kupokea chakula chako', 'Give this code to your rider to receive the order'),
                            style: const TextStyle(fontSize: 12, color: Color(0xFF7C2D12), fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '5 1 8',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                            color: Color(0xFF9A3412),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Order Summary Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$restaurantName · $cartItemCount ${tx(isEn, 'vyakula', 'items')}",
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            'TSh ${cartTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} · ${tx(isEn, 'Imelipwa kwa simu', 'Paid with mobile money')}',
                            style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Return to Restaurants / Done Button
                  OutlinedButton.icon(
                    onPressed: onBrowseMore,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.storefront_rounded, size: 18),
                    label: Text(
                      tx(isEn, 'Angalia Migahawa Mengine', 'Browse More Restaurants'),
                      style: const TextStyle(fontWeight: FontWeight.w700, color: MakambakoColors.ink),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
