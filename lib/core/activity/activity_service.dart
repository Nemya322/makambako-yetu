import 'package:shared_preferences/shared_preferences.dart';
import 'booking_record.dart';

/// Manages and persists user activity across all modules:
/// - Stays (Guest House / Lodge reservations)
/// - Food Delivery orders
/// - Local Pro bookings (Fundi, plumbing, electrical)
/// - Ride hauls (Boda, Bajaj, Car)
class ActivityService {
  const ActivityService();

  static const String keyBookings = 'mk_yetu.user_bookings';

  /// Standard default seed bookings linking to canonical Makambako records
  /// so new users see an active, coherent experience out of the box.
  static final List<BookingRecord> defaultSeedBookings = [
    BookingRecord(
      id: 'SG-48213',
      type: 'stay',
      title: 'Sunrise Guest House',
      subtitle: 'Double room · 14-16 Oct · LALA15',
      amount: 21250,
      status: 'confirmed',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      placeId: 'mko-sunrise-guest-house',
      metadata: {
        'guestHouseName': 'Sunrise Guest House',
        'roomTitle': 'Chumba cha Wawili (Double room)',
        'nights': 2,
        'checkInDay': 14,
        'checkOutDay': 16,
        'promoCode': 'LALA15',
        'isPromoApplied': true,
        'promoDiscount': 3750,
        'paidNow': 6375,
        'payAtCheckIn': 14875,
      },
    ),
    BookingRecord(
      id: 'MY-2041',
      type: 'food',
      title: "Neema's Kitchen",
      subtitle: 'Wali na Kuku Choma + Pilau · Stand Kuu',
      amount: 14500,
      status: 'inProgress',
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      placeId: 'mko-neemas-kitchen',
      metadata: {
        'restaurantName': "Neema's Kitchen",
        'itemCount': 2,
        'driverName': 'Hassan K.',
        'driverPlate': 'T 482 DKF',
        'securityPin': '5 1 8',
      },
    ),
  ];

  /// Loads all saved bookings, seeding defaults on first launch.
  Future<List<BookingRecord>> getBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(keyBookings);
      if (raw == null || raw.trim().isEmpty) {
        // First run: seed with standard sample records
        await saveBookings(defaultSeedBookings);
        return List.from(defaultSeedBookings);
      }
      final list = BookingRecord.decodeList(raw);
      return list;
    } catch (_) {
      return List.from(defaultSeedBookings);
    }
  }

  /// Saves the full list of bookings.
  Future<void> saveBookings(List<BookingRecord> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keyBookings, BookingRecord.encodeList(items));
    } catch (_) {
      // Best-effort persistence.
    }
  }

  /// Prepends a new booking record to the user history and persists it.
  Future<void> recordBooking(BookingRecord newRecord) async {
    final existing = await getBookings();
    // Prevent duplicate IDs
    final updated = [
      newRecord,
      ...existing.where((item) => item.id != newRecord.id),
    ];
    await saveBookings(updated);
  }

  /// Clears all user booking history.
  Future<void> clearBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(keyBookings);
    } catch (_) {}
  }
}
