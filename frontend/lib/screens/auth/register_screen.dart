import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1333),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              _buildLogo(large: true),
              const SizedBox(height: 12),
              const Text(
                'Music for every mood',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Experience personalized soundscapes powered by advanced AI that understands your emotional state through your voice and biometric markers.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),
              _socialButton(label: 'Continue with Google', icon: _googleIcon()),
              const SizedBox(height: 16),
              _socialButton(
                label: 'Continue with Facebook',
                icon: _facebookIcon(),
              ),
              const SizedBox(height: 24),
              _orDivider(),
              const SizedBox(height: 24),
              _emailButton(context), // 👈 now navigates to /registerEmail
              const SizedBox(height: 24),
              _signInPrompt(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo({required bool large}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'EMORA',
          style: TextStyle(
            color: Colors.white,
            fontSize: large ? 36 : 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(width: 8),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF9B59B6), Color(0xFF3498DB)],
          ).createShader(bounds),
          child: Icon(
            Icons.all_inclusive,
            color: Colors.white,
            size: large ? 36 : 28,
          ),
        ),
      ],
    );
  }

  Widget _socialButton({required String label, required Widget icon}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A2040),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () =>
            context.push('/registerEmail'), // 👈 navigates to email form
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Continue with an email',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _orDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.white.withOpacity(0.15), thickness: 1),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.white.withOpacity(0.15), thickness: 1),
        ),
      ],
    );
  }

  Widget _signInPrompt(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/login'),
      child: RichText(
        text: const TextSpan(
          text: 'Already have an account ? ',
          style: TextStyle(color: Colors.white54, fontSize: 13),
          children: [
            TextSpan(
              text: 'Sign in',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _googleIcon() {
    return const Icon(Icons.g_mobiledata, color: Colors.white, size: 28);
  }

  Widget _facebookIcon() {
    return const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 24);
  }
}
