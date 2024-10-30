import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart'; // Adjust the import path as necessary

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _requestResetLink() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    try {
      // Placeholder for actual API call
      // await apiService.requestPasswordReset(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('If a user with that email exists, a password reset link has been sent.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to request password reset: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: _requestResetLink,
              child: const Text('Request Reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}
