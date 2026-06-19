import 'package:flutter/material.dart';
//import 'package:fl_chart/fl_chart.dart';

class MusicAnalyticsScreen extends StatelessWidget {
  const MusicAnalyticsScreen({super.key});

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
            // 1. LISTENING STATS 
            _header("Listening Stats"),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _statCard("Time Listened", "12h 30m", null, const Color(0xFF2E3B62)),
                  _statCard("Top Genre", "POP", Icons.change_history_rounded, const Color(0xFF2E3B62)),
                  _statCard("Top Artist", "The Weeknd", Icons.person, const Color(0xFF2E3B62)),
                  _statCard("Top Song", "STARBOY", Icons.album, const Color(0xFF2E3B62)),
                ],
              ),
            
            const SizedBox(height: 25),

            // 2. TWO-COLUMN LIST 
            _buildListSection("Top Songs", [
              _listItem("Star Boy", "4B plays", Icons.music_note),
              _listItem("Dynamite", "2.5B plays", Icons.music_note),
              _listItem("Cruel Summer", "1B plays", Icons.music_note),
            ]),
            const SizedBox(height: 20),
            
            _buildListSection("Top Artists", [
              _listItem("The Weeknd", "116.2M", Icons.person),
              _listItem("Taylor Swift", "104.6M", Icons.person),
              _listItem("BTS", "60.2M", Icons.person),
            ]),
            const SizedBox(height: 30),
          ],
        ),
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

