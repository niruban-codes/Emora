import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  final String _currentUid =
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_user';

  static const Color bgColor = Color(0xFF0D0C1D);
  static const Color cardBg = Color(0xFF1D1B3E);
  static const Color pinkAccent = Color(0xFFE598D0);
  static const Color purpleAccent = Color(0xFF8E248D);
  static const Color chipActive = Color(0xFFAB47BC);

  int _selectedFilterIndex = 0;
  late Future<List<dynamic>?> _moodHistoryFuture;
  final List<String> _filters = [
    "All",
    "Happy",
    "Sad",
    "Neutral",
    "Fear",
    "Anger",
    "Surprised",
  ];

  @override
  void initState() {
    super.initState();
    _moodHistoryFuture = _apiService.getMoodHistoryFromAzure(_currentUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          "History",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
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
            child: FutureBuilder<List<dynamic>?>(
              future: _moodHistoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFCE93D8)),
                  );
                }

                if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No scan logs recorded yet.\nTry scanning your face!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                final rawList = snapshot.data!;
                final filteredList = rawList.where((log) {
                  if (_selectedFilterIndex == 0) return true;
                  String selectedMoodName = _filters[_selectedFilterIndex]
                      .toLowerCase();
                  String currentLogMood = (log['emotion'] ?? '')
                      .toString()
                      .toLowerCase();
                  return currentLogMood == selectedMoodName;
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      "No history logs found for ${_filters[_selectedFilterIndex]}",
                      style: GoogleFonts.poppins(
                        color: Colors.white38,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final log = filteredList[index];
                    final String detectedMood = log['emotion'] ?? 'Neutral';
                    final String timestamp = log['timestamp'] ?? '';
                    final List<dynamic> tracks = log['tracks'] ?? [];
                    final String trackName = tracks.isNotEmpty
                        ? (tracks[0]['title'] ??
                              tracks[0]['name'] ??
                              'Recommended Track Mix')
                        : 'Custom Vibe Playlist';

                    final String subText = "Generated ${tracks.length} tracks";
                    IconData moodIcon = Icons.lens_blur_rounded;
                    Color iconColor = const Color(0xFF78909C);

                    switch (detectedMood.toLowerCase()) {
                      case 'happy':
                        moodIcon = Icons.sentiment_very_satisfied_rounded;
                        iconColor = const Color(0xFFFFB347);
                        break;
                      case 'sad':
                        moodIcon = Icons.sentiment_dissatisfied_rounded;
                        iconColor = const Color(0xFF42A5F5);
                        break;
                      case 'fear':
                        moodIcon = Icons.sentiment_very_dissatisfied_outlined;
                        iconColor = const Color(0xFF7E57C2);
                        break;
                      case 'angry':
                      case 'anger':
                        moodIcon = Icons.local_fire_department_outlined;
                        iconColor = const Color(0xFFE57373);
                        break;
                      case 'surprise':
                      case 'surprised':
                        moodIcon = Icons.flare_rounded;
                        iconColor = const Color(0xFF4DB6AC);
                        break;
                    }

                    return _buildHistoryCard(
                      mood: detectedMood,
                      time: timestamp.length > 16
                          ? timestamp.substring(0, 16).replaceAll('T', ' ')
                          : timestamp,
                      trackName: trackName,
                      subText: subText,
                      moodIcon: moodIcon,
                      iconColor: iconColor,
                      trackImage: Icons.music_note_rounded,
                    );
                  },
                );
              },
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
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
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
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showViewAll)
            Text(
              "View All",
              style: GoogleFonts.poppins(
                color: pinkAccent,
                fontSize: 13,
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
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
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
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subText,
                        style: GoogleFonts.poppins(
                          color: purpleAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
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
}
