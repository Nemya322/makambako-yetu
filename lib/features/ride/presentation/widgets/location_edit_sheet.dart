import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../../domain/ride_models.dart';

/// Modal bottom sheet for changing pickup or drop-off location in Makambako.
class LocationEditSheet extends StatefulWidget {
  const LocationEditSheet({
    required this.isEnglish,
    required this.isPickup,
    required this.currentLocation,
    required this.onLocationSelected,
    super.key,
  });

  final bool isEnglish;
  final bool isPickup;
  final String currentLocation;
  final ValueChanged<String> onLocationSelected;

  static void show({
    required BuildContext context,
    required bool isEnglish,
    required bool isPickup,
    required String currentLocation,
    required ValueChanged<String> onLocationSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => LocationEditSheet(
        isEnglish: isEnglish,
        isPickup: isPickup,
        currentLocation: currentLocation,
        onLocationSelected: (loc) {
          onLocationSelected(loc);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  State<LocationEditSheet> createState() => _LocationEditSheetState();
}

class _LocationEditSheetState extends State<LocationEditSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentLocation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isPickup
                ? tx(widget.isEnglish, 'Badili Eneo la Kupandia', 'Edit Pickup Location')
                : tx(widget.isEnglish, 'Badili Eneo la Kushukia', 'Edit Drop-off Location'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                widget.isPickup ? Icons.my_location_rounded : Icons.location_on_rounded,
                color: widget.isPickup ? const Color(0xFF1BAC4B) : const Color(0xFFDC2626),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.check_circle_rounded, color: MakambakoColors.forest),
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    widget.onLocationSelected(text);
                  }
                },
              ),
              hintText: tx(widget.isEnglish, 'Tafuta mtaa au eneo...', 'Search street or spot...'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            onSubmitted: (val) {
              if (val.trim().isNotEmpty) {
                widget.onLocationSelected(val.trim());
              }
            },
          ),
          const SizedBox(height: 16),
          Text(
            tx(widget.isEnglish, 'Maeneo Maarufu Makambako', 'Popular Spots in Makambako'),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: MakambakoColors.muted),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 220),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: MakambakoTransitLocations.popularSpots.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
              itemBuilder: (ctx, index) {
                final spot = MakambakoTransitLocations.popularSpots[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.history_rounded, size: 18, color: MakambakoColors.muted),
                  title: Text(
                    spot,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  onTap: () => widget.onLocationSelected(spot),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
