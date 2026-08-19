import 'package:flutter/material.dart';
import '/api_service.dart';

class AdminControlScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;
  const AdminControlScreen({super.key, this.onBackToDashboard});

  @override
  State<AdminControlScreen> createState() => _AdminControlScreenState();
}

class _AdminControlScreenState extends State<AdminControlScreen> {
  late Future<List<dynamic>> _quickStatsFuture;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    _quickStatsFuture = Future.wait([
      ApiService().getAdminStats(),
      ApiService().getAdminLogs(),
      ApiService().getAdminMusicStats(),
    ]);
  }

  void _showAddLogDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF252648),
        title: const Text(
          "Record Admin Action",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter action details...",
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6C5CE7)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
            ),
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                final action = controller.text.trim();
                Navigator.pop(ctx);
                final success = await ApiService().createAdminLog(action);
                if (mounted && success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Action logged successfully!"),
                    ),
                  );
                  setState(() => _loadStats()); // Refresh stats to show new log
                }
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0C1D),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Admin Controls",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.onBackToDashboard != null) {
              widget.onBackToDashboard!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. QUICK STATS
            FutureBuilder<List<dynamic>>(
              future: _quickStatsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                  );
                }

                final stats =
                    (snapshot.data?[0] as Map<String, dynamic>?) ?? {};
                final logs = (snapshot.data?[1] as List<dynamic>?) ?? [];
                final music =
                    (snapshot.data?[2] as Map<String, dynamic>?) ?? {};
                final mostPlayed = (music['most_played'] as List?) ?? [];

                final totalUsers = "${stats['total_users'] ?? '--'}";
                final totalDetections = "${stats['total_detections'] ?? '--'}";
                final totalLogs = "${logs.length}";
                final topTracks = "${mostPlayed.length}";

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Quick Stats",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.1,
                      children: [
                        _buildSmallStatCard(
                          totalUsers,
                          "Total Users",
                          Icons.people_alt_rounded,
                          Colors.blueAccent,
                        ),
                        _buildSmallStatCard(
                          totalDetections,
                          "Face Scans",
                          Icons.face_rounded,
                          Colors.redAccent,
                        ),
                        _buildSmallStatCard(
                          topTracks,
                          "Charted Songs",
                          Icons.music_note_rounded,
                          Colors.orangeAccent,
                        ),
                        _buildSmallStatCard(
                          totalLogs,
                          "Admin Logs",
                          Icons.history_rounded,
                          Colors.greenAccent,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 25),

            // 2. USER MANAGEMENT SECTION
            _buildMenuSection("User Management", [
              _buildMenuTile(
                Icons.person,
                Colors.purpleAccent,
                "Manage Users",
                "View, edit or remove user accounts",
              ),
              _buildMenuTile(
                Icons.vpn_key_rounded,
                Colors.pinkAccent,
                "Roles & Permissions",
                "Set user roles and access levels",
              ),
            ]),

            // 3. ADMIN ACTIONS SECTION
            _buildMenuSection("Admin Actions", [
              _buildMenuTile(
                Icons.post_add_rounded,
                Colors.pink,
                "Record Action Log",
                "Post new admin log entry to Firestore",
                onTap: _showAddLogDialog,
              ),
              _buildMenuTile(
                Icons.notifications_active,
                Colors.purple,
                "Notification Settings",
                "Manage admin notifications",
              ),
            ]),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // UI WIDGETS

  Widget _buildSmallStatCard(
    String val,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF252648),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                val,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white54),
          ),
        ],
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
          decoration: BoxDecoration(
            color: const Color(0xFF252648).withOpacity(0.5),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: const BoxDecoration(
            color: Color(0xFF252648),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
          ),
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget _buildMenuTile(
    IconData icon,
    Color iconColor,
    String title,
    String sub, {
    String? badge,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        sub,
        style: const TextStyle(fontSize: 9, color: Colors.white38),
      ),
      trailing: SizedBox(
        width: badge != null ? 140 : 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white24,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
