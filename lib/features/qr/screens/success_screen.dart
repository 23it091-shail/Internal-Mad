import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFF27AE60);
    const Color buttonColor = Color(0xFF2ECC71);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: bgColor,
                  size: 80,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Attendance Successful',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Location and time verified & synced',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: bgColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.history_edu),
                      label: const Text('History', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        context.go('/student');
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: bgColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.dashboard),
                      label: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                         context.go('/student');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    context.go('/student');
                  },
                  child: const Text('Done', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
