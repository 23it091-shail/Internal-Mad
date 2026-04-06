import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    final error = await auth.signIn(_emailController.text, _passwordController.text);
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (error == null) {
        final role = await FirestoreService().getUserRole(auth.user!.uid);
        if (mounted) {
          if (role == 'instructor') context.go('/instructor_dashboard');
          else if (role == 'admin') context.go('/admin_dashboard');
          else context.go('/student_dashboard');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text('EduTrack attendance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              _isLoading 
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(onPressed: _login, child: const Text('Login')),
                  ),
              TextButton(
                onPressed: () => context.push('/signup'),
                child: const Text('Don\'t have an account? Sign Up'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
