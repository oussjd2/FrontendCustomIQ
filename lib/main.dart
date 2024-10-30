import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/user_controller.dart';
import 'services/api_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/user_list_screen.dart';
import 'Home/home.dart';
import 'screens/registrationScreen.dart';
import 'screens/onboarding_screen.dart';
import 'dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserController(apiService: context.read<ApiService>()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/userList': (context) => const UserListScreen(),
          '/home': (context) => HomeInterface(),
          '/register': (context) => const RegistrationScreen(),
          '/OnBoarding': (context) => const OnBoarding(),
          '/adminDash': (context) =>  DashBoard(),
        },
      ),
    );
  }
}
