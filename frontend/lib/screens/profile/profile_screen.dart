import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 👈 added
import '../../../services/firestore_service.dart'; // 👈 added

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  static const Color bgColor = Color(0xFF15173D);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color cardColor = Color(0xFF1E1A35);
  static const Color textSecondary = Colors.white38;
  static const Color logoutRedBg = Color(0xFF3B1E2B);
  static const Color logoutTextRed = Color(0xFFEF5350);
  static const Color activeHighlight = Color(0xFFA7338A);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

//  Added the State class
class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String userName = "Loading...";
  String userEmail = "";
  // Define your hardcoded admin emails
  final List<String> _adminEmails = [
    'niru2324@gmail.com', // Replace with your actual admin email
    'admin@emora.com',
  ];

  // Check if the current logged-in user is an admin
  bool get _isAdmin {
    final user = FirebaseAuth.instance.currentUser;
    return user != null &&
        user.email != null &&
        _adminEmails.contains(user.email!.toLowerCase());
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = await FirestoreService().getUserProfile(user.uid);
      if (data != null && mounted) {
        setState(() {
          userName = data['name'] ?? "No Name";
          userEmail = data['email'] ?? user.email ?? "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileSettingsScreen.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildProfileHeader(),
            const SizedBox(height: 30),

            _buildSectionLabel('ACCOUNT SETTINGS'),
            _buildSimpleTile(context, Icons.person_outline, 'Edit Profile'),
            _buildSimpleTile(context, Icons.trending_up, 'Insights'),
            _buildSimpleTile(
              context,
              Icons.sentiment_satisfied_alt_outlined,
              'Mood Analytics',
            ),

            const SizedBox(height: 25),
            _buildSectionLabel('MUSIC INTEGRATION'),
            _buildIntegrationCard(
              'Spotify',
              'Connected as @sarahj_music',
              'Disconnect',
              Icons.grid_view_rounded,
              true,
            ),
            const SizedBox(height: 12),
            _buildIntegrationCard(
              'Connect YouTube Music',
              '',
              '+',
              Icons.play_circle_fill,
              false,
            ),

            const SizedBox(height: 25),
            _buildSectionLabel('APP PREFERENCES'),
            _buildSwitchTile(
              Icons.notifications_none,
              'Push Notifications',
              true,
            ),

            const SizedBox(height: 30),
            if (_isAdmin) _buildAdminCard(context),

            const SizedBox(height: 30),
            _buildLogoutButton(context), // 👈 now signs out from Firebase

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ProfileSettingsScreen.accentPurple,
                  width: 3,
                ),
              ),
              child: const CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(
                  'https://i.imgur.com/8Km9t9S.png',
                ),
              ),
            ),
            const CircleAvatar(
              radius: 16,
              backgroundColor: ProfileSettingsScreen.accentPurple,
              child: Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          userName, // 👈 Uses the variable from Firestore
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          userEmail, // 👈 Uses the variable from Firestore
          style: const TextStyle(
            color: ProfileSettingsScreen.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          label,
          style: const TextStyle(
            color: ProfileSettingsScreen.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: _iconBox(icon),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: ProfileSettingsScreen.textSecondary,
      ),
      onTap: () async {
        // 👈 Added async
        if (title == 'Edit Profile') {
          // 1. Wait for the user to return from Account Settings
          await context.push('/account-settings');

          // 2. Refresh data from Firestore automatically
          _fetchUserData();
        } else if (title == 'Insights') {
          context.push('/insights');
        } else if (title == 'Mood Analytics') {
          context.push('/mood-analytics');
        }
      },
    );
  }

  Widget _buildIntegrationCard(
    String title,
    String sub,
    String action,
    IconData icon,
    bool connected,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ProfileSettingsScreen.cardColor, // 👈 1. Added Prefix
        borderRadius: BorderRadius.circular(15),
        border: connected ? null : Border.all(color: Colors.white10, width: 1),
      ),
      child: Row(
        children: [
          _iconBox(icon),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (sub.isNotEmpty)
                  Text(
                    sub,
                    // 👈 2. Added Prefix & removed 'const'
                    style: const TextStyle(
                      color: ProfileSettingsScreen.textSecondary,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            action,
            // 👈 3. Added Prefix & removed 'const'
            style: TextStyle(
              color: connected
                  ? ProfileSettingsScreen.textSecondary
                  : Colors.white,
              fontSize: connected ? 12 : 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: _iconBox(icon),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      trailing: Switch(
        value: value,
        onChanged: (v) {},
        activeColor: ProfileSettingsScreen.accentPurple,
      ),
    );
  }

  // ── Admin Dashboard Card ──────────────────────────────────────────────────
  Widget _buildAdminCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/admin-dashboard'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE53935),
              Color(0xFFB71C1C),
            ], // Admin Red Gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage users, music, and platform analytics.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            Icon(Icons.admin_panel_settings, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }

  // ── Logout Button with Firebase Sign Out ──────────────────────────────────
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: ProfileSettingsScreen.logoutRedBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton.icon(
        onPressed: () async {
          // 1. Show confirmation dialog
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF1E1A35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                'Are you sure you want to log out?',
                style: TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0xFFEF5350),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );

          // 2. If confirmed sign out from Firebase and navigate to login
          if (confirm == true) {
            await FirebaseAuth.instance
                .signOut(); // 👈 actual Firebase sign out
            if (context.mounted) context.go('/login');
          }
        },
        icon: Icon(
          Icons.logout,
          color: ProfileSettingsScreen.logoutTextRed,
          size: 20,
        ),
        label: Text(
          'Log Out',
          style: TextStyle(
            color: ProfileSettingsScreen.logoutTextRed,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: ProfileSettingsScreen.accentPurple, size: 20),
    );
  }
}
