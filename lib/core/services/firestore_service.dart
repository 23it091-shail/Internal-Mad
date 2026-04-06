import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Roles
  Future<void> createUserProfile(String uid, String email, String role) async {
    await _db.collection('users').doc(uid).set({
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> getUserRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['role'] ?? 'student';
  }

  // Sessions
  Future<void> createSession(Map<String, dynamic> sessionData) async {
    await _db.collection('sessions').doc(sessionData['id']).set({
      ...sessionData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Attendance
  Future<void> markAttendance(Map<String, dynamic> attendanceData) async {
    final String id = '${attendanceData['sessionId']}_${attendanceData['studentId']}';
    await _db.collection('attendance').doc(id).set({
      ...attendanceData,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Real-time listeners
  Stream<List<Map<String, dynamic>>> getSessions() {
    return _db.collection('sessions').orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getAttendanceForStudent(String studentId) {
    return _db.collection('attendance')
        .where('studentId', isEqualTo: studentId)
        .orderBy('timestamp', descending: true)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
