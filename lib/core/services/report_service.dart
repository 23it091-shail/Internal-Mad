import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:csv/csv.dart';

class ReportService {
  static void exportAttendanceToCSV(List<Map<String, dynamic>> attendanceData) {
    if (attendanceData.isEmpty) return;

    List<List<dynamic>> rows = [];
    
    // Header
    rows.add([
      "Session ID",
      "Student ID",
      "Subject",
      "Teacher",
      "Timestamp",
      "Latitude",
      "Longitude"
    ]);

    // Data
    for (var record in attendanceData) {
      rows.add([
        record['sessionId'],
        record['studentId'],
        record['subject'] ?? 'N/A',
        record['teacherName'] ?? 'N/A',
        record['time']?.toString() ?? 'N/A',
        record['lat'] ?? 0.0,
        record['lng'] ?? 0.0,
      ]);
    }

    String csvContent = const ListToCsvConverter().convert(rows);
    
    // Download logic for Web
    final bytes = utf8.encode(csvContent);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "attendance_report_${DateTime.now().millisecondsSinceEpoch}.csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
