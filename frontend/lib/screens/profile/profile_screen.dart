import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../services/firestore_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  static const Color bgColor = Color(0xFF15173D);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color cardColor = Color(0xFF1E1A35);
  static const Color textSecondary = Colors.white38;
  static const Color logoutRedBg = Color(0xFF3B1E2B);
  static const Color logoutTextRed = Color(0xFFEF5350);
  static const Color activeHighlight = Color(0xFFA7338A);
  static const Color dashboardButtonColor = Color(0xFF9C27B0);
  static const Color dashboardGradientEnd = Color(0xFF673AB7);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String userName = "Loading...";
  String userEmail = "";
  String? profilePicUrl;

  // hardcoded admin emails
  final List<String> _adminEmails = [
    'niru2324@gmail.com',
    'sparkswills40@gmail.com',
    'admin@emora.com',
    'geethmapiyaratne285@gmail.com',
    'nirubannallirajah@gmail.com',
    'hafsanafli2003@gmail.com',
    'dinithia962@gmail.com',
  ];
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
          profilePicUrl = data['profilePicUrl'];
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
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          'Profile Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
            _buildSectionLabel('APP PREFERENCES'),
            _buildSwitchTile(
              Icons.notifications_none,
              'Push Notifications',
              true,
            ),

            const SizedBox(height: 30),
            if (_isAdmin) _buildAdminCard(context),

            const SizedBox(height: 30),
            _buildLogoutButton(context),

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
              child: profilePicUrl != null && profilePicUrl!.isNotEmpty
                  ? (profilePicUrl!.startsWith('assets/')
                        ? CircleAvatar(
                            radius: 55,
                            backgroundColor: ProfileSettingsScreen.cardColor,
                            backgroundImage: AssetImage(profilePicUrl!),
                            onBackgroundImageError: (_, __) {
                              debugPrint(
                                "Failed to load local asset avatar path.",
                              );
                            },
                          )
                        : CircleAvatar(
                            radius: 55,
                            backgroundColor: ProfileSettingsScreen.cardColor,
                            child: CachedNetworkImage(
                              imageUrl: profilePicUrl!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(
                                    color: ProfileSettingsScreen.accentPurple,
                                  ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ))
                  : const CircleAvatar(
                      radius: 55,
                      backgroundColor: ProfileSettingsScreen.cardColor,
                      backgroundImage: AssetImage('assets/avatars/Girl 07.png'),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          userName,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          userEmail,
          style: GoogleFonts.poppins(
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
        padding: const EdgeInsets.only(bottom: 12, top: 12),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.3,
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
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: ProfileSettingsScreen.textSecondary,
      ),
      onTap: () async {
        if (title == 'Edit Profile') {
          await context.push('/account-settings');
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
        color: ProfileSettingsScreen.cardColor,
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
                    style: GoogleFonts.poppins(
                      color: ProfileSettingsScreen.textSecondary,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            action,
            style: GoogleFonts.poppins(
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
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: (v) {},
        activeColor: ProfileSettingsScreen.accentPurple,
      ),
    );
  }

  // Admin Dashboard Card
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
              ProfileSettingsScreen.dashboardButtonColor,
              ProfileSettingsScreen.dashboardGradientEnd,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Dashboard',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage users, music, and platform analytics.',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            Icon(Icons.admin_panel_settings, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }

  //  Logout Button with Firebase Sign Out
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
                  fontSize: 16,
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

          if (confirm == true) {
            await FirebaseAuth.instance.signOut();
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
          style: GoogleFonts.poppins(
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
