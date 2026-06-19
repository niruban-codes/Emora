import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UserEngagementScreen extends StatelessWidget {
  const UserEngagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0C1D),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "User Engagement",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ALL 4 QUICK STAT CARDS (Horizontal Scrollable)
            const Text(
              "Overview",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 12),
          
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6, // Adjusts the height-to-width proportion
              children: [
                _buildStatCard("Active Users", "5,320", "Online now", const Color(0xFF6C5CE7)),
                _buildStatCard("New Users", "780", "+15% this week", const Color(0xFFD43FB1)),
                _buildStatCard("Returning Users", "4,200", "82% retention", Colors.blueAccent),
                _buildStatCard("Avg. Session", "18m 43s", "-2m from yesterday", Colors.orangeAccent),
              ],
            ),
            const SizedBox(height: 25),

            // 3. DAILY ACTIVE USERS (Line Chart)
            _buildChartSection(
              title: "Daily Active Users",
              subtitle: "Last 7 days trend",
              height: 180,
              child: _buildDALineChart(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // UI COMPONENTS

  Widget _buildStatCard(String title, String value, String sub, Color accent) {
    return Container(
      //width: 150,
      margin: const EdgeInsets.only(right: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252648),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.white54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: TextStyle(fontSize: 9, color: accent.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection({
    required String title,
    String? subtitle,
    double? height,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252648),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.white54),
            ),
          const SizedBox(height: 15),
          height != null ? SizedBox(height: height, child: child) : child,
        ],
      ),
    );
  }


  Widget _buildDALineChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 2),
              const FlSpot(1, 3.5),
              const FlSpot(2, 2.8),
              const FlSpot(3, 5),
              const FlSpot(4, 4),
              const FlSpot(5, 6),
            ],
            isCurved: true,
            color: const Color(0xFF00FFCC),
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF00FFCC).withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
