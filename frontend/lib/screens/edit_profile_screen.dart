import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  bool dailyMood = false;
  bool weeklyAnalytics = false;
  bool newRecommendations = false;
  bool playlistUpdates = false;
  bool promotions = false;
  bool securityAlerts = false;

  Widget buildSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children:[
              Icon(icon, color: Color(0xFFE040FB), size: 18),
              const SizedBox(width: 8),
              Text(
            
            title,
            style: const TextStyle(
              color: Color(0xFFE040FB),
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A1F55),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget buildSwitchTile(
      String title,
      String subtitle,
      bool value,
      Function(bool) onChanged,
      ) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white60),
      ),
      value: value,
      activeColor: Colors.pinkAccent,
      onChanged: (val) {
        setState(() {
          onChanged(val);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B2E),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0B2E),
        elevation: 0,
        leading: const Icon(Icons.arrow_back),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.more_vert, color: Colors.white),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Mood Alerts
            buildSection("MOOD ALERTS", Icons.mood, [
              buildSwitchTile(
                "Daily Mood Check-in",
                "Get a reminder to log your daily mood",
                dailyMood,
                    (val) => dailyMood = val,
              ),
              buildSwitchTile(
                "Weekly Analytics",
                "A summary of your emotional music journey",
                weeklyAnalytics,
                    (val) => weeklyAnalytics = val,
              ),
            ]),

            const SizedBox(height: 20),

            /// Playlist Updates
            buildSection("PLAYLIST UPDATES", Icons.queue_music, [
              buildSwitchTile(
                "New Recommendations",
                "When we find music that matches your vibe",
                newRecommendations,
                    (val) => newRecommendations = val,
              ),
              buildSwitchTile(
                "Saved Playlist Updates",
                "Notifications when tracks are added to followed lists",
                playlistUpdates,
                    (val) => playlistUpdates = val,
              ),
            ]),

            const SizedBox(height: 20),

            /// Account & General
            buildSection("ACCOUNT & GENERAL", Icons.settings, [
              buildSwitchTile(
                "Promotions",
                "Exclusive offers and Emora Premium news",
                promotions,
                    (val) => promotions = val,
              ),
              buildSwitchTile(
                "Security Alerts",
                "Important notices about your account security",
                securityAlerts,
                    (val) => securityAlerts = val,
              ),
            ]),

            const SizedBox(height: 24),

            /// Premium Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF9C27B0),
                    Color(0xFFE040FB),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Emora Premium",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Experience music without boundaries.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.white)
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D0B2E),
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Mood",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}