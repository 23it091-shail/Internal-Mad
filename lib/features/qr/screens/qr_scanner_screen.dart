import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_state.dart';
import '../../../core/services/firestore_service.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isProcessing = false;

  Future<void> _handleScan(BarcodeCapture capture) async {
    if (isProcessing) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? rawValue = barcodes.first.rawValue;
    if (rawValue != null) {
      if (!mounted) return;
      setState(() => isProcessing = true);
      
      try {
        final decodedMap = jsonDecode(rawValue) as Map<String, dynamic>;
        
        final sessionEndTime = DateTime.parse(decodedMap['validUntil'] as String);
        if (DateTime.now().isAfter(sessionEndTime)) {
          _showResultDialog('Time Error', 'This QR code session has expired.');
          setState(() => isProcessing = false);
          return;
        }

        // Metadata extraction
        final String subject = decodedMap['subject'] ?? 'Unknown Session';
        final String teacher = decodedMap['teacherName'] ?? 'Unknown Teacher';

        // Validate location
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          _showResultDialog('Location Error', 'Location services are disabled.');
          setState(() => isProcessing = false);
          return;
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            _showResultDialog('Permission Denied', 'Location permissions are denied.');
            setState(() => isProcessing = false);
            return;
          }
        }

        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        
        double instructorLat = (decodedMap['lat'] as num).toDouble();
        double instructorLng = (decodedMap['lng'] as num).toDouble();
        
        double distanceInMeters = Geolocator.distanceBetween(
          position.latitude, position.longitude,
          instructorLat, instructorLng
        );
        
        if (distanceInMeters > 500) { 
          _showResultDialog('Geofence Error', 'You are too far from the classroom! (${distanceInMeters.toStringAsFixed(2)} m away)');
          setState(() => isProcessing = false);
        } else {
          // Record Live Attendance to State
          if (mounted) {
            final auth = Provider.of<AuthService>(context, listen: false);
            final studentId = auth.user?.uid ?? 'unknown_student';

            Provider.of<AppState>(context, listen: false).addAttendance(
              decodedMap['sessionId'],
              studentId,
              lat: position.latitude,
              lng: position.longitude,
              subject: subject,
              teacherName: teacher,
            );

            await FirestoreService().markAttendance({
              'sessionId': decodedMap['sessionId'],
              'studentId': studentId,
              'lat': position.latitude,
              'lng': position.longitude,
              'subject': subject,
              'teacherName': teacher,
            });
          }

            });
          }

          if (mounted) {
            setState(() => isProcessing = false);
            context.push('/success');
          }
        }
        
      } catch (e) {
        setState(() => isProcessing = false);
        _showResultDialog('Format Error', 'Validation failed: \n${e.toString()}');
      }
    }
  }

  void _showResultDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: const Text('OK'),
          )
        ],
      ),
    ).then((_) {
       if (mounted) {
         setState(() => isProcessing = false);
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Class QR')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              onDetect: _handleScan,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Point your camera at the instructor\'s QR Code.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
