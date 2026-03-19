import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MoodApp());
}

class MoodApp extends StatelessWidget {
  const MoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MoodInsightsPage(),
    );
  }
}

// --- Colors from your UI ---
const Color kBgColor = Color(0xFF130B2B);
const Color kCardColor = Color(0xFF22183D);
const Color kPeacefulColor = Color(0xFF1DB954);
const Color kHappyColor = Color(0xFFC13584);
const Color kMelancholyColor = Color(0xFF4A90E2);
const Color kInactiveColor = Color(0xFF332A4D);

class MoodInsightsPage extends StatelessWidget {
  const MoodInsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text("Insights", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.calendar_month_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Weekly Mood Trend", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("How you've been feeling this week", style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 20),
            
            _buildTrendCard(),
            
            const SizedBox(height: 30),
            const Text("Top Moods", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            _buildMoodBar("Peaceful", 0.40, kPeacefulColor, Icons.sentiment_satisfied_alt),
            _buildMoodBar("Happy", 0.30, kHappyColor, Icons.sentiment_very_satisfied),
            _buildMoodBar("Melancholy", 0.20, kMelancholyColor, Icons.sentiment_dissatisfied),
            
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recent History", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("View All", style: TextStyle(color: kHappyColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            
            _buildHistoryItem("Peaceful", "TODAY, 2:45 PM", "Morning Zen & Lo-fi Chill", kPeacefulColor),
            _buildHistoryItem("Happy", "YESTERDAY, 6:12 PM", "Golden Hour Energy", kHappyColor),
            const SizedBox(height: 30),
          ],
        ),
      ),
      
      // --- UPDATED BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kBgColor,
        selectedItemColor: kHappyColor,
        unselectedItemColor: Colors.white38,
        currentIndex: 4, // Sets 'Profile' as the active tab
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "EXPLORE"),
          BottomNavigationBarItem(icon: Icon(Icons.library_music_outlined), label: "LIBRARY"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "HISTORY"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "PROFILE"),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTrendCard() {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Most Frequent", style: TextStyle(color: Colors.white54, fontSize: 14)),
                  Text("Peaceful", style: TextStyle(color: kHappyColor, fontSize: 26, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                child: const Text("↗ 12%", style: TextStyle(color: kPeacefulColor, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        const days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
                        if (val < 0 || val >= days.length) return const SizedBox();
                        return Text(days[val.toInt()], 
                          style: TextStyle(color: val == 3 ? kHappyColor : Colors.white38, fontSize: 10, fontWeight: FontWeight.bold));
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [FlSpot(0,1), FlSpot(1,1.5), FlSpot(2,1.2), FlSpot(3,2.5), FlSpot(4,1.8), FlSpot(5,2.1), FlSpot(6,2)],
                    isCurved: true,
                    color: kHappyColor,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [kHappyColor.withOpacity(0.2), kHappyColor.withOpacity(0)],
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodBar(String label, double val, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: kInactiveColor, child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text("${(val * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(value: val, color: color, backgroundColor: kInactiveColor, minHeight: 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String mood, String time, String song, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCardColor, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.spa_outlined, color: color),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(mood, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ]),
              const Spacer(),
              const Icon(Icons.more_vert, color: Colors.white38),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("RECOMMENDED MIX", style: TextStyle(color: kHappyColor, fontSize: 9, fontWeight: FontWeight.bold)),
                  Text(song, style: const TextStyle(fontSize: 14)),
                ])),
                const Icon(Icons.play_circle_fill, color: Colors.white70),
              ],
            ),
          )
        ],
      ),
    );
  }
}