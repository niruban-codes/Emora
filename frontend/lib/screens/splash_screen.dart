import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

   // Check Auth state and navigate after 4 seconds
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (!mounted) return;

      // Ask Firebase if a user is currently signed in
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is remembered, skip the launch screen!
        context.go('/home');
      } else {
        // Nobody is logged in, show the launch/login flow
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
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Foreground Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Animation
                  Image.asset(
                    'assets/animations/logo_animation.gif',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                 ),
                ),

                const SizedBox(height: 0),

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
                    const SizedBox(height: 1),
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
          IgnorePointer(
            child: Image.asset(
              'assets/images/Vector.png',
              fit: BoxFit.cover, // Ensures it stretches over the whole screen
              opacity: const AlwaysStoppedAnimation(
                0.8,
              ), // Optional: tweak if it's too bright
            ),
          ),
        ],
      ),
    );
  }
}
