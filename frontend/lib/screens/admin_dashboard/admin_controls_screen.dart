import 'package:flutter/material.dart';

class AdminControlScreen extends StatelessWidget {
  const AdminControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0C1D),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Admin Controls", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. QUICK STATS 
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("Quick Stats", style: TextStyle(color: Colors.white70, fontSize: 13)),
            ),
            Row(
              children: [
                _buildSmallStatCard("22,450", "Active Users", Icons.people_alt_rounded, Colors.blueAccent),
                _buildSmallStatCard("85", "Songs Uploaded", Icons.music_note_rounded, Colors.redAccent),
                _buildSmallStatCard("15", "Reports Pending", Icons.warning_rounded, Colors.orangeAccent),
                _buildSmallStatCard("589k", "Streams Today", Icons.bar_chart_rounded, Colors.greenAccent),
              ],
            ),
            const SizedBox(height: 25),

            // 2. USER MANAGEMENT SECTION
            _buildMenuSection("User Management", [
              _buildMenuTile(Icons.person, Colors.purpleAccent, "Manage Users", "View, edit or remove user accounts"),
              _buildMenuTile(Icons.vpn_key_rounded, Colors.pinkAccent, "Roles & Permissions", "Set user roles and access levels"),
            ]),

            // 3. CONTENT MODERATION SECTION
            _buildMenuSection("Content Moderation", [
              _buildMenuTile(
                Icons.verified_user_rounded, Colors.indigoAccent, "Moderate Content", "Review and manage reported content",
                badge: "Moderation Queue 3",
              ),
              _buildMenuTile(Icons.settings_outlined, Colors.deepPurpleAccent, "Moderation Settings", "Automate content filtering"),
            ]),

            // 4. APP SETTINGS SECTION
            _buildMenuSection("App Settings", [
              _buildMenuTile(Icons.settings, Colors.pink, "General Settings", "Update app preferences and configurations"),
              _buildMenuTile(Icons.notifications_active, Colors.purple, "Notification Settings", "Manage admin notifications"),
              _buildMenuTile(Icons.monetization_on_rounded, Colors.deepPurple, "Subscription Settings", "Control subscription plans and payments"),
            ]),

            // 5. REPORTS & LOGS SECTION
            _buildMenuSection("Reports & Logs", [
              _buildMenuTile(Icons.show_chart_rounded, Colors.purpleAccent, "Usage Reports", "View detailed usage analytics"),
              _buildMenuTile(Icons.bar_chart_rounded, Colors.indigo, "Analytics Dashboard", "View and analyze platform performance"),
              _buildMenuTile(Icons.assignment_rounded, Colors.pinkAccent, "Audit Vlogs", "Track admin actions and changes"),
              _buildMenuTile(
                Icons.report_problem_rounded, Colors.purple, "Reports & Moderation", "Moderate reported content and users",
                badge: "Pending 10",
              ),
            ]),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // UI WIDGETS

  Widget _buildSmallStatCard(String val, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 14),
                const SizedBox(width: 4),
                Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 8, color: Colors.white54)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(color: const Color(0xFF252648).withOpacity(0.5), borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: const BoxDecoration(color: Color(0xFF252648), borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, Color iconColor, String title, String sub, {String? badge}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 9, color: Colors.white38)),
      trailing: SizedBox(
        width: badge != null ? 140 : 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
                child: Text(badge, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white70)),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }
}