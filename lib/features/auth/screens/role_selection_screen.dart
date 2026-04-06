import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EduTrack - Select Role')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.school, size: 32),
                label: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Login as Student', style: TextStyle(fontSize: 18)),
                ),
                onPressed: () => context.go('/student'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.co_present, size: 32),
                label: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Login as Instructor', style: TextStyle(fontSize: 18)),
                ),
                onPressed: () => context.go('/instructor'),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                icon: const Icon(Icons.admin_panel_settings, size: 32),
                label: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Login as Admin', style: TextStyle(fontSize: 18)),
                ),
                onPressed: () => context.go('/admin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
