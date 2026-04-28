import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedIndex = 2; // Library tab active

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
      'icon': Icons.water_drop_outlined,
      'baseColor': const Color(0xFF64B5F6),
    },
    {
      'title': 'Fear',
      'subtitle': 'Tense',
      'icon': Icons.dark_mode_outlined,
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
    {
      'title': 'Neutral',
      'subtitle': 'Ambient',
      'icon': Icons.lens_blur_rounded,
      'baseColor': Colors.grey.shade400,
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
                    onTap: () => context.push('/profile'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1.5,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://via.placeholder.com/150',
                          ), // Replace with actual user profile image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Library',
                    // 👇 Changed to Arvo for main header
                    style: GoogleFonts.arvo(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
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
                return _buildMoodCard(
                  title: item['title'],
                  subtitle: item['subtitle'],
                  icon: item['icon'],
                  baseColor: item['baseColor'],
                  isHighlight: index == 0, // Highlight the "Liked Songs"
                );
              },
            ),
          ),

          // Bottom Navigation
          _buildBottomNav(),
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
        color: const Color(0xFF16142E), // Slightly lighter than bg
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
          // Elegant subtle gradient matching the icon color
          Positioned(
            right: -30,
            top: -20,
            bottom: -20,
            width: 150,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [baseColor.withOpacity(0.15), Colors.transparent],
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
                        : const Color(0xFF0D0C1D), // Dark inner circle
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
                        // 👇 Changed to Arvo for Card Title
                        style: GoogleFonts.arvo(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        // 👇 Kept Poppins for Card Subtitle
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chevron Icon to indicate action
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

  // ── Bottom Navigation ─────────────
  Widget _buildBottomNav() {
    final navItems = [
      {'icon': Icons.home_rounded, 'label': 'HOME'},
      {'icon': Icons.search_rounded, 'label': 'EXPLORE'},
      {'icon': Icons.library_music_rounded, 'label': 'LIBRARY'},
      {'icon': Icons.history_rounded, 'label': 'HISTORY'},
      {'icon': Icons.person_rounded, 'label': 'PROFILE'},
    ];

    // 👇 ONLY THE VISUAL DESIGN CHANGES BELOW 👇
    return Container(
      color: const Color(0xFF080716),
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });

              switch (index) {
                case 0:
                  context.push('/home'); // HOME
                  break;
                case 1:
                  context.push('/search'); // EXPLORE
                  break;
                case 2:
                  break;
                case 3:
                  context.push('/history'); // HISTORY
                  break;
                case 4:
                  context.push('/profile'); // PROFILE
                  break;
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  navItems[index]['icon'] as IconData,
                  color: isSelected
                      ? const Color(0xFFE040FB)
                      : Colors.white.withOpacity(0.4),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  navItems[index]['label'] as String,
                  style: GoogleFonts.poppins(
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
