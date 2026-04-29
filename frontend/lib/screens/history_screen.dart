import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 👈 added

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const Color bgColor = Color(0xFF13112B);
  static const Color cardBg = Color(0xFF1D1B3E);
  static const Color pinkAccent = Color(0xFFE598D0);
  static const Color purpleAccent = Color(0xFF8E248D);
  static const Color chipActive = Color(0xFF7986CB);

  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    "All",
    "Happy",
    "Sad",
    "Melancholic",
    "Energetic",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () => context.pop(), // 👈 go_router pop
        ),
        title: const Text(
          "History",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildFilterBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _sectionHeader("Today", showViewAll: true),
                _buildHistoryCard(
                  mood: "Peaceful",
                  time: "TODAY, 2:45 PM",
                  trackName: "Neon Sunsets & Lo-fi Chill",
                  subText: "MEDITATION SESSION",
                  moodIcon: Icons.eco_outlined,
                  iconColor: Colors.tealAccent,
                  trackImage: Icons.wb_twilight,
                ),
                _buildHistoryCard(
                  mood: "Energetic",
                  time: "TODAY, 11:20 AM",
                  trackName: "Pulse of Night Energy",
                  subText: "BOOSTED YOUR FOCUS",
                  moodIcon: Icons.bolt,
                  iconColor: Colors.purpleAccent,
                  trackImage: Icons.graphic_eq,
                ),
                _sectionHeader("Yesterday"),
                _buildHistoryCard(
                  mood: "Happy",
                  time: "YESTERDAY, 6:12 PM",
                  trackName: "Golden Hour Vibes",
                  subText: "YOU WERE FEELING HAPPY",
                  moodIcon: Icons.celebration_outlined,
                  iconColor: Colors.deepPurpleAccent,
                  trackImage: Icons.wb_sunny_outlined,
                ),
                _sectionHeader("Earlier"),
                _buildHistoryCard(
                  mood: "Melancholy",
                  time: "OCT 24, 9:00 AM",
                  trackName: "Rainy Day Acoustic",
                  subText: "RECOMMENDED MIX",
                  moodIcon: Icons.water_drop_outlined,
                  iconColor: Colors.blueAccent,
                  trackImage: Icons.park,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? chipActive : cardBg.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Center(
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title, {bool showViewAll = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showViewAll)
            const Text(
              "View All",
              style: TextStyle(
                color: pinkAccent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard({
    required String mood,
    required String time,
    required String trackName,
    required String subText,
    required IconData moodIcon,
    required Color iconColor,
    required IconData trackImage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor.withOpacity(0.1),
                radius: 18,
                child: Icon(moodIcon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mood,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white38),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(trackImage, color: Colors.orangeAccent),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trackName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subText,
                        style: const TextStyle(
                          color: purpleAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white70,
                  size: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Navigation (UPDATED) ────────────────────────────────────────────
}
