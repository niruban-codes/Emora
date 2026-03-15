import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'auth_widgets.dart'; 

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            color: const Color.fromARGB(255, 11, 16, 47),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              color: Colors.black,
            ),
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
                const SizedBox(height: 80) ,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'SIGN –  IN',
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
                  child: Divider(color: Colors.white54, thickness: 1, endIndent: 260),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 8),
                      myTextField('Enter your email address', Icons.email_outlined),
                      const SizedBox(height: 18),
                      const Text('Password', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 8),
                      myTextField('Enter your password', Icons.lock_outline, isPass: true),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: const [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: Checkbox(
                                value: true,
                                onChanged: null,
                                activeColor: Color(0xFF2E3A8C),
                                side: BorderSide(color: Colors.white38),
                              ),
                            ),
                            SizedBox(width: 6),
                            Text('Remember Me', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          ]),
                          const Text('Forgot Password?', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E3A8C),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {},
                          child: const Text('Sign in', style: TextStyle(color: Colors.white, fontSize: 15)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Right after the button
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const RegisterScreen())),
                          child: RichText(
                            text: const TextSpan(
                              text: "Don't have an Account ? ",
                              style: TextStyle(color: Colors.white54, fontSize: 13),
                              children: [
                                TextSpan(
                                  text: 'Sign up',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
