import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // 1. The Breathing Neon Controller
    _glowController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1500),
        )..repeat(
          reverse: true,
        ); // The "reverse: true" makes it pulse in and out infinitely

    // 2. The size of the glow (pulses between 20 and 60 pixels wide)
    _glowAnimation = Tween<double>(begin: 20.0, end: 60.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // 3. Navigate to the next screen after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        context.go('/launch');
      }
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF110E26,
      ), // Emora's premium dark background
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Topography
          Image.asset(
            'assets/images/splash_bg.png',
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.35),
          ),

          // Foreground Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🪄 The Neon Breathing Wrapper
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          // Base Layer: Deep Purple Wide Glow
                          BoxShadow(
                            color: const Color(0xFF3B00FF).withOpacity(0.4),
                            blurRadius: _glowAnimation.value + 40,
                            spreadRadius: _glowAnimation.value / 2,
                          ),
                          // Core Layer: Hot Pink Intense Glow
                          BoxShadow(
                            color: const Color(0xFFFF2994).withOpacity(0.5),
                            blurRadius: _glowAnimation.value,
                            spreadRadius: _glowAnimation.value / 4,
                          ),
                        ],
                      ),
                      child:
                          child, // The Lottie file goes inside this glowing box
                    );
                  },
                  child: Lottie.asset(
                    'assets/animations/infinite_loader.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 32),

                // Animated Text Area
                Column(
                  children: [
                    Text(
                      'EMORA',
                      style: GoogleFonts.arvo(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 6.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'YOUR MOOD YOUR MUSIC',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFF2994), // Emora Pink
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
