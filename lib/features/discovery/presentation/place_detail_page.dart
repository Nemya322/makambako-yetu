import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/l10n/app_text.dart';
import '../../../core/theme/makambako_theme.dart';
import '../../food/food_delivery_page.dart';
import '../../ride/ride_page.dart';
import '../../services/local_pro_booking_page.dart';
import '../../stays/guest_house_booking_page.dart';
import '../domain/place.dart';
import 'place_verification_label.dart';

/// Full-screen canonical place record with actionable communication channels (Call, WhatsApp),
/// interactive booking & delivery workflows, operating hours, and persistent bookmarking.
class PlaceDetailPage extends StatefulWidget {
  const PlaceDetailPage({
    required this.place,
    required this.isEnglish,
    this.isSaved = false,
    this.onToggleSave,
    this.onRideThere,
    super.key,
  });

  final Place place;
  final bool isEnglish;
  final bool isSaved;
  final VoidCallback? onToggleSave;
  final ValueChanged<String>? onRideThere;

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  late bool _saved;

  @override
  void initState() {
    super.initState();
    _saved = widget.isSaved;
  }

  void _handleToggleSave() {
    setState(() => _saved = !_saved);
    widget.onToggleSave?.call();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _saved
                ? tx(widget.isEnglish, 'Imehifadhiwa kwenye orodha yako', 'Saved to your list')
                : tx(widget.isEnglish, 'Imeondolewa kwenye orodha', 'Removed from your list'),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _handleContactAction({required String type, required String value}) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            type == 'phone'
                ? tx(
                    widget.isEnglish,
                    'Namba ya simu: $value (Imenakiliwa)',
                    'Phone number: $value (Copied to clipboard)',
                  )
                : tx(
                    widget.isEnglish,
                    'Mawasiliano ya WhatsApp: $value (Imenakiliwa)',
                    'WhatsApp contact: $value (Copied to clipboard)',
                  ),
          ),
          action: SnackBarAction(
            label: tx(widget.isEnglish, 'Sawa', 'OK'),
            textColor: const Color(0xFFE8F3C8),
            onPressed: () {},
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _handleRideThere() {
    final dest = widget.place.name;
    if (widget.onRideThere != null) {
      Navigator.of(context).pop();
      widget.onRideThere!(dest);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => RidePage(
            isEnglish: widget.isEnglish,
            initialDestination: dest,
          ),
        ),
      );
    }
  }

  void _handleBookRoom() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => GuestHouseBookingPage(
          isEnglish: widget.isEnglish,
          guestHouseName: widget.place.name,
          onRideThere: (dest) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            widget.onRideThere?.call(dest);
          },
        ),
      ),
    );
  }

  void _handleBookPro() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => LocalProBookingPage(
          isEnglish: widget.isEnglish,
        ),
      ),
    );
  }

  void _handleOrderFood() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => FoodDeliveryPage(
          isEnglish: widget.isEnglish,
          initialRestaurantId: widget.place.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final isEnglish = widget.isEnglish;

    return Scaffold(
      backgroundColor: MakambakoColors.page,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: MakambakoColors.ink,
        elevation: 0,
        title: Text(
          tx(isEnglish, 'Taarifa za eneo', 'Place details'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: _saved
                ? tx(isEnglish, 'Ondoa kwenye zilizohifadhiwa', 'Remove bookmark')
                : tx(isEnglish, 'Hifadhi eneo hili', 'Save place'),
            icon: Icon(
              _saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _saved ? MakambakoColors.forest : MakambakoColors.ink,
            ),
            onPressed: _handleToggleSave,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        place.name,
                        style: const TextStyle(
                          color: MakambakoColors.ink,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                    ),
                    if (place.rating != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: Color(0xFFD97706)),
                            const SizedBox(width: 4),
                            Text(
                              place.rating!.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Color(0xFF92400E),
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF3E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        localizedPlaceCategory(place, isEnglish),
                        style: const TextStyle(
                          color: MakambakoColors.forest,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_rounded, size: 12, color: MakambakoColors.muted),
                          const SizedBox(width: 3),
                          Text(
                            place.location.area.name,
                            style: const TextStyle(
                              color: MakambakoColors.ink,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (place.reviewCount != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 2),
                        child: Text(
                          '(${place.reviewCount} ${tx(isEnglish, 'maoni', 'reviews')})',
                          style: const TextStyle(color: MakambakoColors.muted, fontSize: 12),
                        ),
                      ),
                  ],
                ),

                if (place.isDevelopmentFixture) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Text(
                      tx(
                        isEnglish,
                        'REKODI YA MAENDELEZO TU — SI BIASHARA ILIYOTHIBITISHWA',
                        'DEVELOPMENT RECORD ONLY — NOT A VERIFIED BUSINESS',
                      ),
                      style: const TextStyle(
                        color: Color(0xFF9A5A00),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Dynamic Interactive Workflow Feature Card
          if (place.categoryId == 'accommodation' ||
              place.name.toLowerCase().contains('guest') ||
              place.name.toLowerCase().contains('hotel') ||
              place.name.toLowerCase().contains('lodge')) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F2B1D), Color(0xFF1B4D35)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F2B1D).withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.hotel_rounded, color: Color(0xFFE8F3C8), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx(isEnglish, 'Weka Chumba Mtandaoni', 'Book Room Online'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              tx(isEnglish, 'TSh 25,000 / usiku · Uthibitisho wa papo hapo', 'TSh 25,000 / night · Instant confirmation'),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleBookRoom,
                      icon: const Icon(Icons.calendar_month_rounded, size: 18),
                      label: Text(tx(isEnglish, 'Chagua Tarehe & Weka Chumba', 'Select Dates & Book Room')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8F3C8),
                        foregroundColor: const Color(0xFF0F2B1D),
                        elevation: 0,
                        minimumSize: const Size(0, 46),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ] else if (place.categoryId == 'services' ||
              place.entity.type == PlaceEntityType.serviceProvider ||
              place.name.toLowerCase().contains('fundi') ||
              place.name.toLowerCase().contains('plumber')) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A5F), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A5F).withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.handyman_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx(isEnglish, 'Agiza Fundi wa Nyumbani', 'Book a Local Pro'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              tx(isEnglish, 'Mabomba, uvujaji & ukarabati · Kuanzia TSh 10,000', 'Leaks, pipes & repairs · From TSh 10,000'),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleBookPro,
                      icon: const Icon(Icons.build_circle_rounded, size: 18),
                      label: Text(tx(isEnglish, 'Panga Muda & Agiza Fundi', 'Choose Time & Book Pro')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1E3A5F),
                        elevation: 0,
                        minimumSize: const Size(0, 46),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ] else if (place.categoryId == 'food' ||
              place.id == 'mko-neemas-kitchen' ||
              place.name.toLowerCase().contains('kitchen') ||
              place.name.toLowerCase().contains('mgahawa')) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF831843), Color(0xFFBE185D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF831843).withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx(isEnglish, 'Agiza Chakula cha Safari', 'Order Food Delivery'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              tx(isEnglish, 'Wali, chips, kuku & vinywaji · Dak 20-30', 'Rice, chips, chicken & drinks · 20-30 min'),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleOrderFood,
                      icon: const Icon(Icons.restaurant_menu_rounded, size: 18),
                      label: Text(tx(isEnglish, 'Fungua Menyu & Agiza', 'Open Menu & Order')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF831843),
                        elevation: 0,
                        minimumSize: const Size(0, 46),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Primary Ride Hailing Action Button (Seamless transport workflow)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _handleRideThere,
              icon: const Icon(Icons.two_wheeler_rounded, size: 20, color: Color(0xFFE8F3C8)),
              label: Text(
                tx(isEnglish, 'Pata Usafiri Kufika Hapa (Bodaboda / Bajaji)', 'Get a Ride Here (Bike / Tuk-tuk)'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3B2B),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Secondary Quick Action Buttons (Call, WhatsApp)
          Row(
            children: [
              if (place.phone != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleContactAction(type: 'phone', value: place.phone!),
                    icon: const Icon(Icons.phone_rounded, size: 18),
                    label: Text(tx(isEnglish, 'Piga Simu', 'Call')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: MakambakoColors.ink,
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      minimumSize: const Size(0, 46),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                ),
              if (place.phone != null && place.whatsapp != null) const SizedBox(width: 10),
              if (place.whatsapp != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleContactAction(type: 'whatsapp', value: place.whatsapp!),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Color(0xFF25D366)),
                    label: const Text('WhatsApp'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: MakambakoColors.ink,
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      minimumSize: const Size(0, 46),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // Details & Hours Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx(isEnglish, 'Kuhusu eneo hili', 'About this place'),
                  style: const TextStyle(
                    color: MakambakoColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  place.description ?? tx(isEnglish, 'Hakuna maelezo ya ziada.', 'No additional description.'),
                  style: const TextStyle(
                    color: MakambakoColors.ink,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                if (place.openingHours != null) ...[
                  const Divider(height: 26),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.access_time_rounded, size: 20, color: MakambakoColors.forest),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx(isEnglish, 'Saa za kazi', 'Operating hours'),
                              style: const TextStyle(
                                color: MakambakoColors.muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              place.openingHours!,
                              style: const TextStyle(
                                color: MakambakoColors.ink,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Location & Coordinates Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx(isEnglish, 'Mahali & Anwani', 'Location & Address'),
                  style: const TextStyle(
                    color: MakambakoColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1E6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.place_rounded, color: MakambakoColors.forest, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.location.displayName ?? place.location.area.name,
                            style: const TextStyle(
                              color: MakambakoColors.ink,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          if (place.location.address case final address?) ...[
                            const SizedBox(height: 3),
                            Text(
                              address,
                              style: const TextStyle(color: MakambakoColors.muted, fontSize: 13),
                            ),
                          ],
                          if (place.location.coordinates case final coords?) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${coords.latitude.toStringAsFixed(4)}° S, ${coords.longitude.toStringAsFixed(4)}° E (Makambako)',
                                style: const TextStyle(
                                  color: MakambakoColors.muted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Verification & Provenance Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAF8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${tx(isEnglish, 'Hali', 'Status')}: '
                  '${placeVerificationLabel(place.verificationStatus, isEnglish)}',
                  style: const TextStyle(
                    color: MakambakoColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${tx(isEnglish, 'Chanzo', 'Source')}: '
                  '${place.provenance.label}',
                  style: const TextStyle(
                    color: MakambakoColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
