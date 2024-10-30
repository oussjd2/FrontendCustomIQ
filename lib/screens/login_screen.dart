import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'DisplayModelScreen.dart';
import 'ForgetPasswordScreen.dart';
import 'PlayerReadyMeScreen.dart';
import 'avatar_maker_screen.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../assets.dart';
import '../controllers/avatar_maker_controller.dart';
import '../shared/background_shape.dart';
import '../shared//color.dart';
import '../shared//text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'onboarding_screen.dart';
import 'package:avatarmakercopy/main.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _attemptLogin() async {
    final apiService = Provider.of<ApiService>(context, listen: false);

    // Check if the credentials are for admin testing
    if (_userIdController.text == 'admin' && _passwordController.text == 'admin') {
      Navigator.of(context).pushReplacementNamed('/adminDash'); // Direct navigation to the Admin Dashboard
      return; // Exit the function after handling admin case
    }

    // Check if the credentials are for 'oussama' testing
    if (_userIdController.text == 'oussama' && _passwordController.text == 'oussama') {
      Navigator.of(context).pushReplacementNamed('/OnBoarding'); // Direct navigation to the Onboarding screen
      return; // Exit the function after handling 'oussama' case
    }

    try {
      final success = await apiService.authenticateUser(
        _userIdController.text,
        _passwordController.text,
      );
      if (success) {
        Navigator.of(context).pushReplacementNamed('/OnBoarding'); // Navigate to the onboarding screen upon successful login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Please check your credentials.'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e'))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(24),
        color: Colors.blue.shade50,  // Very light blue background
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Welcome Back",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),  // Smaller font size
            ),
            Image.asset('assets/logo.png', height: 120),  // Logo under the text
            _inputFields(),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _inputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _userIdController,
          decoration: InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.blue.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.blue.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password, color: Colors.blue),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _attemptLogin,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
          ),
          child: const Text("Sign in", style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _actionButtons() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()));
          },
          child: const Text("Forgot password?", style: TextStyle(color: Colors.blue)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/register');
          },
          child: const Text('Sign up', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayerReadyMeScreen()));
          },
          child: const Text('Player Ready Me', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DisplayModelScreen()));
          },
          child: const Text('Avatar3Dshow', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        /*ElevatedButton(
          onPressed: () {
            Navigator.of(context). pushNamed('/userList');
          },
          child: const Text('Check Users List', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AvatarMakerScreen()));
          },
          child: const Text('Create Avatar', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),*/
      ],
    );
  }
}
