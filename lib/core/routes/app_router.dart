import 'package:go_router/go_router.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/auth/screens/role_selection_screen.dart';
import '../../features/instructor/screens/instructor_dashboard.dart';
import '../../features/student/screens/student_dashboard.dart';
import '../../features/admin/screens/admin_dashboard.dart';
import '../../features/qr/screens/qr_generation_screen.dart';
import '../../features/qr/screens/qr_scanner_screen.dart';
import '../../features/qr/screens/success_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/role_selection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/instructor',
      builder: (context, state) => const InstructorDashboard(),
    ),
    GoRoute(
      path: '/student',
      builder: (context, state) => const StudentDashboard(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboard(),
    ),
    GoRoute(
      path: '/generate_qr',
      builder: (context, state) => const QRGenerationScreen(),
    ),
    GoRoute(
      path: '/scan_qr',
      builder: (context, state) => const QRScannerScreen(),
    ),
    GoRoute(
      path: '/success',
      builder: (context, state) => const SuccessScreen(),
    ),
  ],
);
