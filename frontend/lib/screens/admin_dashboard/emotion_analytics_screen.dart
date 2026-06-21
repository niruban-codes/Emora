import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EmotionAnalyticsScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;
  const EmotionAnalyticsScreen({super.key, this.onBackToDashboard});
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
        backgroundColor: const Color(0xFF0D0C1D),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Emotion Analytics",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.onBackToDashboard != null) {
              widget
                  .onBackToDashboard!(); // Navigates back to the Dashboard index
            } else {
              Navigator.pop(context);
            }
          },
        ),
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
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Colors.cyanAccent,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (String? newValue) {
                  setState(() => _selectedTimeFrame = newValue!);
                },
                items: <String>['Daily', 'Weekly', 'Monthly']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
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
            const SizedBox(height: 10),
            _buildMoodDonut(),
            const SizedBox(height: 25),
            _buildGenreByEmotionBar(),
            const SizedBox(height: 30),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // WATHSILUNI... remove this when you set Python backend image URLs later
  Widget _buildMoodDonut() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252648),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mood Distribution",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              // Left Side-- The Pie Chart
              SizedBox(
                height: 140,
                width: 140,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 35,
                    sections: [
                      PieChartSectionData(
                        color: Colors.yellow,
                        value: 30,
                        radius: 10,
                        showTitle: false,
                      ), // Happy
                      PieChartSectionData(
                        color: Colors.blue,
                        value: 20,
                        radius: 10,
                        showTitle: false,
                      ), // Sad
                      PieChartSectionData(
                        color: Colors.grey,
                        value: 25,
                        radius: 10,
                        showTitle: false,
                      ), // Neutral
                      PieChartSectionData(
                        color: Colors.green,
                        value: 10,
                        radius: 10,
                        showTitle: false,
                      ), // Surprise
                      PieChartSectionData(
                        color: Colors.purple,
                        value: 10,
                        radius: 10,
                        showTitle: false,
                      ), // Fear
                      PieChartSectionData(
                        color: Colors.orange,
                        value: 5,
                        radius: 10,
                        showTitle: false,
                      ), // Angry
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 25),
              // Right Side-- The 6 Emotions Percentages List
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnalyticsLegend(Colors.yellow, "Happy", "30%"),
                    AnalyticsLegend(Colors.blue, "Sad", "20%"),
                    AnalyticsLegend(Colors.grey, "Neutral", "25%"),
                    AnalyticsLegend(Colors.green, "Surprise", "10%"),
                    AnalyticsLegend(Colors.purple, "Fear", "10%"),
                    AnalyticsLegend(Colors.orange, "Angry", "5%"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenreByEmotionBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252648),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Top Recommended Genres",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 8,
                        color: const Color(0xFFD43FB1),
                        width: 12,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 12,
                        color: const Color(0xFF6C5CE7),
                        width: 12,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 6,
                        color: const Color(0xFF00FFCC),
                        width: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "Pop / HipHop / R&B",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsLegend extends StatelessWidget {
  final Color color;
  final String label;
  final String percentage;
  const AnalyticsLegend(this.color, this.label, this.percentage, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
