import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import '../../../services/firestore_service.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:google_fonts/google_fonts.dart';


class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  // Theme Colors - Syncing with your Home & Profile screens
  static const Color bgColor = Color(0xFF0D0C1D);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color activeHighlight = Color(0xFFA7338A);
  static const Color textSecondary = Colors.white38;
  static const Color buttonRed = Color(0xFFC62828);

  // Controllers to handle text input
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isLoading = true; // Added loading state
  String? _selectedAvatarAsset;
  String? _savedAvatarAsset;
  String _memberSinceText = 'Member since 2026';

  static const String defaultAvatar = 'assets/avatars/Girl 07.png';

  final List<String> _emoraAvatars = [
    'assets/avatars/Girl 07.png',
    'assets/avatars/Girl 08.png',
    'assets/avatars/Girl 11.png',
    'assets/avatars/Girl 13.png',
    'assets/avatars/Boy 03.png',
    'assets/avatars/Boy 04.png',
    'assets/avatars/Boy 05.png',
    'assets/avatars/Boy 12.png',
  ];

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

          _savedAvatarAsset = userData?['profilePicUrl'] ?? defaultAvatar;
          _selectedAvatarAsset = _savedAvatarAsset;

          if (userData?['createdAt'] != null) {
            final createdAt = userData!['createdAt'];
            if (createdAt is Timestamp) {
              final date = createdAt.toDate();
              _memberSinceText = "Member since ${date.year}";
            }
          }

          _isLoading = false;
        });
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          _showSnackBar('Failed to load user profile details.', isError: true);
        }
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: isError ? buttonRed : accentPurple,
      ),
    );
  }

  Future<void> _updateAvatarInFirestore(String avatarPath, String successMessage) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profilePicUrl': avatarPath});

      setState(() {
        _savedAvatarAsset = avatarPath;
        _selectedAvatarAsset = avatarPath;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage, style: GoogleFonts.poppins(fontSize: 13)),
            backgroundColor: accentPurple,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update avatar: ${e.toString()}', style: GoogleFonts.poppins(fontSize: 13)),
            backgroundColor: buttonRed,
          ),
        );
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
   

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for your email to load first.'),
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reset link sent! Check your inbox.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
          if (snapshot.connectionState == ConnectionState.waiting && _isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: accentPurple),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!;
            if (_usernameController.text.isEmpty) {
              _usernameController.text = data['name'] ?? '';
            }
            if (_emailController.text.isEmpty) {
              _emailController.text = data['email'] ?? '';
            }
            if (_savedAvatarAsset == null) {
              _savedAvatarAsset = data['profilePicUrl'] ?? defaultAvatar;
              _selectedAvatarAsset ??= _savedAvatarAsset;
            }
          }

          _selectedAvatarAsset ??= defaultAvatar;
          _savedAvatarAsset ??= defaultAvatar;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Image Section
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accentPurple.withOpacity(0.8),
                        width: 2.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(_selectedAvatarAsset!),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // 4. DISPLAY REAL NAME
                Text(
                  _usernameController.text,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                Text(
                  // We check if snapshot has data and the createdAt field exists
                  snapshot.hasData && snapshot.data?['createdAt'] != null
                      ? 'Member since ${(snapshot.data!['createdAt'] as Timestamp).toDate().year}'
                      : 'Member since 2026', // Fallback while loading or if null
                  style: GoogleFonts.poppins(
                    color: accentPurple,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),

                _buildSectionLabel('Choose an Emora Avatar'),
                _buildAvatarSelectionGrid(),
                const SizedBox(height: 25),

                // Action Buttons (Upload/Remove)
                _buildSectionLabel('Avatar Actions'),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:_selectedAvatarAsset == _savedAvatarAsset
                            ? null // Disabled if highlighted avatar is already saved
                            : () => _updateAvatarInFirestore(_selectedAvatarAsset!, 'Avatar saved successfully!'),
                        icon: const Icon(Icons.upload, size: 18),
                        label: Text(
                          'Save Avatar',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent,

                          disabledForegroundColor: Colors.white24,
                          disabledBackgroundColor: Colors.white.withOpacity(0.01),

                          side: BorderSide(
                            color: _selectedAvatarAsset != _savedAvatarAsset 
                                ? accentPurple 
                                : Colors.white10, 
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
                        onPressed:_savedAvatarAsset == defaultAvatar
                            ? null // Disabled if already running baseline default setup
                            : () => _updateAvatarInFirestore(defaultAvatar, 'Reset to default avatar!'),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: Text(
                          'Remove',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: buttonRed.withOpacity(0.15),

                          disabledForegroundColor: Colors.white10,
                          disabledBackgroundColor: Colors.white.withOpacity(0.02),

                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.poppins(
                        color: activeHighlight,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // 5. UPDATE SAVE BUTTON LOGIC
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        try {
                          // 1. Always update the display name
                          await FirestoreService().updateUserProfile(
                            user.uid,
                            _usernameController.text.trim(),
                          );

                          // 2. Check if they are trying to change their password
                          if (_currentPasswordController.text.isNotEmpty &&
                              _newPasswordController.text.isNotEmpty) {
                            // Ask Firebase to verify their old password first!
                            AuthCredential credential =
                                EmailAuthProvider.credential(
                                  email: user.email!,
                                  password: _currentPasswordController.text,
                                );

                            // Re-authenticate and update
                            await user.reauthenticateWithCredential(credential);
                            await user.updatePassword(
                              _newPasswordController.text,
                            );
                          }

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Account successfully updated!',
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                              ),
                            );
                            context.pop(); // Go back after saving
                          }
                        } on FirebaseAuthException catch (e) {
                          // If they typed the wrong current password, Firebase throws an error
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.message ??
                                      'Authentication failed. Check your current password.',
                                ),
                                backgroundColor: buttonRed,
                              ),
                            );
                          }
                        }
                      }
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: Text(
                      'Save Changes',
                      style: GoogleFonts.poppins(
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
    );
  }

  // ── Helper Methods (These fix the errors in your screenshot) ──────────────

  Widget _buildAvatarSelectionGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), 
      itemCount: _emoraAvatars.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, 
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        String currentUri = _emoraAvatars[index];
        bool isSelected = _selectedAvatarAsset == currentUri;
        bool isSaved = _savedAvatarAsset == currentUri;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedAvatarAsset = currentUri;
            });
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : accentPurple.withOpacity(0.3),
                    width: isSelected ? 2.5 : 1.2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(currentUri),
                ),
              ),
              if (isSaved)
                const CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, size: 11, color: Colors.white),
                )
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 10),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: accentPurple),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: accentPurple,
            fontSize: 16,
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
          style: GoogleFonts.poppins(
            color: textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.7),
            fontSize: 13,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
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
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: suffixIcon,
                  )
                : null,
            ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}