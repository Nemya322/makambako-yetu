import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/activity/activity_service.dart';
import '../../core/activity/booking_record.dart';
import 'domain/ride_models.dart';
import 'presentation/stages/ride_arrived_stage.dart';
import 'presentation/stages/ride_arriving_stage.dart';
import 'presentation/stages/ride_choose_stage.dart';
import 'presentation/stages/ride_finding_stage.dart';
import 'presentation/widgets/ride_transit_map.dart';

export 'domain/ride_models.dart' show RideStage, VehicleOption, DriverDetails;

/// Industry-standard Ride Hailing coordinator managing the 4-stage transit lifecycle:
/// - Stage 1 (Choose): Route planning, vehicle type selection & payment method
/// - Stage 2 (Finding): Animated radar search & fare booster chips
/// - Stage 3 (Arriving): Driver assigned with 4-digit security PIN [4 7 2 9] & live tracking
/// - Stage 4 (Arrived): Arrival celebration, 5-star ratings, feedback chips & tip options
class RidePage extends StatefulWidget {
  const RidePage({
    required this.isEnglish,
    this.initialPickup,
    this.initialDestination,
    this.onBack,
    super.key,
  });

  final bool isEnglish;
  final String? initialPickup;
  final String? initialDestination;
  final VoidCallback? onBack;

  @override
  State<RidePage> createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> with SingleTickerProviderStateMixin {
  RideStage _stage = RideStage.choose;
  late String _pickup;
  late String _destination;
  int _selectedRideType = 0; // 0: Bike, 1: Tuk-tuk, 2: Car
  String _paymentMethod = 'Mobile money · 07•• ••• 421';
  int _extraFare = 0;
  int _selectedTip = 0;
  int _rating = 5;
  final Set<String> _selectedFeedback = {'Safe riding', 'On time'};
  Timer? _matchingTimer;
  late AnimationController _pulseController;

  List<VehicleOption> get _vehicles => VehicleOption.standardVehicles;

  VehicleOption get _currentVehicle => _vehicles[_selectedRideType];

  int get _currentPrice => _currentVehicle.basePrice + _extraFare;

  @override
  void initState() {
    super.initState();
    _pickup = widget.initialPickup ?? 'Main Market, Makambako';
    _destination = widget.initialDestination ?? 'Bus Stand, Makambako';
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void didUpdateWidget(covariant RidePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDestination != null &&
        widget.initialDestination != oldWidget.initialDestination) {
      _destination = widget.initialDestination!;
      _stage = RideStage.choose;
    }
  }

  @override
  void dispose() {
    _matchingTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _swapLocations() {
    setState(() {
      final temp = _pickup;
      _pickup = _destination;
      _destination = temp;
    });
  }

  void _requestRide() {
    setState(() {
      _extraFare = 0;
      _stage = RideStage.finding;
    });
    _pulseController.repeat();

    _matchingTimer?.cancel();
    _matchingTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted || _stage != RideStage.finding) return;
      _pulseController.stop();
      setState(() => _stage = RideStage.arriving);
    });
  }

  void _cancelRequest() {
    _matchingTimer?.cancel();
    _pulseController.stop();
    setState(() => _stage = RideStage.choose);
  }

  void _boostFare(int amount) {
    setState(() => _extraFare += amount);
  }

  void _toggleFeedback(String tag) {
    setState(() {
      if (_selectedFeedback.contains(tag)) {
        _selectedFeedback.remove(tag);
      } else {
        _selectedFeedback.add(tag);
      }
    });
  }

  void _handleBackPress() {
    if (_stage != RideStage.choose) {
      _cancelRequest();
    } else {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        widget.onBack?.call();
      }
    }
  }

  void _finishRide() {
    final vehicleTitle = widget.isEnglish ? _currentVehicle.titleEn : _currentVehicle.titleSw;
    final id = 'RD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    ActivityService().recordBooking(
      BookingRecord(
        id: id,
        title: '$vehicleTitle: $_destination',
        subtitle: 'Kutoka: $_pickup',
        type: 'ride',
        status: 'Imekamilika',
        amount: _currentPrice + _selectedTip,
        createdAt: DateTime.now(),
        metadata: {
          'pickup': _pickup,
          'destination': _destination,
          'vehicle': vehicleTitle,
          'rating': _rating,
          'tip': _selectedTip,
        },
      ),
    );
    setState(() {
      _stage = RideStage.choose;
      _extraFare = 0;
      _selectedTip = 0;
      _rating = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEn = widget.isEnglish;

    return PopScope(
      canPop: _stage == RideStage.choose && Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackPress();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE4EDE5),
        body: Stack(
          children: [
            // Modular Animated Map Background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.sizeOf(context).height * 0.45,
              child: RideTransitMap(
                stage: _stage,
                isEnglish: isEn,
                pulseAnimation: _pulseController,
                pickup: _pickup,
                destination: _destination,
                onBack: _handleBackPress,
              ),
            ),

            // Dynamic Lifecycle Stage Panel
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: MediaQuery.sizeOf(context).height * 0.38,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.08),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: _buildCurrentStage(isEn),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStage(bool isEn) {
    switch (_stage) {
      case RideStage.choose:
        return RideChooseStage(
          key: const ValueKey('stage-choose-view'),
          isEnglish: isEn,
          pickup: _pickup,
          destination: _destination,
          selectedVehicleIndex: _selectedRideType,
          paymentMethod: _paymentMethod,
          onSwapLocations: _swapLocations,
          onSelectPickup: (loc) => setState(() => _pickup = loc),
          onSelectDestination: (loc) => setState(() => _destination = loc),
          onSelectVehicle: (idx) => setState(() => _selectedRideType = idx),
          onSelectPaymentMethod: (m) => setState(() => _paymentMethod = m),
          onRequestRide: _requestRide,
        );
      case RideStage.finding:
        return RideFindingStage(
          key: const ValueKey('stage-finding-view'),
          isEnglish: isEn,
          pickup: _pickup,
          destination: _destination,
          vehicleName: widget.isEnglish ? _currentVehicle.titleEn : _currentVehicle.titleSw,
          totalFare: _currentPrice,
          extraFare: _extraFare,
          onBoostFare: _boostFare,
          onCancel: _cancelRequest,
        );
      case RideStage.arriving:
        return RideArrivingStage(
          key: const ValueKey('stage-arriving-view'),
          isEnglish: isEn,
          pickup: _pickup,
          destination: _destination,
          vehicleName: widget.isEnglish ? _currentVehicle.titleEn : _currentVehicle.titleSw,
          totalFare: _currentPrice,
          onCancel: _cancelRequest,
          onSimulateArrived: () => setState(() => _stage = RideStage.arrived),
        );
      case RideStage.arrived:
        return RideArrivedStage(
          key: const ValueKey('stage-arrived-view'),
          isEnglish: isEn,
          destination: _destination,
          totalFare: _currentPrice,
          rating: _rating,
          selectedFeedback: _selectedFeedback,
          selectedTip: _selectedTip,
          onRatingChanged: (r) => setState(() => _rating = r),
          onToggleFeedback: _toggleFeedback,
          onSelectTip: (tip) => setState(() => _selectedTip = tip),
          onFinish: _finishRide,
        );
    }
  }
}
