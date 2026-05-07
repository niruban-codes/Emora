import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; //  added
import 'dart:math' as math;

class MonthlyAnalysisScreen extends StatefulWidget {
  const MonthlyAnalysisScreen({super.key});

  @override
  State<MonthlyAnalysisScreen> createState() => _MonthlyAnalysisScreenState();
}

class _MonthlyAnalysisScreenState extends State<MonthlyAnalysisScreen> {
  static const Color bgColor = Color(0xFF13112B);
  static const Color cardBg = Color(0xFF1D1B3E);
  static const Color pinkAccent = Color(0xFFE598D0);
  static const Color purpleAccent = Color(0xFF8E248D);

  static const Color happyColor = Color(0xFFAB47BC);
  static const Color peacefulColor = Color(0xFF66BB6A);
  static const Color sadColor = Color(0xFF42A5F5);
  static const Color energeticColor = Color(0xFFEF5350);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () => context.pop(), //  go_router pop
        ),
        title: const Text(
          "Monthly Mood Analysis",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Monthly Emotional Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            _buildCalendarCard(),
            const SizedBox(height: 25),
            _buildComparisonCard(),
            const SizedBox(height: 35),
            const Text(
              "Emotion Accuracy per Category",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildAccuracyCard(),
            const SizedBox(height: 20),
            _buildConsistencyCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left, color: Colors.white30),
              Text(
                "October 2023",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white30),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["S", "M", "T", "W", "T", "F", "S"]
                .map(
                  (d) => SizedBox(
                    width: 35,
                    child: Center(
                      child: Text(
                        d,
                        style: const TextStyle(
                          color: Color(0xFF5C5992),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 15),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        _calRow(
          ["", "", "", "1", "2", "3", "4"],
          [
            null,
            null,
            null,
            pinkAccent,
            const Color(0xFF7B1FA2),
            const Color(0xFF7B1FA2),
            pinkAccent,
          ],
        ),
        const SizedBox(height: 15),
        _calRow(
          ["5", "6", "7", "8", "9", "10", "11"],
          [
            pinkAccent,
            const Color(0xFF1E88E5),
            const Color(0xFF7B1FA2),
            const Color(0xFF7B1FA2),
            pinkAccent,
            const Color(0xFF7B1FA2),
            pinkAccent,
          ],
          highlight: "5",
        ),
        const SizedBox(height: 15),
        _calRow(
          ["12", "13", "14", "15", "16", "17", ""],
          [
            const Color(0xFF7B1FA2),
            const Color(0xFF7B1FA2),
            pinkAccent,
            const Color(0xFF7B1FA2),
            const Color(0xFF7B1FA2),
            pinkAccent,
            null,
          ],
        ),
      ],
    );
  }

  Widget _calRow(List<String> days, List<Color?> dots, {String? highlight}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        7,
        (i) => SizedBox(
          width: 35,
          child: Column(
            children: [
              if (days[i] == highlight)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: purpleAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    days[i],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Text(
                  days[i],
                  style: TextStyle(
                    color: days[i].isEmpty
                        ? Colors.transparent
                        : Colors.white60,
                    fontSize: 12,
                  ),
                ),
              const SizedBox(height: 4),
              if (dots[i] != null)
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dots[i],
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccuracyCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildDonutChart(),
              const SizedBox(width: 30),
              const Expanded(child: _ChartLegend()),
            ],
          ),
          const SizedBox(height: 35),
          _trackRow("Happy Tracks", 0.82, "10", happyColor),
          const SizedBox(height: 20),
          _trackRow("Peaceful Tracks", 0.45, "8", pinkAccent),
        ],
      ),
    );
  }

  Widget _buildDonutChart() {
    return SizedBox(
      height: 110,
      width: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(110, 110), painter: DonutPainter()),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "94.2%",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Avg",
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
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
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              count,
              style: TextStyle(
                color: color,
                fontSize: 12,
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
            color: color,
            backgroundColor: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF232145),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: purpleAccent,
            child: Icon(Icons.trending_up, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.white70, fontSize: 13),
                children: [
                  TextSpan(text: "You were "),
                  TextSpan(
                    text: "15% more Peaceful ",
                    style: TextStyle(
                      color: Color(0xFFE598D0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: "this month compared to last."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsistencyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified, color: Color(0xFFE598D0), size: 26),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MOOD CONSISTENCY",
                style: TextStyle(
                  color: purpleAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Oct 12th: 98% Accuracy",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sw = 12.0;
    Rect rect =
        Offset(sw / 2, sw / 2) & Size(size.width - sw, size.height - sw);
    Paint p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round;

    p.color = Colors.white.withOpacity(0.05);
    canvas.drawArc(rect, 0, 2 * math.pi, false, p);

    p.color = const Color(0xFF8E24AA);
    canvas.drawArc(rect, -math.pi / 2, 1.7 * math.pi, false, p);

    p.color = const Color(0xFF1E88E5);
    canvas.drawArc(rect, 0.8 * math.pi, 0.5 * math.pi, false, p);
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend();
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LItem(Color(0xFFAB47BC), "Happy: 98%"),
        _LItem(Color(0xFF66BB6A), "Peaceful: 92%"),
        _LItem(Color(0xFF42A5F5), "Sad: 89%"),
        _LItem(Color(0xFFEF5350), "Energetic: 85%"),
        _LItem(Color(0xFFFFA726), "Melancholy: 40%"),
        _LItem(Color(0xFF8D6E63), "Anxious: 25%"),
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
          Text(t, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }
}
