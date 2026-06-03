import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/models/song_model.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerScreen extends StatefulWidget {
  final Song currentSong;
  final List<Song> playlist;
  final int initialIndex;

  const PlayerScreen({
    super.key,
    required this.currentSong,
    required this.playlist,
    this.initialIndex = 0,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  double _sliderValue = 0;
  bool _isPlaying = true;
  bool _isShuffle = false;
  bool _isRepeat = false;

  // Animation for album art pop-in
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;

  Song get _song => widget.playlist[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _playNext() {
    if (_currentIndex < widget.playlist.length - 1) {
      setState(() {
        _currentIndex++;
        _sliderValue = 0;
      });
      _animCtrl.forward(from: 0);
    }
  }

  void _playPrev() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _sliderValue = 0;
      });
      _animCtrl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            _buildTopBar(context),

            const SizedBox(height: 24),

            // ── Album Art ──
            _buildAlbumArt(),

            const SizedBox(height: 32),

            // ── Song Info ──
            _buildSongInfo(),

            const SizedBox(height: 28),

            // ── Progress Slider ──
            _buildProgressSlider(),

            const SizedBox(height: 24),

            // ── Controls ──
            _buildControls(),

            const SizedBox(height: 32),

            // ── Playlist Queue Preview ──
            _buildQueuePreview(),
          ],
        ),
      ),
    );
  }

  // ── Top Bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                'NOW PLAYING',
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '${_currentIndex + 1} / ${widget.playlist.length}',
                style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: const Icon(Icons.more_vert, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  // ── Album Art ─────────────────────────────────────────────────────────────
  Widget _buildAlbumArt() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Hero(
        tag: 'album_art_${_song.id}',
        child: Container(
          height: 280,
          width: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              _song.coverUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF1E1E3A),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white24,
                  size: 80,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Song Info ─────────────────────────────────────────────────────────────
  Widget _buildSongInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _song.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _song.artist,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          // Favourite toggle
          GestureDetector(
            onTap: () => setState(() {}),
            child: Icon(
              _song.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _song.isFavorite ? Colors.pinkAccent : Colors.white38,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  // ── Progress Slider ───────────────────────────────────────────────────────
  Widget _buildProgressSlider() {
    // Convert slider 0–100 to mm:ss
    String _fmt(double val) {
      final total = 225; // dummy total seconds (3:45)
      final secs = (val / 100 * total).round();
      final m = secs ~/ 60;
      final s = secs % 60;
      return '$m:${s.toString().padLeft(2, '0')}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white12,
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              onChanged: (val) => setState(() => _sliderValue = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _fmt(_sliderValue),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                Text(
                  '3:45',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Controls ──────────────────────────────────────────────────────────────
  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Shuffle
          GestureDetector(
            onTap: () => setState(() => _isShuffle = !_isShuffle),
            child: Icon(
              Icons.shuffle_rounded,
              color: _isShuffle ? Colors.white : Colors.white38,
              size: 24,
            ),
          ),

          // Previous
          GestureDetector(
            onTap: _playPrev,
            child: Icon(
              Icons.skip_previous_rounded,
              color: _currentIndex > 0 ? Colors.white : Colors.white24,
              size: 42,
            ),
          ),

          // Play / Pause
          GestureDetector(
            onTap: () => setState(() => _isPlaying = !_isPlaying),
            child: Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white24,
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: const Color(0xFF0D1135),
                size: 36,
              ),
            ),
          ),

          // Next
          GestureDetector(
            onTap: _playNext,
            child: Icon(
              Icons.skip_next_rounded,
              color: _currentIndex < widget.playlist.length - 1
                  ? Colors.white
                  : Colors.white24,
              size: 42,
            ),
          ),

          // Repeat
          GestureDetector(
            onTap: () => setState(() => _isRepeat = !_isRepeat),
            child: Icon(
              Icons.repeat_rounded,
              color: _isRepeat ? Colors.white : Colors.white38,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // ── Queue Preview ─────────────────────────────────────────────────────────
  Widget _buildQueuePreview() {
    // Show up to 2 upcoming songs
    final upcoming = widget.playlist
        .sublist(_currentIndex + 1)
        .take(2)
        .toList();

    if (upcoming.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEXT UP',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          ...upcoming.map(
            (song) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      song.coverUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 40,
                        height: 40,
                        color: const Color(0xFF1E1E3A),
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white24,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          song.artist,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
