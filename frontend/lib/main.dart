import 'package:flutter/material.dart';
import './screens/launch_screen.dart';
import './screens/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/", // App starts here
      routes: {
        '/': (context) => const SplashScreen(), // 1. Map '/' to SplashScreen
        '/launch': (context) =>
            const LaunchScreen(), // 2. Map '/launch' to LaunchScreen
      },
    );
  }
}
