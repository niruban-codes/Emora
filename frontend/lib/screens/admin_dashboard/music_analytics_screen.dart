import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MusicAnalyticsScreen extends StatelessWidget {
  const MusicAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131429),
      appBar: AppBar(
        title: const Text("Music Analytics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. LISTENING STATS (The 4 Decorative Cards)
            _header("Listening Stats"),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _statCard("Time Listened", "12h 30m", null, const Color(0xFF2E3B62)),
                  _statCard("Top Genre", "POP", Icons.change_history_rounded, const Color(0xFF2E3B62)),
                  _statCard("Top Artist", "The Weeknd", Icons.person, const Color(0xFF2E3B62)),
                  _statCard("Top Song", "STARBOY", Icons.album, const Color(0xFF2E3B62)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. LISTENING TRENDS (Full Width Line Chart)
            _header("Listening Trends"),
            _container(
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Weekly Listening Activity", style: TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 20),
                  Expanded(child: _buildLineChart()),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. GENRE BREAKDOWN (Large Donut with Legend)
            _header("Genre Breakdown"),
            _container(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(height: 140, child: _buildLargeDonut()),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _legendItem(Color(0xFF00FFCC), "Pop", "40%"),
                        _legendItem(Color(0xFF4285F4), "Hip Hop", "15%"),
                        _legendItem(Color(0xFF7E57C2), "Rock", "10%"),
                        _legendItem(Color(0xFFF06292), "K-Pop", "25%"),
                        _legendItem(Color(0xFFFFA726), "R&B", "5%"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. TWO-COLUMN LIST (Top Songs & Top Artists)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildListSection("Top Songs", [
                  _listItem("Star Boy", "4B plays", Icons.music_note),
                  _listItem("Dynamite", "2.5B plays", Icons.music_note),
                  _listItem("Cruel Summer", "1B plays", Icons.music_note),
                ])),
                const SizedBox(width: 12),
                Expanded(child: _buildListSection("Top Artists", [
                  _listItem("The Weeknd", "116.2M", Icons.person),
                  _listItem("Taylor Swift", "104.6M", Icons.person),
                  _listItem("BTS", "60.2M", Icons.person),
                ])),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // UI ELEMENTS MAPPING FIGMA
  Widget _header(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );

  Widget _container({required Widget child, double? height}) => Container(
    padding: const EdgeInsets.all(16),
    height: height,
    decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(12)),
    child: child,
  );

  Widget _statCard(String title, String val, IconData? icon, Color color) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12),
      image: const DecorationImage(image: AssetImage('assets/images/dots_pattern.png'), opacity: 0.1, fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 8, color: Colors.white54)),
          const SizedBox(height: 5),
          if (icon != null) Icon(icon, color: Colors.white, size: 20) else Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          if (icon != null) Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(LineChartData(
      gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (val) => FlLine(color: Colors.white10, strokeWidth: 1)),
      titlesData: const FlTitlesData(leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22)), rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: [const FlSpot(0, 4), const FlSpot(1, 6), const FlSpot(2, 4.5), const FlSpot(3, 4), const FlSpot(4, 7.5), const FlSpot(5, 6), const FlSpot(6, 8)],
          isCurved: true,
          color: const Color(0xFF00FFCC),
          barWidth: 4,
          dotData: const FlDotData(show: true),
        )
      ],
    ));
  }

  Widget _buildLargeDonut() {
    return PieChart(PieChartData(sectionsSpace: 0, centerSpaceRadius: 35, sections: [
      PieChartSectionData(color: const Color(0xFF00FFCC), value: 40, radius: 15, showTitle: false),
      PieChartSectionData(color: const Color(0xFFF06292), value: 25, radius: 15, showTitle: false),
      PieChartSectionData(color: const Color(0xFF4285F4), value: 15, radius: 15, showTitle: false),
      PieChartSectionData(color: const Color(0xFF7E57C2), value: 10, radius: 15, showTitle: false),
      PieChartSectionData(color: Colors.orange, value: 10, radius: 15, showTitle: false),
    ]));
  }

  Widget _buildListSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
            Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
            Text(sub, style: const TextStyle(fontSize: 8, color: Colors.white54)),
          ]))
        ],
      ),
    );
  }
}

class _legendItem extends StatelessWidget {
  final Color color; final String label; final String pct;
  const _legendItem(this.color, this.label, this.pct);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70))),
      Text(pct, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
    ]),
  );
}