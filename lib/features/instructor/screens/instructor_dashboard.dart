import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';

class InstructorDashboard extends StatelessWidget {
  const InstructorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructor Dashboard'),
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
              child: ListTile(
                leading: const Icon(Icons.qr_code, size: 40, color: Colors.blue),
                title: const Text('Generate QR Code'),
                subtitle: const Text('Start 5-min attendance session'),
                onTap: () {
                  context.push('/generate_qr');
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: FirestoreService().getSessions(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final sessions = snapshot.data ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Session History (Live)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Divider(),
                          Expanded(
                            child: sessions.isEmpty 
                              ? const Center(child: Text('No sessions found in Firestore.'))
                              : ListView.builder(
                                  itemCount: sessions.length,
                                  itemBuilder: (context, i) {
                                    final session = sessions[i];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: ListTile(
                                        isThreeLine: true,
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          child: Icon(Icons.school, color: Colors.white),
                                        ),
                                        title: Text(session['subject'] ?? 'General Session', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Instructor: ${session['teacherName'] ?? 'Me'}'),
                                            Text('Date: ${session['id'].toString().substring(6)}'),
                                          ],
                                        ),
                                        trailing: const Icon(Icons.check_circle, color: Colors.green),
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
