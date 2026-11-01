import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../../domain/ride_models.dart';

/// Stage 3: Driver Matched & Arriving with 4-digit Security PIN [4 7 2 9].
class RideArrivingStage extends StatelessWidget {
  const RideArrivingStage({
    required this.isEnglish,
    required this.pickup,
    required this.destination,
    required this.vehicleName,
    required this.totalFare,
    this.driver = DriverDetails.defaultDriver,
    required this.onCancel,
    required this.onSimulateArrived,
    super.key,
  });

  final bool isEnglish;
  final String pickup;
  final String destination;
  final String vehicleName;
  final int totalFare;
  final DriverDetails driver;
  final VoidCallback onCancel;
  final VoidCallback onSimulateArrived;

  @override
  Widget build(BuildContext context) {
    final isEn = isEnglish;

    return Container(
      key: const ValueKey('stage-arriving'),
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
          const SizedBox(height: 14),

          // Title & Subtitle
          Text(
            tx(isEn, '${driver.name.split(' ').first} anafika baada ya dak 3', '${driver.name.split(' ').first} is arriving in 3 min'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: MakambakoColors.ink,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            tx(
              isEn,
              'Subiri kwenye geti la Soko Kuu. Atakupigia iwapo hatakuona.',
              'Wait at the Main Market gate. He will call if he can\'t find you.',
            ),
            style: const TextStyle(fontSize: 13, color: MakambakoColors.muted, height: 1.4),
          ),
          const SizedBox(height: 16),

          // Driver Profile Row
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xFFD7EFE6),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  driver.initials,
                  style: const TextStyle(
                    color: Color(0xFF145C45),
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(
                          '${driver.rating} · ${driver.totalTrips} ${tx(isEn, 'safari', 'trips')}',
                          style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      driver.plateNumber,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      tx(isEn, driver.vehicleDescriptionSw, driver.vehicleDescriptionEn),
                      style: const TextStyle(fontSize: 10, color: MakambakoColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action Pills (Call, Chat, Share)
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tx(isEn, 'Inapiga simu kwa ${driver.name} (${driver.phoneNumber})...', 'Calling ${driver.name} (${driver.phoneNumber})...'))),
                    );
                  },
                  icon: const Icon(Icons.call_rounded, size: 17),
                  label: Text(tx(isEn, 'Piga', 'Call')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF145C45),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tx(isEn, 'Ujumbe: Nipo geti kuu la sokoni', 'Chat: I am at the main market gate'))),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 17),
                  label: Text(tx(isEn, 'Meseji', 'Chat')),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    foregroundColor: MakambakoColors.ink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tx(isEn, 'Taarifa za safari zimeshirikiwa', 'Trip status shared'))),
                    );
                  },
                  icon: const Icon(Icons.share_rounded, size: 17),
                  label: Text(tx(isEn, 'Shiriki', 'Share')),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    foregroundColor: MakambakoColors.ink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // YOUR TRIP PIN CARD (Warm Beige)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFED7AA)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx(isEn, 'PIN YAKO YA SAFARI', 'YOUR TRIP PIN'),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF9A3412),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tx(isEn, 'Mpe dereva wako akifika', 'Tell your rider when they arrive'),
                        style: const TextStyle(fontSize: 12, color: Color(0xFF7C2D12)),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: driver.tripPin.map((digit) {
                    return Container(
                      margin: const EdgeInsets.only(left: 6),
                      width: 32,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFDBA74)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        digit,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: MakambakoColors.ink,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Trip summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${pickup.split(',').first} → ${destination.split(',').first}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '$vehicleName · Mobile money',
                    style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                  ),
                ],
              ),
              Text(
                'TSh ${totalFare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Interactive controls: "Cancel ride" and "Simulate Arrival"
          Row(
            children: [
              TextButton(
                onPressed: onCancel,
                child: Text(
                  tx(isEn, 'Ghairi safari', 'Cancel ride'),
                  style: const TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                key: const ValueKey('simulate-arrived-button'),
                onPressed: onSimulateArrived,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF145C45),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: Text(
                  tx(isEn, 'Fika Eneo (Maliza)', 'Simulate Arrival'),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
