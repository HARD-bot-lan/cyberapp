import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/breach.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all breaches
  Future<List<Breach>> fetchBreaches() async {
    try {
      final snapshot = await _firestore.collection('filtered_messages').get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        try {
          return Breach.fromFirestore(doc);
        } catch (e) {
          // Skip invalid entries
          rethrow;
        }
      }).whereType<Breach>().toList();
    } catch (e) {
      throw Exception('Error fetching breaches: $e');
    }
  }

  /// Fetch breaches by target
  Future<List<Breach>> fetchBreachesByTarget(String target) async {
    try {
      final snapshot = await _firestore
          .collection('filtered_messages')
          .where('target', isEqualTo: target)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        try {
          return Breach.fromFirestore(doc);
        } catch (e) {
          rethrow;
        }
      }).whereType<Breach>().toList();
    } catch (e) {
      throw Exception('Error fetching breaches by target: $e');
    }
  }

    /// Fetch breaches by usefulness
  Future<List<Breach>> fetchBreachesByUsefulness(String usefulness) async {
    try {
      final snapshot = await _firestore
          .collection('filtered_messages')
          .where('usefulness', isEqualTo: usefulness)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        try {
          return Breach.fromFirestore(doc);
        } catch (e) {
          rethrow;
        }
      }).whereType<Breach>().toList();
    } catch (e) {
      throw Exception('Error fetching breaches by usefulness: $e');
    }
  }

  /// Search articles by query (dummy implementation)
  
}