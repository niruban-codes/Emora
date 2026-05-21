import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodAnalyticsScreen extends StatelessWidget {
  const MoodAnalyticsScreen({super.key});

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
        title:  Text(
          "Mood Analytics",
          style: GoogleFonts.poppins(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 20,
            ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDailyAverageCard(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStateCard(
                    "Today's Peak",
                    "Peaceful",
                    "Maintained for 6 hours",
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
            Text (
              "Mood Distribution",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildMoodDistributionGrid(),
            const SizedBox(height: 30),
            _buildWeeklyTrendCard(),
            const SizedBox(height: 30),
            _buildCalendarGrid(),
            const SizedBox(height: 25),
            _buildViewMonthlyButton(context), //  pass context
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyAverageCard() {
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
                  color: greenAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Text(
                  "↗ 12%",
                  style: GoogleFonts.poppins(
                    color: greenAccent,
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
                "7.8",
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
                  style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            width: double.infinity,
            child: CustomPaint(painter: WavePainter(pinkAccent)),
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "DAY 1",
                style: GoogleFonts.poppins(color: Colors.white24, fontSize: 11),
              ),
              Text(
                "DAY 10",
                style: GoogleFonts.poppins(color: Colors.white24, fontSize: 11),
              ),
              Text(
                "DAY 20",
                style: GoogleFonts.poppins(color: Colors.white24, fontSize: 11),
              ),
              Text(
                "DAY 30",
                style: GoogleFonts.poppins(color: Colors.white24, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStateCard(
    String label,
    String value,
    String sub,
    IconData icon,
    Color color,
  ) {
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
            style:  GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodDistributionGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _moodChip("Happy", "42%", Color(0xFFFFB347), Icons.sentiment_very_satisfied_rounded,),
        _moodChip("Sad", "15%", Color(0xFF42A5F5), Icons.sentiment_dissatisfied_rounded,),
        _moodChip("Neutral", "28%", Color(0xFF78909C), Icons.lens_blur_rounded,),
        _moodChip("Fear", "12%", Color(0xFF7E57C2), Icons.sentiment_very_dissatisfied_outlined,),
        _moodChip("Angry", "8%", Color(0xFFEF5350), Icons.local_fire_department_outlined,),
        _moodChip("Surprised", "20%", Color(0xFF4DB6AC), Icons.flare_rounded,),
      ],
    );
  }

  Widget _moodChip(String label, String percent, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(width: 6),
          Text(
            percent,
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendCard() {
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
                "+12% Positive",
                style: GoogleFonts.poppins(
                  color: greenAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
           Text(
            "Stable & Growing",
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
            child: CustomPaint(painter: WavePainter(purpleAccent)),
          ),
          const SizedBox(height: 10),
           Text(
            "You stayed calm for most of the day",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "October 2023",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.chevron_left, color: pinkAccent.withOpacity(0.5)),
                  Icon(Icons.chevron_right, color: pinkAccent.withOpacity(0.5)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DayHeader("S"),
              _DayHeader("M"),
              _DayHeader("T"),
              _DayHeader("W"),
              _DayHeader("T"),
              _DayHeader("F"),
              _DayHeader("S"),
            ],
          ),
          const SizedBox(height: 15),
          _buildCalendarRow(
            ["28", "29", "30", "1", "2", "3", "4"],
            [
              null,
              null,
              null,
              purpleAccent,
              purpleAccent,
              pinkAccent,
              Colors.orange,
            ],
            isFirst: true,
          ),
          const SizedBox(height: 12),
          _buildCalendarRow(
            ["5", "6", "7", "8", "9", "10", "11"],
            [
              pinkAccent,
              Colors.blue,
              pinkAccent,
              purpleAccent,
              null,
              null,
              null,
            ],
            selectedDay: "8",
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarRow(
    List<String> days,
    List<Color?> colors, {
    String? selectedDay,
    bool isFirst = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        bool isMuted = isFirst && index < 3;
        bool isDashed = !isFirst && index > 3;
        return _DateCircle(
          days[index],
          colors[index],
          isSelected: days[index] == selectedDay,
          isMuted: isMuted,
          isDashed: isDashed,
        );
      }),
    );
  }

  //  Now navigates to /monthly-analytics
  Widget _buildViewMonthlyButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/monthly-analytics'), //  added navigation
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFF24224D),
          borderRadius: BorderRadius.circular(16),
        ),
        child:  Center(
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

class _DayHeader extends StatelessWidget {
  final String label;
  const _DayHeader(this.label);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white24,
            fontSize: 13, 
            fontWeight: FontWeight.bold,
          ), //calender day heads
        ),
      ),
    );
  }
}

class _DateCircle extends StatelessWidget {
  final String text;
  final Color? color;
  final bool isSelected;
  final bool isMuted;
  final bool isDashed;

  const _DateCircle(
    this.text,
    this.color, {
    this.isSelected = false,
    this.isMuted = false,
    this.isDashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: color?.withOpacity(isSelected ? 1.0 : 0.6),
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: Colors.white, width: 2)
            : isDashed
            ? Border.all(color: Colors.white10)
            : null,
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isMuted ? Colors.white12 : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ), //calender numbers
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;
  WavePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    var path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.4,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.8,
      size.width * 0.8,
      size.height * 0.3,
    );
    path.lineTo(size.width, size.height * 0.4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
