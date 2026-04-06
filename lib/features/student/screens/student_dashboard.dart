import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final studentId = auth.user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.signOut();
              context.go('/login');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.blue.withOpacity(0.1),
              child: ListTile(
                leading: const Icon(Icons.camera_alt, size: 40, color: Colors.blue),
                title: const Text('Scan QR Code'),
                subtitle: const Text('Mark your attendance'),
                onTap: () {
                  context.push('/scan_qr');
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: FirestoreService().getAttendanceForStudent(studentId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final attend = snapshot.data ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Your Attendance (Firestore)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Divider(),
                          Expanded(
                            child: attend.isEmpty 
                              ? const Center(child: Text('No scans recorded yet.'))
                              : ListView.builder(
                                  itemCount: attend.length,
                                  itemBuilder: (context, i) {
                                    final item = attend[i];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: ListTile(
                                        isThreeLine: true,
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Icon(Icons.person_pin_circle, color: Colors.white),
                                        ),
                                        title: Text(item['subject'] ?? 'General Session', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Teacher: ${item['teacherName'] ?? 'Instructor'}'),
                                            Text('Ref: ${item["sessionId"]}'),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          ),
                        ],
                      );
                    }
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
