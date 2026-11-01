import 'dart:convert';

/// Represents a confirmed booking, ride, food order, or service request
/// performed by the user in Makambako Yetu.
class BookingRecord {
  const BookingRecord({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.placeId,
    this.metadata = const {},
  });

  final String id;
  /// One of: 'stay', 'food', 'ride', 'service'
  final String type;
  final String title;
  final String subtitle;
  final int amount;
  /// One of: 'confirmed', 'inProgress', 'completed', 'cancelled'
  final String status;
  final DateTime createdAt;
  final String? placeId;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'subtitle': subtitle,
        'amount': amount,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'placeId': placeId,
        'metadata': metadata,
      };

  factory BookingRecord.fromJson(Map<String, dynamic> json) {
    return BookingRecord(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      amount: (json['amount'] as num).toInt(),
      status: json['status'] as String,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      placeId: json['placeId'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? const {},
    );
  }

  static String encodeList(List<BookingRecord> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());

  static List<BookingRecord> decodeList(String rawJson) {
    try {
      final decoded = jsonDecode(rawJson) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(BookingRecord.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
