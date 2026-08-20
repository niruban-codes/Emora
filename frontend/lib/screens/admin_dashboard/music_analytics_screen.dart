import 'package:flutter/material.dart';
import '../../api_service.dart';
//import 'package:fl_chart/fl_chart.dart';

class MusicAnalyticsScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard; 
  const MusicAnalyticsScreen({super.key, this.onBackToDashboard});

  @override
  State<MusicAnalyticsScreen> createState() => _MusicAnalyticsScreenState();
}

  class _MusicAnalyticsScreenState extends State<MusicAnalyticsScreen> {
  late Future<Map<String, dynamic>> _musicFuture;

  @override
  void initState() {
    super.initState();
    _musicFuture = ApiService().getAdminMusicStats().then((val) => val ?? {});
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
        title: const Text("Music Analytics", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.onBackToDashboard != null) {
              widget.onBackToDashboard!(); // Navigates back to the Dashboard index
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _musicFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF6C5CE7)));
          }

          final data = snapshot.data ?? {};
          final mostPlayed = (data['most_played'] as List?) ?? [];
          final popularEmotions = (data['popular_emotions'] as List?) ?? [];

          final topTrackName = mostPlayed.isNotEmpty ? mostPlayed.first['title'] : 'N/A';
          final topTrackFavs = mostPlayed.isNotEmpty ? "${mostPlayed.first['playCount']} favs" : '0';
          final topEmotion = popularEmotions.isNotEmpty ? popularEmotions.first.toString().toUpperCase() : 'N/A';

          return RefreshIndicator(
            onRefresh: () async => setState(() {
              _musicFuture = ApiService().getAdminMusicStats().then((val) => val ?? {});
            }),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header("Listening Stats"),
                  GridView.count(
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.6,
                    children: [
                      _statCard("Top Emotion", topEmotion, Icons.psychology_rounded, const Color(0xFF2E3B62)),
                      _statCard("Tracks In Charts", "${mostPlayed.length}", Icons.queue_music_rounded, const Color(0xFF2E3B62)),
                      _statCard("Top Favorite Count", topTrackFavs, Icons.favorite_rounded, const Color(0xFF2E3B62)),
                      _statCard("Top Song", topTrackName, Icons.album, const Color(0xFF2E3B62)),
                    ],
                  ),
                  const SizedBox(height: 25),

                  _buildListSection(
                    "Top Favorited Tracks",
                    mostPlayed.isEmpty 
                        ? [const Text("No favorited tracks yet", style: TextStyle(color: Colors.white54, fontSize: 12))]
                        : mostPlayed.map((song) => _listItem("${song['title']}", "${song['playCount']} user favorites", Icons.music_note)).toList(),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildListSection(
                    "Top Detection Moods",
                    popularEmotions.isEmpty 
                        ? [const Text("No detections yet", style: TextStyle(color: Colors.white54, fontSize: 12))]
                        : popularEmotions.map((emotion) {
                            final label = emotion.toString()[0].toUpperCase() + emotion.toString().substring(1);
                            return _listItem(label, "Popular search mood", Icons.emoji_emotions_rounded);
                          }).toList(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  // UI ELEMENTS 
  Widget _header(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
  );

  Widget _statCard(String title, String val, IconData? icon, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 0),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12),
      image: const DecorationImage(image: AssetImage('assets/images/dots_pattern.png'), opacity: 0.1, fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.white54)),
          const SizedBox(height: 5),
          if (icon != null) Icon(icon, color: Colors.white, size: 20) else Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          if (icon != null) Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(12)),
          child: Column(children: items),
        )
      ],
    );
  }

  Widget _listItem(String title, String sub, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)), child: Icon(icon, size: 15, color: Colors.white70)),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis),
            Text(sub, style: const TextStyle(fontSize: 10, color: Colors.white54)),
          ]))
        ],
      ),
    );
  }
}

