import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 👈 added

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();

    // 👇 replaced Navigator.pushReplacement with go_router
    Future.delayed(const Duration(milliseconds: 5000), () {
      if (mounted) {
        context.go('/launch');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF110E26),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Topographical Background Image
          Image.asset(
            'assets/images/splash_bg.png',
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.5),
          ),

          // 2. Animated Centered Content
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: _animation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Infinity Logo
                    Image.asset(
                      'assets/images/logo_large.png',
                      width: 140,
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),

                    // Main Title
                    const Text(
                      'EMORA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4.0,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      'YOUR MOOD YOUR MUSIC',
                      style: TextStyle(
                        color: Color(0xFFFF2994),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
