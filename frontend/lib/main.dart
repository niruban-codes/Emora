import 'package:flutter/material.dart';
import './screens/launch_screen.dart';
import './screens/splash_screen.dart';
import './screens/auth/login_screen.dart';
import './screens/auth/register_screen.dart';
import './screens/auth/auth_widget.dart';
import './screens/edit_profile_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => const SplashScreen(),
        '/launch': (context) => const LaunchScreen(),
      },
    );
  }
}

