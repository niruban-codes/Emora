import 'package:flutter/material.dart';
//import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback? onExitAdmin; 
  const DashboardScreen({super.key, this.onExitAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Admin Dashboard", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (onExitAdmin != null) {
              onExitAdmin!(); // Safely triggers the pop action from the wrapper level
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome Back, Admin!", 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text("Overview of system activity", 
              style: TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(height: 20),
            
            // 1. TOP STATS GRID
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard("Active Users", "5,320", "Online now", Icons.person, const Color(0xFF6C5CE7)),
                _buildStatCard("Song Sessions", "780", "", Icons.music_note, const Color(0xFFD43FB1)),
                _buildStatCard("Avg. Session", "18m 43s", "", Icons.timer_outlined, Colors.purple),
                _buildStatCard("Reports Pending", "12", "▲ +30", Icons.warning_rounded, Colors.orangeAccent, isTrend: true),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 2. RECENT ACTIVITY SECTION
            _buildRecentActivitySection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String sub, IconData icon, Color color, {bool isTrend = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF252648),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (isTrend)
            Text(sub, style: const TextStyle(fontSize: 10, color: Color(0xFF00FFCC), fontWeight: FontWeight.bold))
          else if (sub.isNotEmpty)
            Text(sub, style: const TextStyle(fontSize: 9, color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recent Activity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 15),
          _activityItem("Ryan started a new session.", "15 mins ago", Colors.yellow),
          const Divider(color: Colors.white10),
          _activityItem("3 new emotion playlists generated.", "53 mins ago", const Color(0xFF00FFCC)),
          const Divider(color: Colors.white10),
          _activityItem("New user Sarah activated.", "3 hours ago", Colors.redAccent),
        ],
      ),
    );
  }

  Widget _activityItem(String text, String time, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: dotColor),
          const SizedBox(width: 15),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.white))),
          Text(time, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }
}

// Helper Widgets
class _legend extends StatelessWidget {
  final Color col; final String txt;
  const _legend(this.col, this.txt);
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    CircleAvatar(radius: 3, backgroundColor: col), const SizedBox(width: 4),
    Text(txt, style: const TextStyle(fontSize: 9, color: Colors.white70)),
  ]);
}

class _miniLegend extends StatelessWidget {
  final Color color; final String label;
  const _miniLegend(this.color, this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(children: [
      Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 8, color: Colors.white60)),
    ]),
  );
}