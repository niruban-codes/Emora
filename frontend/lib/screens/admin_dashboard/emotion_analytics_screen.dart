import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../api_service.dart';

class EmotionAnalyticsScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;
  const EmotionAnalyticsScreen({super.key, this.onBackToDashboard}); 
  @override
  State<EmotionAnalyticsScreen> createState() => _EmotionAnalyticsScreenState();
}

class _EmotionAnalyticsScreenState extends State<EmotionAnalyticsScreen> {
  String _selectedTimeFrame = 'Weekly';
  late Future<Map<String, dynamic>> _emotionFuture;

  final Map<String, Color> _emotionColors = {
    'happy': Colors.yellow,
    'sad': Colors.blue,
    'neutral': Colors.grey,
    'surprise': Colors.green,
    'fear': Colors.purple,
    'angry': Colors.orange,
    'disgust': Colors.tealAccent,
  };

  @override
  void initState() {
    super.initState();
    _emotionFuture = ApiService().getAdminEmotionStats().then((val) => val ?? {});
  }

  Color _getColor(String emotion) => _emotionColors[emotion.toLowerCase()] ?? Colors.pinkAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0C1D),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Emotion Analytics", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _emotionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF6C5CE7)));
          }
          final emotionData = snapshot.data ?? {};

          return RefreshIndicator(
            onRefresh: () async => setState(() {
              _emotionFuture = ApiService().getAdminEmotionStats().then((val) => val ?? {});
            }),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildMoodDonut(emotionData),
                  const SizedBox(height: 25),
                  _buildGenreByEmotionBar(emotionData),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

Widget _buildMoodDonut(Map<String, dynamic> emotionData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Mood Distribution", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          if (emotionData.isEmpty)
            const Center(child: Text("No emotion data recorded", style: TextStyle(color: Colors.white54, fontSize: 12)))
          else
            Row(
              children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: PieChart(PieChartData(
                    sectionsSpace: 2, centerSpaceRadius: 35,
                    sections: emotionData.entries.map((entry) {
                      return PieChartSectionData(
                        color: _getColor(entry.key),
                        value: (entry.value as num).toDouble(),
                        radius: 10, showTitle: false,
                      );
                    }).toList(),
                  )),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: emotionData.entries.map((entry) {
                      final label = entry.key[0].toUpperCase() + entry.key.substring(1);
                      return AnalyticsLegend(_getColor(entry.key), label, "${entry.value}%");
                    }).toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildGenreByEmotionBar(Map<String, dynamic> emotionData) {
    final sorted = emotionData.entries.toList()..sort((a, b) => (b.value as num).compareTo(a.value as num));
    final topThree = sorted.take(3).toList();
    
    final barRods = topThree.asMap().entries.map((item) {
      return BarChartGroupData(
        x: item.key,
        barRods: [BarChartRodData(toY: (item.value.value as num).toDouble(), color: _getColor(item.value.key), width: 14, borderRadius: BorderRadius.circular(4))],
      );
    }).toList();
    
    final labelString = topThree.map((e) => e.key[0].toUpperCase() + e.key.substring(1)).join(' / ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Top Detected Emotions", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: BarChart(BarChartData(
              gridData: const FlGridData(show: false), titlesData: const FlTitlesData(show: false), borderData: FlBorderData(show: false),
              barGroups: barRods.isEmpty ? [BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 0, color: const Color(0xFFD43FB1), width: 12)])] : barRods,
            )),
          ),
          const SizedBox(height: 10),
          Center(child: Text(labelString.isEmpty ? "No Data" : labelString, style: const TextStyle(fontSize: 12, color: Colors.white70))),
        ],
      ),
    );
  }
}

  class AnalyticsLegend extends StatelessWidget {
    final Color color; 
    final String label; 
    final String percentage;
    const AnalyticsLegend(this.color, this.label, this.percentage,{super.key});

    @override
    Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70))),
          Text(percentage, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }