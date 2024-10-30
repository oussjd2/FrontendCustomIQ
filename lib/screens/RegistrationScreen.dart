import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Home/home.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'AvatarGenerationScreen.dart'; // Ensure this is correctly imported

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _userIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return; // If the form is not valid, do nothing.
    }
    final apiService = Provider.of<ApiService>(context, listen: false);
    Map<String, dynamic> userData = {
      'name': _nameController.text,
      'user_id': _userIdController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    try {
      final result = await apiService.createUser(userData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration successful')));
      // Navigate to HomeInterface instead of AvatarGenerationScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeInterface(), // Navigate to the home page
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            color: Colors.blue.shade50,  // Very light blue background
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/logo.png', height: 120),  // Logo at the top
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: Icon(Icons.person, color: Colors.blue),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _userIdController,
                  decoration: InputDecoration(
                    labelText: "User ID",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: Icon(Icons.badge, color: Colors.blue),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a user ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: Icon(Icons.email, color: Colors.blue),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: Icon(Icons.lock, color: Colors.blue),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (!RegExp(r'^(?=.*[A-Z]).{7,}$').hasMatch(value)) {
                      return 'Password must be at least 7 characters long and contain an uppercase letter';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.blue),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: const Text("Register", style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
