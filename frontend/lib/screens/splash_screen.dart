import 'dart:async';
import 'package:flutter/material.dart';
import 'launch_screen.dart'; // Make sure the path matches your folder structure

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

    // Set up the animation controller (duration of the pop-in effect)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // Use a curved animation for a smooth, premium "pop" effect
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    // Start the animation
    _controller.forward();

    // Navigate to the Launch Screen after 5 seconds with a smooth Fade Transition
    Future.delayed(const Duration(milliseconds: 5000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(
              milliseconds: 800,
            ), // 800ms fade duration
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LaunchScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
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
      backgroundColor: const Color(0xFF110E26), // Dark navy background
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Topographical Background Image
          Image.asset(
            'assets/images/splash_bg.png', // Export this full background from Figma
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(
              0.5,
            ), // Dims background slightly if needed
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
                      'assets/images/logo_large.png', // Export the large 3D logo
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
                        color: Color(0xFFFF2994), // Neon pink color from design
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
