import 'package:flutter/material.dart';
import './utils/router.dart'; // 👈 single source of truth for all routes

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter, // 👈 uses router.dart
    );
  }
}