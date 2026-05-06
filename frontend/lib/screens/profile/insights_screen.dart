import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; //  added

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  static const Color bgColor = Color(0xFF13112B);
  static const Color cardBg = Color(0xFF1D1B3E);
  static const Color pinkAccent = Color(0xFFE598D0);
  static const Color textCream = Color(0xFFF4EBEB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Color(0xFF2D2B55),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 18),
          ),
          onPressed: () => context.pop(), //  go_router pop
        ),
        title: const Text(
          "Insights",
          style: TextStyle(
            color: textCream,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Weekly Mood Trend",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "How you've been feeling this week",
              style: TextStyle(color: Colors.white54, fontSize: 15),
            ),
            const SizedBox(height: 25),
            _buildMostFrequentCard(),
            const SizedBox(height: 25),
            _buildMoodLogCard(
              icon: Icons.eco,
              mood: "Peaceful",
              time: "TODAY, 2:45 PM",
              mixName: "Morning Zen & Lo-fi Chill",
              mixColor: Colors.tealAccent,
            ),
            _buildMoodLogCard(
              icon: Icons.celebration,
              mood: "Happy",
              time: "PEAK: MORNINGS",
              mixName: "Golden Hour Energy",
              mixColor: Colors.pinkAccent,
            ),
            _buildMoodLogCard(
              icon: Icons.water_drop,
              mood: "Melancholy",
              time: "PEAK: AFTERNOONS",
              mixName: "Rainy Day Acoustic Essentials",
              mixColor: Colors.blueAccent,
            ),
            const SizedBox(height: 25),
            const Text(
              "Deep Insights",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildDeepInsightCard(),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Top Mood-Boosting Tracks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "View All",
                  style: TextStyle(
                    color: pinkAccent.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTrackTile(
              "Midnight City",
              "M83 • Synthesized Euphoria",
              "+1.2 Mood",
              [const Color(0xFF8E248D), const Color(0xFFC06CFF)],
            ),
            _buildTrackTile("Starlight", "Muse • High Energy", "+0.8 Mood", [
              const Color(0xFF3F51B5),
              const Color(0xFF2196F3),
            ]),
            _buildTrackTile(
              "Levitating",
              "Dua Lipa • Dance Vibes",
              "+0.7 Mood",
              [const Color(0xFFFF7E5F), const Color(0xFFFEB47B)],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMostFrequentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1738),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Most Frequent",
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Peaceful",
                style: TextStyle(
                  color: Color(0xFFA555EC),
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: Color(0xFF1DB954), size: 18),
                    SizedBox(width: 6),
                    Text(
                      "12%",
                      style: TextStyle(
                        color: Color(0xFF1DB954),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodLogCard({
    required IconData icon,
    required String mood,
    required String time,
    required String mixName,
    required Color mixColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: mixColor.withOpacity(0.1),
              child: Icon(icon, color: mixColor, size: 20),
            ),
            title: Text(
              mood,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              time,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            trailing: const Icon(Icons.more_vert, color: Colors.white54),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: mixColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "RECOMMENDED MIX",
                        style: TextStyle(
                          color: pinkAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        mixName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white70,
                  size: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeepInsightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2B55),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.coffee_outlined,
              color: pinkAccent,
              size: 28,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Caffeine Sensitivity",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Anxiety peaks noted 2 hours after caffeine intake.",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackTile(
    String title,
    String sub,
    String moodImpact,
    List<Color> gradient,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            moodImpact,
            style: const TextStyle(
              color: pinkAccent,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
