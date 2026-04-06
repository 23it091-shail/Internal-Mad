import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'student';
  bool _isLoading = false;

  void _signup() async {
    setState(() => _isLoading = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    final error = await auth.signUp(_emailController.text, _passwordController.text, _selectedRole);
    
    if (mounted) {
      if (error == null) {
        await FirestoreService().createUserProfile(auth.user!.uid, _emailController.text, _selectedRole);
        if (mounted) {
          setState(() => _isLoading = false);
          if (_selectedRole == 'instructor') context.go('/instructor_dashboard');
          else if (_selectedRole == 'admin') context.go('/admin_dashboard');
          else context.go('/student_dashboard');
        }
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
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
            const SizedBox(height: 24),
            const Text('Choose your role:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedRole,
              isExpanded: true,
              items: ['student', 'instructor', 'admin'].map((role) {
                return DropdownMenuItem(value: role, child: Text(role.toUpperCase()));
              }).toList(),
              onChanged: (val) => setState(() => _selectedRole = val!),
            ),
            const SizedBox(height: 32),
            _isLoading 
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(onPressed: _signup, child: const Text('Sign Up')),
                ),
          ],
        ),
      ),
    );
  }
}
