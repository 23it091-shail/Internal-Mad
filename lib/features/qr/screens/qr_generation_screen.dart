import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_state.dart';
import '../../../core/services/firestore_service.dart';

class QRGenerationScreen extends StatefulWidget {
  const QRGenerationScreen({super.key});

  @override
  State<QRGenerationScreen> createState() => _QRGenerationScreenState();
}

class _QRGenerationScreenState extends State<QRGenerationScreen> {
  late String sessionId; 
  final DateTime startTime = DateTime.now();
  late DateTime endTime;
  
  double? _lat;
  double? _lng;
  bool _isLoading = true;
  String _errorMsg = '';
  
  // Metadata
  String subject = '';
  String teacherName = '';
  bool _hasStarted = false;

  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _teacherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    endTime = startTime.add(const Duration(minutes: 5));
    sessionId = 'Class_${DateTime.now().month}-${DateTime.now().day}_${DateTime.now().hour.toString().padLeft(2, "0")}${DateTime.now().minute.toString().padLeft(2, "0")}';
  }

  Future<void> _startSession() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      subject = _subjectController.text;
      teacherName = _teacherController.text;
      _isLoading = true;
      _hasStarted = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _errorMsg = 'Location services are disabled.');
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _errorMsg = 'Location permissions denied.');
          return;
        }
      }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      if (mounted) {
        final sessionData = {
          'id': sessionId,
          'time': startTime,
          'lat': position.latitude,
          'lng': position.longitude,
          'validUntil': endTime.toIso8601String(),
          'subject': subject,
          'teacherName': teacherName,
        };

        Provider.of<AppState>(context, listen: false).addSession(
          sessionId,
          lat: position.latitude,
          lng: position.longitude,
          validUntil: endTime,
          subject: subject,
          teacherName: teacherName,
        );

        await FirestoreService().createSession(sessionData);

        setState(() {
          _lat = position.latitude;
          _lng = position.longitude;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = 'Error fetching location: $e';
          _isLoading = false;
        });
      }
    }
  }

  String get _qrData {
    final Map<String, dynamic> data = {
      'sessionId': sessionId,
      'validUntil': endTime.toIso8601String(),
      'lat': _lat, 
      'lng': _lng,
      'subject': subject,
      'teacherName': teacherName,
    };
    return jsonEncode(data);
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasStarted) {
      return Scaffold(
        appBar: AppBar(title: const Text('New Session Details')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text('Set up your class session', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject (e.g. Mobile Computing)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.book),
                  ),
                  validator: (v) => v!.isEmpty ? 'Please enter subject' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _teacherController,
                  decoration: const InputDecoration(
                    labelText: 'Teacher Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (v) => v!.isEmpty ? 'Please enter teacher name' : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _startSession,
                    child: const Text('Generate QR Code'),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    if (_isLoading && _errorMsg.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Starting Session...')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Acquiring Instructor GPS Coordinates...'),
            ],
          ),
        ),
      );
    }

    if (_errorMsg.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Session Error')),
        body: Center(child: Text(_errorMsg, style: const TextStyle(color: Colors.red))),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Active Session')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(subject, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Instructor: $teacherName', style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
              const SizedBox(height: 20),
              const Text('Scan to mark attendance', style: TextStyle(fontSize: 16)),
              Text('Valid until: ${TimeOfDay.fromDateTime(endTime).format(context)}', 
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: QrImageView(
                  data: _qrData,
                  version: QrVersions.auto,
                  size: 250.0,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.stop_circle),
                label: const Text('End Session Early'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
