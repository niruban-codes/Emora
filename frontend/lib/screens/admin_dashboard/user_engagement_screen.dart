import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UserEngagementScreen extends StatelessWidget {
  const UserEngagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131429),
      appBar: AppBar(
        title: const Text("User Engagement", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.arrow_back),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ALL 4 QUICK STAT CARDS (Horizontal Scrollable)
            const Text("Overview", style: TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard("Active Users", "5,320", "Online now", const Color(0xFF6C5CE7)),
                  _buildStatCard("New Users", "780", "+15% this week", const Color(0xFFD43FB1)),
                  _buildStatCard("Returning Users", "4,200", "82% retention", Colors.blueAccent),
                  _buildStatCard("Avg. Session", "18m 43s", "-2m from yesterday", Colors.orangeAccent),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 2. USER DEMOGRAPHICS (Age & Gender)
            _buildChartSection(
              title: "User Demographics",
              subtitle: "Age & Gender Distribution",
              height: 220,
              child: _buildDemographicsBarChart(),
            ),
            const SizedBox(height: 20),

            // 3. DAILY ACTIVE USERS (Line Chart)
            _buildChartSection(
              title: "Daily Active Users",
              subtitle: "Last 7 days trend",
              height: 180,
              child: _buildDALineChart(),
            ),
            const SizedBox(height: 20),

            // 4. BOTTOM DATA ROW: COUNTRIES & ACTIVITIES
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildChartSection(
                    title: "Top Countries",
                    child: Column(
                      children: [
                        _countryRow("🇱🇰", "Sri Lanka", "45%"),
                        _countryRow("🇺🇸", "USA", "22%"),
                        _countryRow("🇮🇳", "India", "18%"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 2,
                  child: _buildChartSection(
                    title: "Top Activities",
                    child: SizedBox(
                      height: 100,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 20,
                          sections: [
                            PieChartSectionData(color: const Color(0xFFD43FB1), value: 40, radius: 12, showTitle: false),
                            PieChartSectionData(color: const Color(0xFF6C5CE7), value: 35, radius: 12, showTitle: false),
                            PieChartSectionData(color: const Color(0xFF00FFCC), value: 25, radius: 12, showTitle: false),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildStatCard(String title, String value, String sub, Color accent) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252648),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.white54)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(sub, style: TextStyle(fontSize: 9, color: accent.withOpacity(0.9))),
        ],
      ),
    );
  }

  Widget _buildChartSection({required String title, String? subtitle, double? height, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252648),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.white54)),
          const SizedBox(height: 15),
          height != null ? SizedBox(height: height, child: child) : child,
        ],
      ),
    );
  }

  Widget _buildDemographicsBarChart() {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, meta) {
                const ageGroups = ['18-24', '25-34', '35-44', '45-54', '55+'];
                return Text(ageGroups[val.toInt() % 5], style: const TextStyle(fontSize: 9, color: Colors.white54));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(5, (i) => BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: 10.0 - i, color: const Color(0xFFD43FB1), width: 7),
            BarChartRodData(toY: 8.0 - i, color: const Color(0xFF6C5CE7), width: 7),
          ],
        )),
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
            spots: [const FlSpot(0, 2), const FlSpot(1, 3.5), const FlSpot(2, 2.8), const FlSpot(3, 5), const FlSpot(4, 4), const FlSpot(5, 6)],
            isCurved: true,
            color: const Color(0xFF00FFCC),
            barWidth: 3,
            belowBarData: BarAreaData(show: true, color: const Color(0xFF00FFCC).withOpacity(0.1)),
          )
        ],
      ),
    );
  }

  Widget _countryRow(String flag, String name, String pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 12))),
          Text(pct, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF00FFCC))),
        ],
      ),
    );
  }
}