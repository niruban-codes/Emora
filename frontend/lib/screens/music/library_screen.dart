import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/screens/emotion/mood_model.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Map<String, dynamic>> _libraryItems = [
    {
      'title': 'Liked Songs',
      'subtitle': '248 Tracks',
      'icon': Icons.favorite_rounded,
      'baseColor': const Color(0xFFE040FB),
    },
    {
      'title': 'Happy',
      'subtitle': 'Uplifting',
      'icon': Icons.sentiment_very_satisfied_rounded,
      'baseColor': const Color(0xFFFFB74D),
    },
    {
      'title': 'Sad',
      'subtitle': 'Reflective',
      'icon': Icons.sentiment_dissatisfied_rounded,
      'baseColor': const Color(0xFF64B5F6),
    },
    {
      'title': 'Neutral',
      'subtitle': 'Ambient',
      'icon': Icons.lens_blur_rounded,
      'baseColor': Colors.grey.shade400,
    },
    {
      'title': 'Fear',
      'subtitle': 'Tense',
      'icon': Icons.sentiment_very_dissatisfied_outlined,
      'baseColor': const Color(0xFF9575CD),
    },
    {
      'title': 'Angry',
      'subtitle': 'Cathartic',
      'icon': Icons.local_fire_department_outlined,
      'baseColor': const Color(0xFFE57373),
    },
    {
      'title': 'Surprise',
      'subtitle': 'Ethereal',
      'icon': Icons.flare_rounded,
      'baseColor': const Color(0xFF4DB6AC),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      body: Column(
        children: [
          // Custom Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 16.0,
                bottom: 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  Text(
                    'Library',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/search'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFFCE93D8),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Scrollable Area
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              itemCount: _libraryItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = _libraryItems[index];
                return GestureDetector(
                  onTap: () {
                    if (item['title'] == 'Liked Songs') {
                      context.push('/favorites', extra: 'All');
                    } else {
                      final String selectedMood = item['title'].toString();
                      context.push('/playlist', extra: selectedMood);
                    }
                  },
                  child: _buildMoodCard(
                    title: item['title'],
                    subtitle: item['subtitle'],
                    icon: item['icon'],
                    baseColor: item['baseColor'],
                    isHighlight: index == 0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color baseColor,
    required bool isHighlight,
  }) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: const Color(0xFF16142E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHighlight
              ? baseColor.withOpacity(0.3)
              : Colors.white.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned(
            right: -30,
            top: -20,
            bottom: -20,
            width: 150,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    baseColor.withOpacity(0.9),
                    Colors.transparent,
                    baseColor.withOpacity(0.0),
                  ],
                  center: Alignment.centerRight,
                  radius: 0.8,
                ),
              ),
            ),
          ),

          // Card Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: isHighlight
                        ? baseColor.withOpacity(0.2)
                        : const Color(0xFF0D0C1D),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isHighlight
                          ? baseColor.withOpacity(0.5)
                          : Colors.transparent,
                    ),
                  ),
                  child: Icon(icon, color: baseColor, size: 26),
                ),
                const SizedBox(width: 20),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withOpacity(0.2),
                  size: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
