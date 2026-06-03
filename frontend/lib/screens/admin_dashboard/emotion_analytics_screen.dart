import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EmotionAnalyticsScreen extends StatefulWidget {
  const EmotionAnalyticsScreen({super.key});

  @override
  State<EmotionAnalyticsScreen> createState() => _EmotionAnalyticsScreenState();
}

class _EmotionAnalyticsScreenState extends State<EmotionAnalyticsScreen> {
  String _selectedTimeFrame = 'Weekly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131429),
      appBar: AppBar(
        title: const Text("Emotion Analytics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.arrow_back),
        actions: [
          // 1. THE DROPDOWN BOX (Timeframe Selector)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF252648),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedTimeFrame,
                dropdownColor: const Color(0xFF252648),
                icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.cyanAccent),
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                onChanged: (String? newValue) {
                  setState(() => _selectedTimeFrame = newValue!);
                },
                items: <String>['Daily', 'Weekly', 'Monthly']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. EMOTION HEATMAP (7x4 Grid)
            _buildSectionHeader("Emotion Heatmap"),
            _buildHeatmapCard(),
            const SizedBox(height: 25),

            // 3. MOOD DISTRIBUTION & GENRE BAR GRAPH
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildMoodDonut()),
                const SizedBox(width: 15),
                Expanded(child: _buildGenreByEmotionBar()),
              ],
            ),
            const SizedBox(height: 25),

            // 4. MOOD TO MUSIC CORRELATION (Line Chart)
            _buildSectionHeader("Mood to Music Correlation"),
            _buildCorrelationLineChart(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _buildHeatmapCard() {
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final List<String> times = ['Morning', 'Noon', 'Eve', 'Night'];
    final List<Color> heatmapColors = [
      Colors.blue.shade900, Colors.blue, Colors.teal, Colors.yellow, Colors.orange, Colors.red, Colors.orange,
      Colors.blueAccent, Colors.green, Colors.yellow, Colors.yellow, Colors.orange, Colors.red, Colors.redAccent,
      Colors.greenAccent, Colors.yellow, Colors.orange, Colors.orange, Colors.brown, Colors.brown.shade900, Colors.red,
      Colors.blue, Colors.blue.shade800, Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.redAccent,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(children: [const SizedBox(width: 50), ...days.map((d) => Expanded(child: Center(child: Text(d, style: const TextStyle(fontSize: 10, color: Colors.white54)))))]),
          const SizedBox(height: 10),
          ...List.generate(4, (r) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              SizedBox(width: 50, child: Text(times[r], style: const TextStyle(fontSize: 10, color: Colors.white54))),
              ...List.generate(7, (c) => Expanded(child: Container(height: 22, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: heatmapColors[r * 7 + c], borderRadius: BorderRadius.circular(4))))),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _buildMoodDonut() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const Text("Mood Distribution", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          Expanded(child: PieChart(PieChartData(sectionsSpace: 0, centerSpaceRadius: 35, sections: [
            PieChartSectionData(color: Colors.orange, value: 34, radius: 10, showTitle: false),
            PieChartSectionData(color: Colors.greenAccent, value: 22, radius: 10, showTitle: false),
            PieChartSectionData(color: Colors.purple, value: 15, radius: 10, showTitle: false),
            PieChartSectionData(color: Colors.redAccent, value: 29, radius: 10, showTitle: false),
          ]))),
          const Text("Happy 34%", style: TextStyle(fontSize: 10, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildGenreByEmotionBar() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const Text("Top Genre by Emotion", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Expanded(child: BarChart(BarChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: [
              BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: const Color(0xFFD43FB1), width: 8)]),
              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 12, color: const Color(0xFF6C5CE7), width: 8)]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 6, color: const Color(0xFF00FFCC), width: 8)]),
            ],
          ))),
          const Text("Pop / R&B", style: TextStyle(fontSize: 10, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildCorrelationLineChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(20)),
      child: LineChart(LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [const FlSpot(0, 1), const FlSpot(1, 3), const FlSpot(2, 2.5), const FlSpot(3, 4.5), const FlSpot(4, 3.8), const FlSpot(5, 5)],
            isCurved: true,
            color: const Color(0xFFD43FB1),
            barWidth: 4,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: const Color(0xFFD43FB1).withOpacity(0.1)),
          ),
          LineChartBarData(
            spots: [const FlSpot(0, 2), const FlSpot(1, 2.5), const FlSpot(2, 4), const FlSpot(3, 3), const FlSpot(4, 4.5), const FlSpot(5, 4)],
            isCurved: true,
            color: const Color(0xFF00FFCC),
            barWidth: 4,
            dotData: const FlDotData(show: true),
          ),
        ],
      )),
    );
  }
}