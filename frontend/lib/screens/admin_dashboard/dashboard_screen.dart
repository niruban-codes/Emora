import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131429), // Deep Midnight Blue
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Admin Dashboard", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome Back, Admin!", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
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
              childAspectRatio: 1.6,
              children: [
                _buildStatCard("Active Users", "5,320", "Online now", Icons.person, const Color(0xFF6C5CE7)),
                _buildStatCard("Song Sessions", "780", "", Icons.music_note, const Color(0xFFD43FB1)),
                _buildStatCard("Avg. Session", "18m 43s", "", Icons.timer_outlined, Colors.purple),
                _buildStatCard("Reports Pending", "12", "▲ +30", Icons.warning_rounded, Colors.orangeAccent, isTrend: true),
              ],
            ),
            
            const SizedBox(height: 20),

            // 2. MIDDLE CHARTS ROW
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT: EMOTION STATS
                Expanded(child: _buildEmotionDonutCard()),
                const SizedBox(width: 15),
                // RIGHT: WEEKLY ACTIVITY + GENRE DONUT
                Expanded(child: _buildListeningMiniCard()),
              ],
            ),

            const SizedBox(height: 20),

            // 3. RECENT ACTIVITY SECTION
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

  Widget _buildEmotionDonutCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 260,
      decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const Align(alignment: Alignment.centerLeft, child: Text("Quick Emotion Stats", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white))),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(PieChartData(sectionsSpace: 0, centerSpaceRadius: 40, sections: [
                  PieChartSectionData(color: Colors.orange, value: 34, radius: 12, showTitle: false),
                  PieChartSectionData(color: const Color(0xFF00FFCC), value: 22, radius: 12, showTitle: false),
                  PieChartSectionData(color: Colors.purpleAccent, value: 13, radius: 12, showTitle: false),
                  PieChartSectionData(color: Colors.redAccent, value: 15, radius: 12, showTitle: false),
                  PieChartSectionData(color: Colors.deepOrange, value: 16, radius: 12, showTitle: false),
                ])),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Happy", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                    Text("34%", style: TextStyle(fontSize: 10, color: Colors.white54)),
                  ],
                )
              ],
            ),
          ),
          const Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [_legend(Colors.orange, "Happy 34%"), SizedBox(width: 8), _legend(Color(0xFF00FFCC), "Calm 22%")]),
              SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [_legend(Colors.purpleAccent, "Relax 13%"), SizedBox(width: 8), _legend(Colors.redAccent, "Sad 15%")]),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildListeningMiniCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 260,
      decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Weekly Activity", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: LineChart(LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [const FlSpot(0, 2), const FlSpot(1, 4), const FlSpot(2, 3), const FlSpot(3, 5), const FlSpot(4, 4)],
                  isCurved: true,
                  color: const Color(0xFF00FFCC),
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                )
              ],
            )),
          ),
          const Divider(color: Colors.white10, height: 20),
          const Text("Genre Breakdown", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(PieChartData(sectionsSpace: 0, centerSpaceRadius: 20, sections: [
                    PieChartSectionData(color: const Color(0xFFD43FB1), value: 50, radius: 8, showTitle: false),
                    PieChartSectionData(color: const Color(0xFF6C5CE7), value: 30, radius: 8, showTitle: false),
                    PieChartSectionData(color: const Color(0xFF00FFCC), value: 20, radius: 8, showTitle: false),
                  ])),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _miniLegend(Color(0xFFD43FB1), "Pop"),
                    _miniLegend(Color(0xFF6C5CE7), "HipHop"),
                    _miniLegend(Color(0xFF00FFCC), "R&B"),
                  ],
                )
              ],
            ),
          )
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