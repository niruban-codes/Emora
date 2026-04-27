import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Full-screen Background Image
          Image.asset(
            'assets/images/launch_bg.png', // Make sure to export this from Figma
            fit: BoxFit.cover,
          ),

          // 2. Gradient Overlay (Ensures text is readable)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.5, 0.75, 1.0],
              ),
            ),
          ),

          // 3. UI Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Right Logo
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/images/logo.png', // Export the infinity logo from Figma
                      width: 48,
                      height: 48,
                    ),
                  ),

                  const Spacer(),

                  // Main Quote
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) =>
                        const LinearGradient(
                          begin: Alignment
                              .topCenter, // Adjust these to change gradient direction
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFF38BDC), Color(0xFFDBA4CF)],
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                    child: Text(
                      '"Where Words Fail,\nMusic Speaks."',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.arvo(
                        // The text color MUST be white for the gradient mask to work
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Get Started Button
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Register or Home
                        context.push('/register');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B62),
                        foregroundColor: Colors.white,
                        // 👇 Added horizontal padding to make it a nice pill shape
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 40,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign In Prompt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account ? ',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Login Screen
                          context.push('/login');
                        },
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
