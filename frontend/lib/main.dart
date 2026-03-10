import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'utils/router.dart';

void main() {
  runApp(const EmoraApp());
}

class EmoraApp extends StatelessWidget {
  const EmoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Emora',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Auto-switches based on device settings
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
