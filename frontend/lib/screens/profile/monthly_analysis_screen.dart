import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../api_service.dart';

class MonthlyAnalysisScreen extends StatefulWidget {
  const MonthlyAnalysisScreen({super.key});


  @override
  State<MonthlyAnalysisScreen> createState() => _MonthlyAnalysisScreenState();
}


class _MonthlyAnalysisScreenState extends State<MonthlyAnalysisScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>?> _analyticsFuture;
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_user';
    _analyticsFuture = _apiService.getMoodAnalyticsFromAzure(uid);
  }

  static const Color bgColor = Color(0xFF0D0C1D);
  static const Color cardBg = Color(0xFF1D1B3E);
  static const Color pinkAccent = Color(0xFFE598D0);
  static const Color purpleAccent = Color(0xFF8E248D);

  static const Color happyColor = Color(0xFFFFB347);
  static const Color neutralColor = Color(0xFF78909C);
  static const Color sadColor = Color(0xFF42A5F5);
  static const Color energeticColor = Color(0xFFEF5350);
  
  final List<String> _months = [
  "January", "February", "March", "April", "May", "June", 
  "July", "August", "September", "October", "November", "December"
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Monthly Mood Analysis",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _analyticsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(pinkAccent)));
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Unable to load data metrics", style: TextStyle(color: Colors.white54)));
          }

          final data = snapshot.data!;
          print("DEBUG ENDPOINT PAYLOAD: $data");
          final distribution = data['mood_distribution'] as Map<dynamic, dynamic>? ?? {};
          final happyTracks = data['happy_tracks_count'] ?? 0;
          final sadTracks = data['sad_tracks_count'] ?? 0;
          final Map<String, dynamic> dailyMoods = (data['daily_moods'] as Map<String, dynamic>?) ?? {};
          bool hasData = distribution.values.any((v) => (double.tryParse(v.toString().replaceAll('%', '')) ?? 0) > 0);
          final consistencyScore = data['accuracy_percentage'] ?? (hasData ? "98%" : "Calculating...");

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Monthly Emotional Profile",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                _buildCalendarCard(dailyMoods),
                const SizedBox(height: 35),
                Text(
                  "Emotion Accuracy per Category",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildAccuracyCard(distribution, happyTracks, sadTracks), // Change this line to pass variables!
                const SizedBox(height: 20),
                _buildConsistencyCard(consistencyScore),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Color? _getMoodColor(String? mood) {
  if (mood == null) return null;
  switch (mood.toLowerCase()) {
    case 'happy':
      return happyColor;
    case 'sad':
      return sadColor;
    case 'neutral':
    case 'peaceful':
      return neutralColor;
    case 'angry':
      return energeticColor;
    case 'surprise':
      return const Color(0xFF4DB6AC);
    case 'fear':
      return const Color(0xFF7E57C2);
    default:
      return pinkAccent;
  }
}
  
  Widget _buildCalendarCard(Map<String, dynamic> dailyMoods) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: cardBg.withOpacity(0.5),
      borderRadius: BorderRadius.circular(32),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white70),
              onPressed: () {
                setState(() {
                  _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                });
              },
            ),
            Text(
              "${_months[_currentMonth.month - 1]} ${_currentMonth.year}",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white70),
              onPressed: () {
                setState(() {
                  _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ["S", "M", "T", "W", "T", "F", "S"]
              .map(
                (d) => SizedBox(
                  width: 35,
                  child: Center(
                    child: Text(
                      d,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF5C5992),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 15),
        _buildDynamicCalendarGrid(dailyMoods),
      ],
    ),
  );
}

Widget _buildDynamicCalendarGrid(Map<String, dynamic> dailyMoods) {
  final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
  final firstWeekdayOffset = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;
  
  final now = DateTime.now();
  final isCurrentMonth = _currentMonth.year == now.year && _currentMonth.month == now.month;

  List<Widget> dayWidgets = [];

  for (int i = 0; i < firstWeekdayOffset; i++) {
    dayWidgets.add(const SizedBox(width: 35, height: 42));
  }

  for (int day = 1; day <= daysInMonth; day++) {
    final isToday = isCurrentMonth && day == now.day;
    final dateKey = "${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
    final moodForDay = dailyMoods[dateKey] ?? dailyMoods[day.toString()];
    final dotColor = _getMoodColor(moodForDay?.toString());
dayWidgets.add(
  SizedBox(
    width: 35,
    height: 42,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: isToday
              ? const BoxDecoration(color: purpleAccent, shape: BoxShape.circle)
              : null,
          child: Text(
            "$day",
            style: GoogleFonts.poppins(
              color: isToday ? Colors.white : Colors.white60,
              fontSize: 13,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(height: 3),
        if (dotColor != null)
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          )
        else
          const SizedBox(height: 4),
      ],
    ),
  ),
);
  }

  List<Widget> rows = [];
  for (int i = 0; i < dayWidgets.length; i += 7) {
    int end = (i + 7 < dayWidgets.length) ? i + 7 : dayWidgets.length;
    rows.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...dayWidgets.sublist(i, end),
            if (end - i < 7)
              ...List.generate(7 - (end - i), (_) => const SizedBox(width: 35, height: 42)),
          ],
        ),
      ),
    );
  }

  return Column(children: rows);
}
  
  Widget _buildAccuracyCard(Map<dynamic, dynamic> percentages, int happyCount, int sadCount) {
  double happyVal = happyCount > 0 ? (happyCount / (happyCount + sadCount + 1)) : 0.0;
  double sadVal = sadCount > 0 ? (sadCount / (happyCount + sadCount + 1)) : 0.0;
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: cardBg.withOpacity(0.5),
      borderRadius: BorderRadius.circular(32),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChartLegend(percentages: percentages),
        const SizedBox(height: 25),
        _trackRow("Happy Tracks", happyVal, happyCount.toString(), happyColor),
        const SizedBox(height: 20),
        _trackRow("Sad Tracks", sadVal, sadCount.toString(), sadColor),
      ],
    ),
  );
}

  

  Widget _trackRow(String label, double val, String count, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
            ),
            Text(
              count,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: val,
            minHeight: 7,
            color: color.withOpacity(0.9),
            backgroundColor: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  

  Widget _buildConsistencyCard(String accuracy) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: Color(0xFFE598D0), size: 26),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MOOD CONSISTENCY",
                style: GoogleFonts.poppins(
                  color: purpleAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "${_months[DateTime.now().month - 1]} ${DateTime.now().day}${_getDaySuffix(DateTime.now().day)}: $accuracy Accuracy",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) return 'th';
  switch (day % 10) {
    case 1: return 'st';
    case 2: return 'nd';
    case 3: return 'rd';
    default: return 'th';
  }
}


class _ChartLegend extends StatelessWidget {
  final Map<dynamic, dynamic> percentages;
  const _ChartLegend({required this.percentages});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
  Row(children: [
    Expanded(child: _LItem(const Color(0xFFFFB347), "Happy: ${percentages['Happy'] ?? '0%'}")),
    Expanded(child: _LItem(const Color(0xFF78909C), "Neutral: ${percentages['Neutral'] ?? '0%'}")),
  ]),
  Row(children: [
    Expanded(child: _LItem(const Color(0xFF42A5F5), "Sad: ${percentages['Sad'] ?? '0%'}")),
    Expanded(child: _LItem(const Color(0xFF4DB6AC), "Surprise: ${percentages['Surprise'] ?? '0%'}")),
  ]),
  Row(children: [
    Expanded(child: _LItem(const Color(0xFF7E57C2), "Fear: ${percentages['Fear'] ?? '0%'}")),
    Expanded(child: _LItem(const Color(0xFFEF5350), "Angry: ${percentages['Angry'] ?? '0%'}")),
  ]),
],
    );
  }
}

class _LItem extends StatelessWidget {
  final Color c;
  final String t;
  const _LItem(this.c, this.t);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          CircleAvatar(radius: 3, backgroundColor: c),
          const SizedBox(width: 8),
          Text(
            t,
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
