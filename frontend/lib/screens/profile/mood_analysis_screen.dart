import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoodAnalyticsScreen extends StatelessWidget {
  const MoodAnalyticsScreen({super.key});

  static const Color bgColor = Color(0xFF13112B);
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
        title: const Text(
          "Mood Analytics",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    "TODAY'S PEAK",
                    "Peaceful",
                    "Maintained for 6 hours",
                    Icons.wb_sunny_outlined,
                    purpleAccent,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStateCard(
                    "ACTIVE STATE",
                    "Creative",
                    "Higher than yesterday",
                    Icons.auto_awesome,
                    const Color(0xFFC06CFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Mood Distribution",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
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
            _buildViewMonthlyButton(context), // 👈 pass context
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
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
              const Text(
                "Daily Mood Average",
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: greenAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "↗ 12%",
                  style: TextStyle(
                    color: greenAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "7.8",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8, left: 4),
                child: Text(
                  "/10",
                  style: TextStyle(color: Colors.white38, fontSize: 18),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "DAY 1",
                style: TextStyle(color: Colors.white24, fontSize: 9),
              ),
              Text(
                "DAY 10",
                style: TextStyle(color: Colors.white24, fontSize: 9),
              ),
              Text(
                "DAY 20",
                style: TextStyle(color: Colors.white24, fontSize: 9),
              ),
              Text(
                "DAY 30",
                style: TextStyle(color: Colors.white24, fontSize: 9),
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
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
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
        _moodChip(
          "Happy",
          "42%",
          Colors.purple,
          Icons.sentiment_very_satisfied,
        ),
        _moodChip("Peaceful", "28%", Colors.green, Icons.eco),
        _moodChip("Sad", "15%", Colors.blue, Icons.sentiment_dissatisfied),
        _moodChip("Anxious", "15%", Colors.orange, Icons.warning_amber_rounded),
        _moodChip("Melancholy", "18%", Colors.indigo, Icons.opacity),
        _moodChip("Energetic", "40%", Colors.teal, Icons.bolt),
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
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(width: 6),
          Text(
            percent,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weekly Trend",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                "+12% Positive",
                style: TextStyle(
                  color: greenAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Text(
            "Stable & Growing",
            style: TextStyle(
              color: pinkAccent,
              fontSize: 22,
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
          const Text(
            "You stayed calm for most of the day",
            style: TextStyle(color: Colors.white70, fontSize: 13),
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
              const Text(
                "October 2023",
                style: TextStyle(
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
          const Row(
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

  // 👇 Now navigates to /monthly-analytics
  Widget _buildViewMonthlyButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/monthly-analytics'), // 👈 added navigation
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFF24224D),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            "View Monthly Analytics",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ── Bottom Navigation (UPDATED) ────────────────────────────────────────────
  Widget _buildBottomNav(BuildContext context) {
    final items = [
      const _NavItem(icon: Icons.home_rounded, label: 'HOME', route: '/home'),
      const _NavItem(
        icon: Icons.search_rounded,
        label: 'EXPLORE',
        route: '/search',
      ),
      const _NavItem(
        icon: Icons.library_music_rounded,
        label: 'LIBRARY',
        route: '/library',
      ),
      const _NavItem(
        icon: Icons.history_rounded,
        label: 'HISTORY',
        route: '/history',
      ),
      const _NavItem(
        icon: Icons.person_rounded,
        label: 'PROFILE',
        route: '/profile',
      ),
    ];

    // 👇 ONLY THE VISUAL DESIGN CHANGES BELOW 👇
    return Container(
      color: const Color(0xFF080716),
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected =
              index == 4; // Hardcoded to 4 since this is a sub-page of Profile

          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                context.go(items[index].route);
              } else {
                // If they click Profile while in analytics, just go back to the main profile page
                context.pop();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  items[index].icon,
                  color: isSelected
                      ? const Color(0xFFE040FB)
                      : Colors.white.withOpacity(0.4),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  items[index].label,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFFE040FB)
                        : Colors.white.withOpacity(0.4),
                    fontSize: 9,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          );
        }),
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
          style: const TextStyle(
            color: Colors.white24,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
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
          style: TextStyle(
            color: isMuted ? Colors.white12 : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
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

// ── Nav Item Model ─────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
