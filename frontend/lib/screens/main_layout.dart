import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MainLayout extends StatelessWidget {
  // This shell manages the state of all our tabs automatically!
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15173D), // Fallback background
      body:
          navigationShell, // 👈 This is where Home, Library, etc. get injected
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ── Bottom Navigation (Unified Master Copy) ────────────────────────────────
  Widget _buildBottomNav(BuildContext context) {
    final items = [
      const _NavItem(icon: Icons.home_rounded, label: 'HOME'),
      const _NavItem(icon: Icons.search_rounded, label: 'EXPLORE'),
      const _NavItem(icon: Icons.library_music_rounded, label: 'LIBRARY'),
      const _NavItem(icon: Icons.history_rounded, label: 'HISTORY'),
      const _NavItem(icon: Icons.person_rounded, label: 'PROFILE'),
    ];

    return Container(
      color: const Color(0xFF080716),
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          // GoRouter automatically knows which tab is active!
          final isSelected = index == navigationShell.currentIndex;

          return GestureDetector(
            onTap: () {
              // This single magical line handles all tab switching and state saving
              navigationShell.goBranch(
                index,
                // If they tap the active tab again, it pops them back to the root of that tab
                initialLocation: index == navigationShell.currentIndex,
              );
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

// ── Nav Item Model ─────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
