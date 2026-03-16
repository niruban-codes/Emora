import 'package:flutter/material.dart';

class SearchMoodScreen extends StatefulWidget {
  const SearchMoodScreen({super.key});

  @override
  State<SearchMoodScreen> createState() => _SearchMoodScreenState();
}

class _SearchMoodScreenState extends State<SearchMoodScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentNavIndex = 1; // Explore tab active

  // Mood data
  final List<Map<String, dynamic>> _moods = [
    {'label': 'Happy', 'icon': Icons.wb_sunny_outlined},
    {'label': 'Peaceful', 'icon': Icons.cloud_outlined},
    {'label': 'Melancholy', 'icon': Icons.nights_stay_outlined},
    {'label': 'Anxious', 'icon': Icons.air_outlined},
    {'label': 'Energetic', 'icon': Icons.bolt_outlined},
    {'label': 'Sad', 'icon': Icons.water_drop_outlined},
  ];

  // Recent searches
  final List<Map<String, String>> _recentSearches = [
    {'title': 'After Hours', 'subtitle': 'The Weeknd', 'type': 'album'},
    {'title': 'Arctic Monkeys', 'subtitle': 'Artist', 'type': 'artist'},
  ];

  // Browse all categories
  final List<Map<String, dynamic>> _browseCategories = [
    {
      'label': 'Party Songs',
      'colors': [Color(0xFFE8A87C), Color(0xFFD4705A)],
    },
    {
      'label': 'Golden Hour',
      'colors': [Color(0xFFE8C97C), Color(0xFFD4975A)],
    },
    {
      'label': 'Focus music',
      'colors': [Color(0xFF7CB8E8), Color(0xFF5A8FD4)],
    },
    {
      'label': 'Night Remix',
      'colors': [Color(0xFF7CE8D4), Color(0xFF5AB8A0)],
    },
    {
      'label': 'Hindi Songs',
      'colors': [Color(0xFFB8C8D8), Color(0xFF8AAABB)],
    },
    {
      'label': 'Name',
      'colors': [Color(0xFFD4A8D8), Color(0xFFB07AB8)],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E2A),
      body: Column(
        children: [
          // ── Scrollable Content ──
          Expanded(
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildTopBar(),
                    const SizedBox(height: 20),
                    _buildSearchBar(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('Search by Mood', 'See all', () {}),
                    const SizedBox(height: 16),
                    _buildMoodGrid(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('Recent Searches', 'Clear', () {
                      setState(() => _recentSearches.clear());
                    }),
                    const SizedBox(height: 12),
                    _buildRecentSearches(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('Browse all', '', () {}),
                    const SizedBox(height: 16),
                    _buildBrowseGrid(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom Navigation ──
          _buildBottomNav(),
        ],
      ),
    );
  }

  // ── Top Bar ──────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2A2A4A),
            border: Border.all(
              color: const Color(0xFF6A1B9A).withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.person_rounded,
            color: Colors.white.withOpacity(0.8),
            size: 26,
          ),
        ),
      ],
    );
  }

  // ── Search Bar ───────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B3A),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Artists, songs, or podcasts',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white.withOpacity(0.4),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  // ── Section Header ───────────────────────────────────────────────────────
  Widget _buildSectionHeader(
    String title,
    String actionLabel,
    VoidCallback onAction,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (actionLabel.isNotEmpty)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel,
              style: const TextStyle(
                color: Color(0xFFCE93D8),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  // ── Mood Grid ────────────────────────────────────────────────────────────
  Widget _buildMoodGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _moods.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) => _buildMoodCard(_moods[index]),
    );
  }

  Widget _buildMoodCard(Map<String, dynamic> mood) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1B3A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF6A1B9A).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mood['icon'] as IconData,
              color: const Color(0xFFCE93D8),
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              mood['label'] as String,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Recent Searches ──────────────────────────────────────────────────────
  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'No recent searches',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    return Column(
      children: List.generate(
        _recentSearches.length,
        (index) => _buildRecentSearchTile(_recentSearches[index], index),
      ),
    );
  }

  Widget _buildRecentSearchTile(Map<String, String> item, int index) {
    final bool isArtist = item['type'] == 'artist';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2A1A3A),
              borderRadius: isArtist
                  ? BorderRadius.circular(24)
                  : BorderRadius.circular(8),
            ),
            child: Icon(
              isArtist ? Icons.person_rounded : Icons.album_rounded,
              color: const Color(0xFFCE93D8),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),

          // Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item['subtitle']!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Remove button
          GestureDetector(
            onTap: () => setState(() => _recentSearches.removeAt(index)),
            child: Icon(
              Icons.close_rounded,
              color: Colors.white.withOpacity(0.4),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // ── Browse All Grid ──────────────────────────────────────────────────────
  Widget _buildBrowseGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _browseCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) =>
          _buildBrowseCard(_browseCategories[index]),
    );
  }

  Widget _buildBrowseCard(Map<String, dynamic> category) {
    final List<Color> colors = category['colors'] as List<Color>;

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles bottom right
            Positioned(
              bottom: -10,
              right: -10,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            // Label top left
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                category['label'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Navigation Bar ─────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      _NavItem(icon: Icons.home_rounded, label: 'HOME'),
      _NavItem(icon: Icons.explore_rounded, label: 'EXPLORE'),
      _NavItem(icon: Icons.library_music_rounded, label: 'LIBRARY'),
      _NavItem(icon: Icons.history_rounded, label: 'History'),
      _NavItem(icon: Icons.person_rounded, label: 'PROFILE'),
    ];

    return Container(
      color: const Color(0xFF0A091E),
      padding: const EdgeInsets.only(top: 10, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = i == _currentNavIndex;
          return GestureDetector(
            onTap: () => setState(() => _currentNavIndex = i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  items[i].icon,
                  color: isActive
                      ? const Color(0xFFCE93D8)
                      : Colors.white.withOpacity(0.4),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  items[i].label,
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFFCE93D8)
                        : Colors.white.withOpacity(0.4),
                    fontSize: 9,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
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

// ── Nav Item Model ────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
