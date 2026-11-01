import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../../domain/ride_models.dart';
import '../widgets/location_edit_sheet.dart';
import '../widgets/payment_method_sheet.dart';

/// Stage 1: Choose Pickup, Drop-off, Vehicle type, and Payment Method.
class RideChooseStage extends StatelessWidget {
  const RideChooseStage({
    required this.isEnglish,
    required this.pickup,
    required this.destination,
    required this.selectedVehicleIndex,
    required this.paymentMethod,
    required this.onSwapLocations,
    required this.onSelectPickup,
    required this.onSelectDestination,
    required this.onSelectVehicle,
    required this.onSelectPaymentMethod,
    required this.onRequestRide,
    super.key,
  });

  final bool isEnglish;
  final String pickup;
  final String destination;
  final int selectedVehicleIndex;
  final String paymentMethod;
  final VoidCallback onSwapLocations;
  final ValueChanged<String> onSelectPickup;
  final ValueChanged<String> onSelectDestination;
  final ValueChanged<int> onSelectVehicle;
  final ValueChanged<String> onSelectPaymentMethod;
  final VoidCallback onRequestRide;

  List<VehicleOption> get vehicles => VehicleOption.standardVehicles;

  VehicleOption get currentVehicle => vehicles[selectedVehicleIndex];

  String get currentVehicleName =>
      tx(isEnglish, currentVehicle.titleSw, currentVehicle.titleEn);

  int get currentPrice => currentVehicle.basePrice;

  @override
  Widget build(BuildContext context) {
    final isEn = isEnglish;

    return Container(
      key: const ValueKey('stage-choose'),
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
          // Drag handle
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

          // PICKUP & DROP-OFF Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF9),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5EDE7)),
            ),
            child: Column(
              children: [
                // Pickup row
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1BAC4B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx(isEn, 'ENEO LA KUPANDIA', 'PICKUP'),
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: MakambakoColors.muted,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            pickup,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: MakambakoColors.ink,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => LocationEditSheet.show(
                        context: context,
                        isEnglish: isEn,
                        isPickup: true,
                        currentLocation: pickup,
                        onLocationSelected: onSelectPickup,
                      ),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        foregroundColor: MakambakoColors.forest,
                      ),
                      child: Text(
                        tx(isEn, 'Badili', 'Edit'),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 18, color: Color(0xFFE5EDE7)),

                // Drop-off row with Swap Button
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx(isEn, 'UNAPOKWENDA', 'DROP-OFF'),
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: MakambakoColors.muted,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            destination,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: MakambakoColors.ink,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.swap_vert_rounded, color: MakambakoColors.forest, size: 20),
                      onPressed: onSwapLocations,
                      tooltip: tx(isEn, 'Badilisha pande', 'Swap pickup and drop-off'),
                    ),
                    TextButton(
                      onPressed: () => LocationEditSheet.show(
                        context: context,
                        isEnglish: isEn,
                        isPickup: false,
                        currentLocation: destination,
                        onLocationSelected: onSelectDestination,
                      ),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        foregroundColor: MakambakoColors.forest,
                      ),
                      child: Text(
                        tx(isEn, 'Badili', 'Edit'),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Vehicle Type List
          Text(
            tx(isEn, 'Chagua Aina ya Usafiri', 'Choose Ride Type'),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),

          ...List.generate(vehicles.length, (index) {
            final v = vehicles[index];
            final isSelected = selectedVehicleIndex == index;
            final title = tx(isEn, v.titleSw, v.titleEn);
            final tag = tx(isEn, v.tagSw, v.tagEn);
            final time = tx(isEn, v.timeSw, v.timeEn);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
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
                  onTap: () => onSelectVehicle(index),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE5F0E8) : const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            v.icon,
                            color: isSelected ? const Color(0xFF145C45) : MakambakoColors.ink,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '· $time',
                                    style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tag,
                                style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'TSh ${v.basePrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: isSelected ? const Color(0xFF145C45) : MakambakoColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 10),

          // Payment Selector Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5EDE7)),
            ),
            child: Row(
              children: [
                const Icon(Icons.smartphone_rounded, color: MakambakoColors.forest, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    paymentMethod,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: MakambakoColors.ink,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () => PaymentMethodSheet.show(
                    context: context,
                    isEnglish: isEn,
                    currentPaymentMethod: paymentMethod,
                    onSelectPaymentMethod: onSelectPaymentMethod,
                  ),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    foregroundColor: MakambakoColors.forest,
                  ),
                  child: Text(
                    tx(isEn, 'Badili', 'Change'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Primary Request Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              key: const ValueKey('request-ride-button'),
              onPressed: onRequestRide,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF145C45),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27),
                ),
                elevation: 1,
              ),
              child: Text(
                tx(
                  isEn,
                  'Omba $currentVehicleName · TSh ${currentPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                  'Request $currentVehicleName · TSh ${currentPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
