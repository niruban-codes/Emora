import 'package:flutter/material.dart';

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

// --- Colors from the UI ---
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
        title: const Text("Insights", style: TextStyle(color: Colors.white, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: kHappyColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Weekly Mood Trend", 
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("How you've been feeling this week", 
                style: TextStyle(color: Colors.grey[400], fontSize: 14)),
            const SizedBox(height: 20),
            
            _buildWeeklyTrendCard(),
            
            const SizedBox(height: 30),
            const Text("Top Moods", 
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            _buildMoodProgress("Peaceful", 0.4, kPeacefulColor),
            _buildMoodProgress("Happy", 0.3, kHappyColor),
            _buildMoodProgress("Melancholy", 0.2, kMelancholyColor),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Recent History", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text("View All", style: TextStyle(color: kHappyColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            
            _buildHistoryCard("Peaceful", "TODAY, 2:45 PM", "Morning Zen & Lo-fi Chill", kPeacefulColor),
            _buildHistoryCard("Happy", "YESTERDAY, 6:12 PM", "Golden Hour Energy", kHappyColor),
            _buildHistoryCard("Melancholy", "OCT 24, 9:00 AM", "Rainy Day Acoustic Essentials", kMelancholyColor),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBgColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kHappyColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "SEARCH"),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: "INSIGHTS"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "PROFILE"),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Most Frequent", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text("Peaceful", style: TextStyle(color: kHappyColor, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Row(children: const [Icon(Icons.trending_up, color: Colors.green, size: 16), Text(" 12%", style: TextStyle(color: Colors.green))]),
              )
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: CustomPaint(painter: CurvePainter()),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
                .map((d) => Text(d, style: TextStyle(color: d == "THU" ? kHappyColor : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold))).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildMoodProgress(String label, double value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCardColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1), 
            child: Icon(Icons.sentiment_satisfied_alt, color: color)
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("${(value * 100).toInt()}%", style: const TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: value,
                    backgroundColor: kInactiveColor,
                    color: color,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String mood, String time, String track, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCardColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(mood == "Peaceful" ? Icons.eco : Icons.water_drop, color: color),
            title: Text(mood, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            trailing: const Icon(Icons.more_vert, color: Colors.grey),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: kBgColor.withOpacity(0.6), borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Container(
                  width: 40, 
                  height: 40, 
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color.withOpacity(0.5), color]),
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("RECOMMENDED MIX", style: TextStyle(color: kHappyColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text(track, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_fill, color: kHappyColor, size: 32),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = kHappyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.9, size.width * 0.4, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.1, size.width * 0.75, size.height * 0.8);
    path.lineTo(size.width, size.height * 0.6);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}