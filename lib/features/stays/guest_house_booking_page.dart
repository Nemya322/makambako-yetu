import 'package:flutter/material.dart';

import '../../core/activity/activity_service.dart';
import '../../core/activity/booking_record.dart';
import '../../core/l10n/app_text.dart';
import 'domain/stay_models.dart';
import 'presentation/screens/stay_booking_screen.dart';
import 'presentation/screens/stay_confirmation_screen.dart';

export 'domain/stay_models.dart' show RoomOption;

/// Interactive Lodging Booking coordinator matching Pages 8-9 of the activity workflow.
/// Seamlessly manages:
/// - Step 1: Date & Room Choice with interactive promo code (LALA15)
/// - Step 2: Confirmed Reservation Screen (SG-48213) with Ride There CTA
class GuestHouseBookingPage extends StatefulWidget {
  const GuestHouseBookingPage({
    required this.isEnglish,
    this.guestHouseName = 'Sunrise Guest House',
    this.initialPromoCode,
    this.onRideThere,
    this.onViewOnMap,
    this.onBack,
    super.key,
  });

  final bool isEnglish;
  final String guestHouseName;
  final String? initialPromoCode;
  final ValueChanged<String>? onRideThere;
  final ValueChanged<String>? onViewOnMap;
  final VoidCallback? onBack;

  @override
  State<GuestHouseBookingPage> createState() => _GuestHouseBookingPageState();
}

class _GuestHouseBookingPageState extends State<GuestHouseBookingPage> {
  bool _isBooked = false;
  int _checkInDay = 14;
  int _checkOutDay = 16;
  int _selectedRoomIndex = 0; // 0: Double room, 1: Family room
  String? _appliedPromoCode;
  bool _isPromoApplied = false;
  final TextEditingController _promoInputController = TextEditingController();

  List<RoomOption> get _rooms => RoomOption.standardRooms;

  @override
  void initState() {
    super.initState();
    if (widget.initialPromoCode != null && widget.initialPromoCode!.trim().isNotEmpty) {
      _appliedPromoCode = widget.initialPromoCode!.trim().toUpperCase();
      _isPromoApplied = true;
      _promoInputController.text = _appliedPromoCode!;
    }
  }

  @override
  void dispose() {
    _promoInputController.dispose();
    super.dispose();
  }

  int get _nights => (_checkOutDay - _checkInDay).clamp(1, 14);

  int get _basePrice {
    final pricePerNight = _rooms[_selectedRoomIndex].pricePerNight;
    return pricePerNight * _nights;
  }

  int get _promoDiscount {
    if (!_isPromoApplied) return 0;
    return (_basePrice * 0.15).round();
  }

  int get _totalPrice => (_basePrice - _promoDiscount).clamp(0, 9999999);

  int get _paidNow => (_totalPrice * 0.3).round();
  int get _payAtCheckIn => _totalPrice - _paidNow;

  void _applyPromo(String code) {
    setState(() {
      _appliedPromoCode = code;
      _isPromoApplied = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tx(
            widget.isEnglish,
            'Kuponi ya $code imetumika! Punguzo la 15%.',
            'Promo code $code applied! 15% discount.',
          ),
        ),
        backgroundColor: const Color(0xFF145C45),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removePromo() {
    setState(() {
      _isPromoApplied = false;
      _appliedPromoCode = null;
      _promoInputController.clear();
    });
  }

  void _confirmBooking() {
    setState(() => _isBooked = true);
    final room = _rooms[_selectedRoomIndex];
    const activityService = ActivityService();
    activityService.recordBooking(
      BookingRecord(
        id: 'SG-${(DateTime.now().millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}',
        type: 'stay',
        title: widget.guestHouseName,
        subtitle: '${widget.isEnglish ? room.titleEn : room.titleSw} · $_checkInDay-$_checkOutDay Oct',
        amount: _totalPrice,
        status: 'confirmed',
        createdAt: DateTime.now(),
        placeId: widget.guestHouseName.toLowerCase().contains('midland')
            ? 'mko-midland-hotel'
            : 'mko-sunrise-guest-house',
        metadata: {
          'guestHouseName': widget.guestHouseName,
          'roomTitle': room.titleSw,
          'nights': _nights,
          'checkInDay': _checkInDay,
          'checkOutDay': _checkOutDay,
          'promoCode': _appliedPromoCode,
          'isPromoApplied': _isPromoApplied,
          'promoDiscount': _promoDiscount,
          'paidNow': _paidNow,
          'payAtCheckIn': _payAtCheckIn,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEn = widget.isEnglish;

    return PopScope(
      canPop: !_isBooked,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isBooked) {
          if (widget.onBack != null) {
            widget.onBack!();
          } else {
            Navigator.maybePop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isBooked
              ? StayConfirmationScreen(
                  isEnglish: isEn,
                  guestHouseName: widget.guestHouseName,
                  room: _rooms[_selectedRoomIndex],
                  checkInDay: _checkInDay,
                  checkOutDay: _checkOutDay,
                  totalPrice: _totalPrice,
                  paidNow: _paidNow,
                  payAtCheckIn: _payAtCheckIn,
                  isPromoApplied: _isPromoApplied,
                  appliedPromoCode: _appliedPromoCode,
                  promoDiscount: _promoDiscount,
                  onRideThere: widget.onRideThere,
                  onViewOnMap: widget.onViewOnMap,
                  onDone: () {
                    if (widget.onBack != null) {
                      widget.onBack!();
                    } else {
                      Navigator.maybePop(context);
                    }
                  },
                )
              : StayBookingScreen(
                  isEnglish: isEn,
                  guestHouseName: widget.guestHouseName,
                  rooms: _rooms,
                  selectedRoomIndex: _selectedRoomIndex,
                  checkInDay: _checkInDay,
                  checkOutDay: _checkOutDay,
                  nights: _nights,
                  basePrice: _basePrice,
                  promoDiscount: _promoDiscount,
                  totalPrice: _totalPrice,
                  paidNow: _paidNow,
                  payAtCheckIn: _payAtCheckIn,
                  isPromoApplied: _isPromoApplied,
                  appliedPromoCode: _appliedPromoCode,
                  promoInputController: _promoInputController,
                  onSelectRoom: (idx) => setState(() => _selectedRoomIndex = idx),
                  onSelectDays: (inDay, outDay) {
                    setState(() {
                      _checkInDay = inDay;
                      _checkOutDay = outDay;
                    });
                  },
                  onApplyPromo: _applyPromo,
                  onRemovePromo: _removePromo,
                  onConfirmBooking: _confirmBooking,
                  onBack: widget.onBack,
                ),
        ),
      ),
    );
  }
}
