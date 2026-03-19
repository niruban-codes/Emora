import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  // Theme Colors - Syncing with your Home & Profile screens
  static const Color bgColor = Color(0xFF15173D);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color activeHighlight = Color(0xFFA7338A);
  static const Color textSecondary = Colors.white38;
  static const Color buttonRed = Color(0xFFC62828);

  // Controllers to handle text input
  final _usernameController = TextEditingController(text: 'alex_rivera_ai');
  final _emailController = TextEditingController(text: 'alex@emora.ai');
  final _currentPasswordController = TextEditingController(
    text: '************',
  );
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(), // Navigates back to Profile
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image Section
            Center(
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentPurple.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                    'https://i.imgur.com/vHqJ4r5.png',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Alex Rivera',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              'Pro Member since 2024',
              style: TextStyle(
                color: accentPurple,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),

            // Action Buttons (Upload/Remove)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.upload, size: 18),
                    label: const Text('Upload New'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: accentPurple, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Remove'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonRed.withOpacity(0.15),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            _buildSectionHeader(Icons.person_outline, 'PERSONAL DETAILS'),
            const SizedBox(height: 15),
            _buildInputField('USERNAME', _usernameController),
            _buildInputField(
              'EMAIL ADDRESS',
              _emailController,
              suffixIcon: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 18,
              ),
            ),

            const SizedBox(height: 20),
            _buildSectionHeader(Icons.lock_outline, 'SECURITY'),
            const SizedBox(height: 15),
            _buildInputField(
              'CURRENT PASSWORD',
              _currentPasswordController,
              obscureText: true,
            ),
            _buildInputField(
              'NEW PASSWORD',
              _newPasswordController,
              hintText: 'Min. 8 characters',
              obscureText: true,
            ),

            const SizedBox(height: 40),
            // Save Changes Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logic to save data would go here
                  context.pop(); // Returns to Profile screen after "saving"
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ── Helper Methods (These fix the errors in your screenshot) ──────────────

  Widget _buildSectionHeader(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: accentPurple),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: accentPurple,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    Widget? suffixIcon,
    String? hintText,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 15),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            fillColor: Colors.white.withOpacity(0.05),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: suffixIcon,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0F1130),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: activeHighlight,
      unselectedItemColor: textSecondary,
      currentIndex: 4, // Profile tab is active
      onTap: (index) {
        final routes = ['/home', '/search', '/library', '/history', '/profile'];
        context.go(routes[index]);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'EXPLORE'),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music_outlined),
          label: 'LIBRARY',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'HISTORY'),
        BottomNavigationBarItem(icon: Icon(Icons.person_pin), label: 'PROFILE'),
      ],
    );
  }
}
