import 'package:flutter/material.dart';
import 'auth_widgets.dart';
import 'login_screen.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            color: const Color(0xFF0D1333),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.all_inclusive, color: Colors.purpleAccent, size: 32),
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'SIGN –  UP',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 24, top: 4),
                  child: Divider(color: Colors.white54, thickness: 1, endIndent: 280),
                ),
                const SizedBox(height: 30),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      socialButton('Continue with Google',
                          Image.network('https://www.google.com/favicon.ico', width: 20)),
                      socialButton('Continue with Facebook',
                          const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 22)),
                      socialButton('Continue with Apple',
                          const Icon(Icons.apple, color: Colors.white, size: 22)),
                      const SizedBox(height: 8),
                      Row(children: const [
                        Expanded(child: Divider(color: Colors.white24)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('or', style: TextStyle(color: Colors.white38)),
                        ),
                        Expanded(child: Divider(color: Colors.white24)),
                      ]),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E3A8C),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {},
                          child: const Text('Continue with an email',
                              style: TextStyle(color: Colors.white, fontSize: 15)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen())),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Already have an account ? ',
                            style: TextStyle(color: Colors.white54, fontSize: 13),
                            children: [
                              TextSpan(
                                text: 'Sign in',
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}