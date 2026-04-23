import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchMoodScreen extends StatefulWidget {
  const SearchMoodScreen({super.key});

  @override
  State<SearchMoodScreen> createState() => _SearchMoodScreenState();
}

class _SearchMoodScreenState extends State<SearchMoodScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentNavIndex = 1; // Explore tab active

  // Languages data — strongly typed, no map casts needed
  final List<_LanguageItem> _languages = const [
    _LanguageItem(label: 'English', symbol: 'Aa'),
    _LanguageItem(label: 'Tamil', symbol: 'த'),
    _LanguageItem(label: 'Sinhala', symbol: 'ස'),
    _LanguageItem(label: 'Korean', symbol: '한'),
  ];

  // Browse by Vibe – featured (large) card
  final Map<String, dynamic> _featuredVibe = {
    'label': 'Party Songs',
    'subtitle': 'Binaural rhythms & synth drones',
    'gradientColors': [Color(0xFF6A0572), Color(0xFFAD1457), Color(0xFF1A0030)],
  };

  // Browse by Vibe – secondary (small) cards
  final List<Map<String, dynamic>> _secondaryVibes = [
    {
      'label': 'Techno Vibes',
      'gradientColors': [
        Color(0xFF1A0030),
        Color(0xFF6A0572),
        Color(0xFF0D0020),
      ],
    },
    {
      'label': 'Study Music',
      'gradientColors': [
        Color(0xFF2D0050),
        Color(0xFF8B0057),
        Color(0xFF3D002A),
      ],
    },
  ];

  // Dive into Genres
  final List<String> _genres = [
    'Romance',
    'Hip Hop',
    'Rap',
    'Jazz',
    'Classical',
    'R&B',
    'Metal',
    'Pop',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildBackButton(),
                    const SizedBox(height: 20),
                    _buildSearchBar(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('Explore by Languages', '', () {}),
                    const SizedBox(height: 16),
                    _buildLanguageRow(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('Browse by Vibe', '', () {}),
                    const SizedBox(height: 16),
                    _buildFeaturedVibeCard(),
                    const SizedBox(height: 12),
                    _buildSecondaryVibeRow(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('Dive into Genres', '', () {}),
                    const SizedBox(height: 16),
                    _buildGenreChips(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  // ── Back Button ────────────────────────────────────────────────────────────
  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: const Icon(
        Icons.arrow_back_rounded,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  // ── Search Bar ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1830),
        borderRadius: BorderRadius.circular(32),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Artists, songs, or podcasts',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white.withOpacity(0.35),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  // ── Section Header ─────────────────────────────────────────────────────────
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
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
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

  // ── Language Row (horizontal scroll) ──────────────────────────────────────
  Widget _buildLanguageRow() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _languages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _buildLanguageCard(_languages[index]),
      ),
    );
  }

  Widget _buildLanguageCard(_LanguageItem lang) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF14122A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.07), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFCE93D8), Color(0xFF9C4DCC)],
            ).createShader(bounds),
            child: Text(
              lang.symbol,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            lang.label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Featured Vibe Card (large) ─────────────────────────────────────────────
  Widget _buildFeaturedVibeCard() {
    final colors = _featuredVibe['gradientColors'] as List<Color>;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: Stack(
          children: [
            // Abstract swirl overlay (top-right)
            Positioned(
              top: -20,
              right: -20,
              child: _buildAbstractBlob(130, 130, colors[1].withOpacity(0.5)),
            ),
            Positioned(
              bottom: -10,
              right: 40,
              child: _buildAbstractBlob(80, 80, colors[0].withOpacity(0.4)),
            ),
            // Fine grid texture feel
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.45), Colors.transparent],
                ),
              ),
            ),
            // Text bottom-left
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _featuredVibe['label'] as String,
                    style: const TextStyle(
                      color: Color(0xFFFF6EC7),
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _featuredVibe['subtitle'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Secondary Vibe Row (two small cards) ───────────────────────────────────
  Widget _buildSecondaryVibeRow() {
    return Row(
      children: _secondaryVibes
          .map(
            (vibe) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: vibe == _secondaryVibes.last ? 0 : 10,
                ),
                child: _buildSecondaryVibeCard(vibe),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSecondaryVibeCard(Map<String, dynamic> vibe) {
    final colors = vibe['gradientColors'] as List<Color>;

    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: Stack(
          children: [
            // Abstract circles for depth
            Positioned(
              top: -15,
              right: -15,
              child: _buildAbstractBlob(80, 80, colors[1].withOpacity(0.5)),
            ),
            Positioned(
              bottom: -10,
              left: -10,
              child: _buildAbstractBlob(55, 55, colors[0].withOpacity(0.3)),
            ),
            // Gradient scrim
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                ),
              ),
            ),
            // Label
            Positioned(
              left: 12,
              bottom: 12,
              right: 8,
              child: Text(
                vibe['label'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 6,
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

  // Helper: soft decorative blob
  Widget _buildAbstractBlob(double w, double h, Color color) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  // ── Genre Chips ────────────────────────────────────────────────────────────
  Widget _buildGenreChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _genres.map(_buildGenreChip).toList(),
    );
  }

  Widget _buildGenreChip(String genre) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.2),
        ),
        child: Text(
          genre,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ── Bottom Navigation ──────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      _NavItem(icon: Icons.home_rounded, label: 'HOME', route: '/home'),
      _NavItem(icon: Icons.search_rounded, label: 'EXPLORE', route: '/search'),
      _NavItem(
        icon: Icons.library_music_rounded,
        label: 'LIBRARY',
        route: '/insights',
      ),
      _NavItem(
        icon: Icons.history_rounded,
        label: 'History',
        route: '/history',
      ),
      _NavItem(icon: Icons.person_rounded, label: 'PROFILE', route: '/profile'),
    ];

    return Container(
      color: const Color(0xFF080716),
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = i == _currentNavIndex;
          return GestureDetector(
            onTap: () {
              if (!isActive) context.go(items[i].route);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  items[i].icon,
                  color: isActive
                      ? const Color(0xFFE040FB)
                      : Colors.white.withOpacity(0.4),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  items[i].label,
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFFE040FB)
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

// ── Language Item Model ────────────────────────────────────────────────────────
class _LanguageItem {
  final String label;
  final String symbol;
  const _LanguageItem({required this.label, required this.symbol});
}
