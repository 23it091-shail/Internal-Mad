import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_state.dart';
import '../../../core/services/report_service.dart';
import '../../../core/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard & Reports'),
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
      body: Consumer<AppState>(
        builder: (context, state, child) {
          final totalSessions = state.sessions.length;
          final totalAttendance = state.attendances.length;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('System Overview (Local Sync)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text('Total Attendance Scans: $totalAttendance'),
                      Text('Active Sessions: $totalSessions'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.assessment, color: Colors.blue),
                  title: const Text('Export CSV Report'),
                  subtitle: Text('Contains $totalAttendance attendance records'),
                  trailing: const Icon(Icons.download),
                  onTap: () {
                    ReportService.exportAttendanceToCSV(state.attendances);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report generated and download started!')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.people, color: Colors.green),
                  title: const Text('Admin Statistics'),
                  subtitle: const Text('View detailed system audits'),
                  onTap: () {},
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
