import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterWithEmailScreen extends StatefulWidget {
  const RegisterWithEmailScreen({super.key});

  @override
  State<RegisterWithEmailScreen> createState() => _RegisterWithEmailScreenState();
}

class _RegisterWithEmailScreenState extends State<RegisterWithEmailScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dobDayController = TextEditingController();
  final _dobMonthController = TextEditingController();
  final _dobYearController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToPolicy = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobDayController.dispose();
    _dobMonthController.dispose();
    _dobYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15173D),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              children: [
                _buildTopBar(), // 👈 Updated for top-right logo
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildTitle(),
                        const SizedBox(height: 28),
                        _buildFieldLabel('Email'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _emailController,
                          hint: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 18),
                        _buildFieldLabel('Username'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _usernameController,
                          hint: 'Username',
                        ),
                        const SizedBox(height: 18),
                        _buildFieldLabel('Date of Birth'),
                        const SizedBox(height: 8),
                        _buildDobRow(),
                        const SizedBox(height: 6),
                        _buildDobNote(),
                        const SizedBox(height: 18),
                        _buildFieldLabel('Password'),
                        const SizedBox(height: 8),
                        _buildPasswordTextField(
                          controller: _passwordController,
                          hint: 'Password',
                          obscure: _obscurePassword,
                          onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        const SizedBox(height: 18),
                        _buildFieldLabel('Confirm Password'),
                        const SizedBox(height: 8),
                        _buildPasswordTextField(
                          controller: _confirmPasswordController,
                          hint: 'Confirm Password',
                          obscure: _obscureConfirmPassword,
                          onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        const SizedBox(height: 18),
                        _buildPrivacyRow(),
                        const SizedBox(height: 32),
                        _buildContinueButton(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Updated Top Bar with Logo on Right ─────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          ),
          // Only the logo remains here
          Image.asset(
            'assets/images/logo.png',
            width: 45, 
            height: 45,
          ),
        ],
      ),
    );
  }
  // ── Form UI Helpers ────────────────────────────────────────────────────────
  Widget _buildTitle() {
    return Text(
      'Enter the details',
      style: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: const Color(0xFFA7338A),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
      decoration: _inputDecoration(hint),
    );
  }

  Widget _buildPasswordTextField({required TextEditingController controller, required String hint, required bool obscure, required VoidCallback onToggle}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
      decoration: _inputDecoration(hint).copyWith(
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF6B6B8A), size: 18),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFF1E1E35),
      hintStyle: const TextStyle(color: Color(0xFF6B6B8A), fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: Color(0xFF2E2E50))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: Color(0xFF2E2E50))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: Color(0xFFA7338A), width: 1.5)),
    );
  }

  Widget _buildDobRow() {
    return Row(
      children: [
        Expanded(child: _buildDobField(_dobDayController, 'DD', 2)),
        const SizedBox(width: 10),
        Expanded(child: _buildDobField(_dobMonthController, 'MM', 2)),
        const SizedBox(width: 10),
        Expanded(flex: 2, child: _buildDobField(_dobYearController, 'YYYY', 4)),
      ],
    );
  }

  Widget _buildDobField(TextEditingController controller, String hint, int maxLength) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: maxLength,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: _inputDecoration(hint).copyWith(counterText: ''),
    );
  }

  Widget _buildDobNote() {
    return Text(
      "Your birthday is only visible to you and Emora's team.",
      style: GoogleFonts.poppins(color: const Color(0xFF6B6B8A), fontSize: 11, height: 1.4),
    );
  }

  Widget _buildPrivacyRow() {
    return GestureDetector(
      onTap: () => setState(() => _agreeToPolicy = !_agreeToPolicy),
      child: Row(
        children: [
          Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: _agreeToPolicy ? const Color(0xFFA7338A) : const Color(0xFF4A4A6A), width: 1.5),
              color: _agreeToPolicy ? const Color(0xFFA7338A).withOpacity(0.2) : Colors.transparent,
            ),
            child: _agreeToPolicy ? const Icon(Icons.check, size: 12, color: Color(0xFFA7338A)) : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(color: const Color(0xFF9090B0), fontSize: 13),
                children: const [
                  TextSpan(text: 'I agree to the '),
                  TextSpan(text: "Emora's Privacy Policy", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: _agreeToPolicy ? () => context.go('/home') : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity, height: 52,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Text(
            'Continue',
            style: GoogleFonts.poppins(color: _agreeToPolicy ? const Color(0xFF15173D) : const Color(0xFF6B6B8A), fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}