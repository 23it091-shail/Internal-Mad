import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  final List<Map<String, dynamic>> _sessions = [];
  final List<Map<String, dynamic>> _attendances = [];

  List<Map<String, dynamic>> get sessions => _sessions.reversed.toList();
  List<Map<String, dynamic>> get attendances => _attendances.reversed.toList();

  void addSession(String id, {double? lat, double? lng, DateTime? validUntil, String? subject, String? teacherName}) {
    if (!_sessions.any((s) => s['id'] == id)) {
      _sessions.add({
        'id': id,
        'time': DateTime.now(),
        'lat': lat,
        'lng': lng,
        'validUntil': validUntil,
        'subject': subject,
        'teacherName': teacherName,
      });
      notifyListeners();
    }
  }

  void addAttendance(String sessionId, String studentId, {double? lat, double? lng, String? subject, String? teacherName}) {
    if (!_attendances.any((a) => a['sessionId'] == sessionId && a['studentId'] == studentId)) {
      _attendances.add({
        'sessionId': sessionId,
        'studentId': studentId,
        'time': DateTime.now(),
        'lat': lat,
        'lng': lng,
        'subject': subject,
        'teacherName': teacherName,
      });
      notifyListeners();
    }
  }
}
