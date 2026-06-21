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
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(onExitAdmin: () => Navigator.pop(context)),
      EmotionAnalyticsScreen(
        onBackToDashboard: () => setState(() => _currentIndex = 0),
      ),
      UserEngagementScreen(
        onBackToDashboard: () => setState(() => _currentIndex = 0),
      ),
      MusicAnalyticsScreen(
        onBackToDashboard: () => setState(() => _currentIndex = 0),
      ),
      AdminControlScreen(
        onBackToDashboard: () => setState(() => _currentIndex = 0),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This holds the state of all 5 panels
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1F3D),
        selectedItemColor: const Color(0xFFD43FB1),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'DASHBOARD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'LOGS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'USERS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note_rounded),
            label: 'MUSIC',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_suggest_outlined),
            label: 'SYSTEM',
          ),
        ],
      ),
    );
  }
}
