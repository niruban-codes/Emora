import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../api_service.dart';

class MoodAnalyticsScreen extends StatefulWidget {
  const MoodAnalyticsScreen({super.key});

  @override
  State<MoodAnalyticsScreen> createState() => _MoodAnalyticsScreenState();
}

class _MoodAnalyticsScreenState extends State<MoodAnalyticsScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>?> _analyticsFuture;

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
  static const Color greenAccent = Color(0xFF12D790);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Mood Analytics",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _analyticsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(pinkAccent),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                "Unable to load data metrics",
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
              ),
            );
          }

          final data = snapshot.data!;
          final dailyAvg = data['daily_average'] ?? "0.0";
          final distribution = data['mood_distribution'] as Map<dynamic, dynamic>? ?? {};
          final peakMood = data['primary_peak'] ?? "Peaceful";
          final trendArrow = data['weekly_trend_arrow'] ?? "↗ 12%";
          final trendSummary = data['weekly_summary'] ?? 
    (trendArrow.contains('-') || trendArrow.contains('↘')
        ? "Keep an eye on your baseline logs"
        : "You stayed calm for most of the day");

          final rawPoints = (data['history_points'] as List?)
    ?.map((item) => double.tryParse(item.toString()) ?? 5.0)
    .toList() ?? [];

final List<double> pointsData = rawPoints.length > 1
    ? rawPoints
    : (rawPoints.length == 1
        ? [rawPoints[0], rawPoints[0], rawPoints[0], rawPoints[0], rawPoints[0], rawPoints[0], rawPoints[0]]
        : [6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0]);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDailyAverageCard(dailyAvg, pointsData, trendArrow),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStateCard(
                        "Today's Peak",
                        peakMood,
                        "Maintained for hours",
                        Icons.wb_sunny_outlined,
                        purpleAccent,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildStateCard(
                        "Active State",
                        "Creative",
                        "Higher than yesterday",
                        Icons.auto_awesome,
                        const Color(0xFFC06CFF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  "Mood Distribution",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _buildMoodDistributionGrid(distribution),
                const SizedBox(height: 30),
                _buildWeeklyTrendCard(pointsData, trendArrow, trendSummary),
                const SizedBox(height: 25),
                _buildViewMonthlyButton(context),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyAverageCard(String average, List<double> pointsData, String trend) {
    bool isNegative = trend.contains('-');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Daily Mood Average",
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isNegative ? Colors.red.withOpacity(0.1) : greenAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trend,
                  style: GoogleFonts.poppins(
                    color: isNegative ? Colors.redAccent : greenAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                average,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8, left: 4),
                child: Text(
                  "/10",
                  style: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            width: double.infinity,
            child: CustomPaint(painter: WavePainter(pinkAccent, pointsData)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Earlier", style: GoogleFonts.poppins(color: Colors.white24, fontSize: 11)),
              Text("Recent Logs Timeline", style: GoogleFonts.poppins(color: Colors.white24, fontSize: 11)),
              Text("Latest", style: GoogleFonts.poppins(color: Colors.white24, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStateCard(String label, String value, String sub, IconData icon, Color color,) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(sub, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),),
        ],
      ),
    );
  }

  Widget _buildMoodDistributionGrid(Map<dynamic, dynamic> percentages) {
    final Map<String, Color> moodColors = {
      "Happy": const Color(0xFFFFB347),
      "Sad": const Color(0xFF42A5F5),
      "Neutral": const Color(0xFF78909C),
      "Fear": const Color(0xFF7E57C2),
      "Angry": const Color(0xFFEF5350),
      "Surprise": const Color(0xFF4DB6AC),
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(
            painter: DonutChartPainter(
              percentages: percentages,
              moodColors: moodColors,
            ),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Wrap(
          spacing: 6,      
          runSpacing: 6,   
          alignment: WrapAlignment.start,
          children: [
            _moodChip("Happy", percentages['Happy'] ?? "0%", moodColors["Happy"]!, Icons.sentiment_very_satisfied_rounded),
            _moodChip("Sad", percentages['Sad'] ?? "0%", moodColors["Sad"]!, Icons.sentiment_dissatisfied_rounded),
            _moodChip("Neutral", percentages['Neutral'] ?? "0%", moodColors["Neutral"]!, Icons.lens_blur_rounded),
            _moodChip("Fear", percentages['Fear'] ?? "0%", moodColors["Fear"]!, Icons.sentiment_very_dissatisfied_outlined),
            _moodChip("Angry", percentages['Angry'] ?? "0%", moodColors["Angry"]!, Icons.local_fire_department_outlined),
            _moodChip("Surprise", percentages['Surprise'] ?? percentages['Surprise'] ?? "0%", moodColors["Surprise"]!, Icons.flare_rounded),
          ],
        )
      ),
    ],
  );
}

  Widget _moodChip(String label, String percent, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 11),
          ),
          const SizedBox(width: 4),
          Text(
            percent,
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendCard(List<double> trendPoints, String trendText, String summaryText) {
  bool isNegative = trendText.contains('↘') || trendText.contains('-');

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: cardBg.withOpacity(0.8),
      borderRadius: BorderRadius.circular(28),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Weekly Trend",
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 16),
            ),
            Text(
              trendText,
              style: GoogleFonts.poppins(
                color: isNegative ? Colors.redAccent : greenAccent,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          isNegative ? "Dropping Baseline" : "Stable & Growing",
          style: GoogleFonts.poppins(
            color: pinkAccent,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 100,
          width: double.infinity,
          child: CustomPaint(painter: WavePainter(purpleAccent, trendPoints)),
        ),
        const SizedBox(height: 10),
        Text(
          summaryText,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
        ),
      ],
    ),
  );
}
  

  Widget _buildViewMonthlyButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/monthly-analytics'),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFF24224D),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            "View Monthly Analytics",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}


class WavePainter extends CustomPainter {
  final Color color;
  final List<double> dataPoints;

  WavePainter(this.color, this.dataPoints);

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    var path = Path();

    double stepX = size.width / (dataPoints.length > 1 ? dataPoints.length - 1 : 1);

    double getY(double val) {
      double normalized = val.clamp(0.0, 10.0) / 10.0;
      return size.height * (1.0 - normalized);
    }

    path.moveTo(0, getY(dataPoints[0]));

    for (int i = 0; i < dataPoints.length - 1; i++) {
      double x1 = i * stepX;
      double y1 = getY(dataPoints[i]);
      double x2 = (i + 1) * stepX;
      double y2 = getY(dataPoints[i + 1]);

      double controlX1 = x1 + (stepX / 2);
      double controlY1 = y1;
      double controlX2 = x1 + (stepX / 2);
      double controlY2 = y2;

      path.cubicTo(controlX1, controlY1, controlX2, controlY2, x2, y2);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints || oldDelegate.color != color;
  }
}

class DonutChartPainter extends CustomPainter {
  final Map<dynamic, dynamic> percentages;
  final Map<String, Color> moodColors;

  DonutChartPainter({required this.percentages, required this.moodColors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    final strokeWidth = radius * 0.3;

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -math.pi / 2;
    bool hasData = percentages.values.any((v) => (double.tryParse(v.toString().replaceAll('%', '')) ?? 0) > 0);

    if (!hasData) {
      canvas.drawCircle(center, radius - strokeWidth / 2, basePaint..color = Colors.white10);
      return;
    }

    percentages.forEach((mood, percentStr) {
      final cleanStr = percentStr.toString().replaceAll('%', '');
      final percentValue = double.tryParse(cleanStr) ?? 0.0;
      if (percentValue <= 0) return;

      final sweepAngle = (percentValue / 100) * 2 * math.pi;
      final slicePaint = basePaint..color = moodColors[mood.toString()] ?? Colors.grey;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        slicePaint,
      );

      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) {
    return oldDelegate.percentages != percentages || oldDelegate.moodColors != moodColors;
  }
}