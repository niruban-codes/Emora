import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _obscurePassword = true;

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
              const SizedBox(height: 48),

              // ── EMORA Logo ──
              _buildLogo(),

              const SizedBox(height: 36),

              // ── Continue with Google ──
              _socialButton(
                label: 'Continue with Google',
                icon: const Icon(
                  Icons.g_mobiledata,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(height: 16),

              // ── Continue with Facebook ──
              _socialButton(
                label: 'Continue with Facebook',
                icon: const Icon(
                  Icons.facebook,
                  color: Color(0xFF1877F2),
                  size: 24,
                ),
              ),

              const SizedBox(height: 24),

              // ── OR divider ──
              _orDivider(),

              const SizedBox(height: 24),

              // ── Email field ──
              _fieldLabel('Email'),
              const SizedBox(height: 8),
              _inputField(
                hint: 'Enter your email address',
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 18),

              // ── Password field ──
              _fieldLabel('Password'),
              const SizedBox(height: 8),
              _passwordField(),

              const SizedBox(height: 14),

              // ── Remember Me + Forgot Password ──
              _rememberForgotRow(),

              const SizedBox(height: 28),

              // ── Sign In Button ──
              _signInButton(),

              const SizedBox(height: 40),

              // ── Sign Up Prompt ──
              _signUpPrompt(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── EMORA Logo ──────────────────────────────────────────────────────────
  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'EMORA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(width: 8),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF9B59B6), Color(0xFF3498DB)],
          ).createShader(bounds),
          child: const Icon(Icons.all_inclusive, color: Colors.white, size: 28),
        ),
      ],
    );
  }

  // ── Social Button ───────────────────────────────────────────────────────
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

  // ── OR Divider ──────────────────────────────────────────────────────────
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

  // ── Field Label ─────────────────────────────────────────────────────────
  Widget _fieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      ),
    );
  }

  // ── Input Field ─────────────────────────────────────────────────────────
  Widget _inputField({required String hint, required IconData icon}) {
    return TextField(
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        filled: true,
        fillColor: const Color(0xFF1A2040),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
    );
  }

  // ── Password Field ──────────────────────────────────────────────────────
  Widget _passwordField() {
    return TextField(
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Enter your password',
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Colors.white38,
          size: 20,
        ),
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obscurePassword = !_obscurePassword),
          child: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.white38,
            size: 20,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFF1A2040),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
    );
  }

  // ── Remember Me + Forgot Password ───────────────────────────────────────
  Widget _rememberForgotRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (val) => setState(() => _rememberMe = val ?? false),
                activeColor: const Color(0xFF2E3A8C),
                side: const BorderSide(color: Colors.white38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Remember Me',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        const Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  // ── Sign In Button ──────────────────────────────────────────────────────
  Widget _signInButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => context.go('/playlist'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Sign in',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ── Sign Up Prompt ──────────────────────────────────────────────────────
  Widget _signUpPrompt() {
    return GestureDetector(
      onTap: () => context.go('/register'),
      child: RichText(
        text: const TextSpan(
          text: "Don't have an Account ? ",
          style: TextStyle(color: Colors.white54, fontSize: 13),
          children: [
            TextSpan(
              text: 'Sign up',
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
}
