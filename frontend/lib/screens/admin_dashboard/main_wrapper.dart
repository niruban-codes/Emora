import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'user_engagement_screen.dart';
import 'emotion_analytics_screen.dart';
import 'music_analytics_screen.dart';
import 'admin_controls_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  // The 5 screens mapped to the icons
  final List<Widget> _screens = [
    const DashboardScreen(),        // Panel 1 (Dashboard)
    const EmotionAnalyticsScreen(), // Panel 3 (Logs)
    const UserEngagementScreen(),   // Panel 2 (Users)
    const MusicAnalyticsScreen(),   // Panel 4 (Music)
    const AdminControlScreen(),     // Panel 5 (System)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This holds the state of all 5 panels
      backgroundColor: const Color(0xFF0D0C1D),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0D0C1D),
        selectedItemColor: const Color(0xFFD43FB1),
        unselectedItemColor: Colors.white54,

        selectedLabelStyle: const TextStyle(
          fontSize: 10, 
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),

        unselectedLabelStyle: const TextStyle(
          fontSize: 10, 
          fontWeight: FontWeight.normal,
          letterSpacing: 0.5,
        ),

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'DASHBOARD'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'LOGS'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined), label: 'USERS'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note_rounded), label: 'MUSIC'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_suggest_outlined), label: 'SYSTEM'),
        ],
      ),
    );
  }
}