import 'package:flutter/material.dart';
import 'utils/router.dart'; // 👈 your go_router config

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // 👈 .router instead of MaterialApp
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter, // 👈 your GoRouter instance
    );
  }
}
