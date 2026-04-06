import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'core/providers/app_state.dart';
import 'core/services/auth_service.dart';
import 'firebase_options.dart';

// Screens
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/instructor/screens/instructor_dashboard.dart';
import 'features/student/screens/student_dashboard.dart';
import 'features/admin/screens/admin_dashboard.dart';
import 'features/qr/screens/qr_generation_screen.dart';
import 'features/qr/screens/qr_scanner_screen.dart';
import 'features/qr/screens/success_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init failed: $e");
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const AttendanceApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/instructor_dashboard', builder: (context, state) => const InstructorDashboard()),
    GoRoute(path: '/student_dashboard', builder: (context, state) => const StudentDashboard()),
    GoRoute(path: '/admin_dashboard', builder: (context, state) => const AdminDashboard()),
    GoRoute(path: '/generate_qr', builder: (context, state) => const QRGenerationScreen()),
    GoRoute(path: '/scan_qr', builder: (context, state) => const QRScannerScreen()),
    GoRoute(path: '/success', builder: (context, state) => const SuccessScreen()),
  ],
);

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EduTrack Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
