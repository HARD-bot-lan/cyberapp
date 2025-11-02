import 'package:cloud_firestore/cloud_firestore.dart';

class Breach {
  final String id;
  final DateTime date;
  final String description;
  final String target;
  final bool usefulness; // fixed type

  Breach({
    required this.id,
    required this.date,
    required this.description,
    required this.target,
    required this.usefulness,
  });

  factory Breach.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Handle date stored as string or Timestamp
    DateTime parsedDate;
    if (data['date'] is Timestamp) {
      parsedDate = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is String) {
      // Example format: "August 15, 2025 at 07:17:16 PM UTC+0000"
      try {
        parsedDate = DateTime.parse(
            DateTime.tryParse(data['date'])?.toIso8601String() ?? DateTime.now().toIso8601String());
      } catch (_) {
        parsedDate = DateTime.now();
      }
    } else {
      parsedDate = DateTime.now();
    }

    return Breach(
      id: doc.id,
      date: parsedDate,
      description: data['description'] as String? ?? '',
      target: data['target'] as String? ?? '',
      usefulness: data['usefulness'] is bool ? data['usefulness'] : false,
    );
  }
}
