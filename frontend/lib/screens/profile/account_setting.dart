import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 👈 added
import '../../../services/firestore_service.dart'; // 👈 added
import 'package:cloud_firestore/cloud_firestore.dart'; // 👈 added

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
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController(
    text: '************',
  );
  final _newPasswordController = TextEditingController();

  bool _isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData(); // 2. Load real data on start
  }

  // 3. Fetch data from Firebase
  Future<void> _loadCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Assuming your FirestoreService has getUserProfile
        final userData = await FirestoreService().getUserProfile(user.uid);

        setState(() {
          _usernameController.text = userData?['name'] ?? 'No Name Found';
          _emailController.text = userData?['email'] ?? user.email ?? '';
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        // Optional: show error snackbar
      }
    }
  }

  // 4. Update the save logic for TC11
  Future<void> _handleSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _usernameController.text.isNotEmpty) {
      setState(() => _isLoading = true);

      // Add a method in FirestoreService to update the name
      await FirestoreService().updateUserProfile(
        user.uid,
        _usernameController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully!')),
        );
        context.pop();
      }
    }
  }

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
          onPressed: () => context.pop(),
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
      // 1. ADD FUTUREBUILDER TO FETCH REAL DATA
      body: FutureBuilder<Map<String, dynamic>?>(
        future: FirestoreService().getUserProfile(
          FirebaseAuth.instance.currentUser?.uid ?? '',
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: accentPurple),
            );
          }

          // ✅ IMPROVED LOGIC: Only fill if the controllers are totally empty
          // This prevents the UI from resetting if the user is in the middle of typing!
          if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!;
            if (_usernameController.text.isEmpty) {
              _usernameController.text = data['name'] ?? '';
            }
            if (_emailController.text.isEmpty) {
              _emailController.text = data['email'] ?? '';
            }
          }

          return SingleChildScrollView(
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
                // 4. DISPLAY REAL NAME
                Text(
                  _usernameController.text,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // --- DYNAMIC MEMBER DATE START ---
                Text(
                  // We check if snapshot has data and the createdAt field exists
                  snapshot.hasData && snapshot.data?['createdAt'] != null
                      ? 'Member since ${(snapshot.data!['createdAt'] as Timestamp).toDate().year}'
                      : 'Member since 2026', // Fallback while loading or if null
                  style: const TextStyle(
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
                        onPressed: () {}, // Future task: Image upload
                        icon: const Icon(Icons.upload, size: 18),
                        label: const Text('Upload New'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: accentPurple,
                            width: 1.5,
                          ),
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
                // 5. UPDATE SAVE BUTTON LOGIC
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final uid = FirebaseAuth.instance.currentUser?.uid;
                      if (uid != null) {
                        // Call a new update method in your service
                        await FirestoreService().updateUserProfile(
                          uid,
                          _usernameController.text,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated!')),
                          );
                          context.pop();
                        }
                      }
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
          );
        },
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

  // ── Bottom Navigation (UPDATED) ────────────────────────────────────────────
  Widget _buildBottomNav(BuildContext context) {
    final items = [
      const _NavItem(icon: Icons.home_rounded, label: 'HOME', route: '/home'),
      const _NavItem(
        icon: Icons.search_rounded,
        label: 'EXPLORE',
        route: '/search',
      ),
      const _NavItem(
        icon: Icons.library_music_rounded,
        label: 'LIBRARY',
        route: '/library',
      ),
      const _NavItem(
        icon: Icons.history_rounded,
        label: 'HISTORY',
        route: '/history',
      ),
      const _NavItem(
        icon: Icons.person_rounded,
        label: 'PROFILE',
        route: '/profile',
      ),
    ];

    // 👇 ONLY THE VISUAL DESIGN CHANGES BELOW 👇
    return Container(
      color: const Color(0xFF080716),
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected =
              index == 4; // Hardcoded to 4 since this is a sub-page of Profile

          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                context.go(items[index].route);
              } else {
                // If they click Profile while in settings, just go back to the main profile page
                context.pop();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  items[index].icon,
                  color: isSelected
                      ? const Color(0xFFE040FB)
                      : Colors.white.withOpacity(0.4),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  items[index].label,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFFE040FB)
                        : Colors.white.withOpacity(0.4),
                    fontSize: 9,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Nav Item Model ─────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
