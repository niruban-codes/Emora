import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const EmoraApp());
}

class EmoraApp extends StatelessWidget {
  const EmoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0F0E2A),
        fontFamily: 'sans-serif',
      ),
      home: const PlaylistDetailsScreen(),
    );
  }
}

// ── Data model ──────────────────────────────────────────────────────────────
class SongItem {
  final String title;
  final String artist;
  final String duration;
  final Color albumColor;
  final IconData albumIcon;
  final bool isPlaying;

  const SongItem({
    required this.title,
    required this.artist,
    required this.duration,
    required this.albumColor,
    required this.albumIcon,
    this.isPlaying = false,
  });
}

// ── Main Screen ──────────────────────────────────────────────────────────────
class PlaylistDetailsScreen extends StatefulWidget {
  const PlaylistDetailsScreen({super.key});

  @override
  State<PlaylistDetailsScreen> createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen> {
  int _currentNavIndex = 2; // Library tab active

  // Currently playing song index
  int _playingIndex = 2;

  final List<SongItem> _songs = const [
    SongItem(
      title: 'Morning Zen',
      artist: 'Serenity Now',
      duration: '3:45',
      albumColor: Color(0xFF2D5A4E),
      albumIcon: Icons.landscape,
    ),
    SongItem(
      title: 'Quiet Waters',
      artist: 'Flowing Echoes',
      duration: '4:12',
      albumColor: Color(0xFF1A3D2B),
      albumIcon: Icons.forest,
    ),
    SongItem(
      title: 'First Light',
      artist: 'Ambient Dreams',
      duration: '2:58',
      albumColor: Color(0xFF1A1A2E),
      albumIcon: Icons.bar_chart,
      isPlaying: true,
    ),
    SongItem(
      title: 'Soft Horizon',
      artist: 'Luna Park',
      duration: '5:30',
      albumColor: Color(0xFF3D2B1A),
      albumIcon: Icons.wb_twilight,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E2A),
      body: Column(
        children: [
          // ── Scrollable content ──
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Top bar
                SliverToBoxAdapter(child: _buildTopBar()),
                // Cover art + info
                SliverToBoxAdapter(child: _buildCoverSection()),
                // Action buttons
                SliverToBoxAdapter(child: _buildActionButtons()),
                // Song list
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildSongTile(_songs[index], index),
                    childCount: _songs.length,
                  ),
                ),
                // Bottom padding so mini player doesn't overlap last song
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),

          // ── Mini Player ──
          _buildMiniPlayer(),

          // ── Bottom Nav ──
          _buildBottomNav(),
        ],
      ),
    );
  }

  // ── Top App Bar ─────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _iconButton(Icons.arrow_back_ios_new_rounded, () {}),
            const Text(
              'PLAYLIST',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.5,
              ),
            ),
            _iconButton(Icons.search_rounded, () {}),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  // ── Cover Art + Info ─────────────────────────────────────────────────────
  Widget _buildCoverSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Album art
          Container(
            width: double.infinity,
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background simulating the peaceful lake image
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFB8C9D8), // pale sky
                          Color(0xFF8FAFC2), // mid sky
                          Color(0xFF6B8FA8), // horizon
                          Color(0xFF3D5C72), // water
                          Color(0xFF1A2F3D), // deep water
                        ],
                        stops: [0.0, 0.25, 0.45, 0.7, 1.0],
                      ),
                    ),
                  ),
                  // Silhouette trees left
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: _treeSilhouette(80, 140, const Color(0xFF0D1F15)),
                  ),
                  // Silhouette trees right
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: _treeSilhouette(70, 120, const Color(0xFF0D1F15)),
                  ),
                  // Mist / reflection overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF3D5C72).withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Playlist name
          const Text(
            'Peaceful Morning',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Emora Curated',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 13,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  '•',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '24 tracks',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 13,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  '•',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '1h 15m',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Simple tree silhouette using a CustomPainter-free approach
  Widget _treeSilhouette(double width, double height, Color color) {
    return CustomPaint(
      size: Size(width, height),
      painter: _TreePainter(color: color),
    );
  }

  // ── Play / Shuffle Buttons ────────────────────────────────────────────────
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Play button (filled)
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9C27B0).withOpacity(0.5),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Play',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Shuffle button (outlined)
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFFAB47BC),
                    width: 1.8,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shuffle_rounded,
                      color: Colors.white.withOpacity(0.85),
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Shuffle',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Song Tile ────────────────────────────────────────────────────────────
  Widget _buildSongTile(SongItem song, int index) {
    final bool isPlaying = index == _playingIndex;

    return GestureDetector(
      onTap: () => setState(() => _playingIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isPlaying
              ? const Color(0xFF6A1B7A).withOpacity(0.45)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Album art
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: song.albumColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: isPlaying
                  ? const Icon(
                      Icons.bar_chart_rounded,
                      color: Color(0xFFCE93D8),
                      size: 26,
                    )
                  : Icon(
                      song.albumIcon,
                      color: Colors.white.withOpacity(0.7),
                      size: 24,
                    ),
            ),
            const SizedBox(width: 14),

            // Title + Artist
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      color: isPlaying ? const Color(0xFFCE93D8) : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: isPlaying
                          ? const Color(0xFFCE93D8).withOpacity(0.75)
                          : Colors.white.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Duration
            Text(
              song.duration,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),

            // 3-dot menu
            Icon(
              Icons.more_vert_rounded,
              color: Colors.white.withOpacity(0.45),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ── Mini Player Bar ──────────────────────────────────────────────────────
  Widget _buildMiniPlayer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9C27B0).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Song info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'First Light',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Ambient Dreams',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Skip next
          Icon(
            Icons.skip_next_rounded,
            color: Colors.white.withOpacity(0.85),
            size: 26,
          ),
          const SizedBox(width: 10),

          // Pause button
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pause_rounded,
              color: Color(0xFF6A1B9A),
              size: 22,
            ),
          ),
        ],
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
            onTap: () {
              setState(() => _currentNavIndex = i);
              if (i == 1) {
                context.push(
                  '/search',
                ); // 👈 Explore navigates to Search screen
              }
            },
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

// ── Tree Silhouette Painter ───────────────────────────────────────────────────
class _TreePainter extends CustomPainter {
  final Color color;
  const _TreePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final w = size.width;
    final h = size.height;

    // Draw several overlapping triangles to simulate tree silhouettes
    final trees = [
      _triangle(canvas, paint, w * 0.1, h, w * 0.45, h * 0.3, w * 0.8, h),
      _triangle(canvas, paint, w * 0.0, h, w * 0.3, h * 0.5, w * 0.6, h),
      _triangle(canvas, paint, w * 0.3, h, w * 0.6, h * 0.4, w * 0.9, h),
      _triangle(canvas, paint, w * 0.5, h, w * 0.75, h * 0.55, w * 1.0, h),
    ];
  }

  void _triangle(
    Canvas canvas,
    Paint paint,
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    final path = Path()
      ..moveTo(x1, y1)
      ..lineTo(x2, y2)
      ..lineTo(x3, y3)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
