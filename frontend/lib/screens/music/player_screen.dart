import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/models/song_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  // Animation for album art pop in
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;

  late YoutubePlayerController _ytController;
  bool _isLoading = true;
  bool _hasError = false;
  final Set<String> _favorites = {};
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
    _ytController = YoutubePlayerController(
      initialVideoId: _song.id,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _ytController.dispose();
    super.dispose();
  }

  void _playNext() {
    if (_currentIndex < widget.playlist.length - 1) {
      setState(() {
        _currentIndex++;
        _sliderValue = 0;
      });
      _ytController.load(_song.id);
      _animCtrl.forward(from: 0);
    }
  }

  void _playPrev() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _sliderValue = 0;
      });
      _ytController.load(_song.id);
      _animCtrl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _ytController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: const Color(0xFFA7338A),
        onReady: () => setState(() => _isLoading = false),
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: const Color(0xFF0D0C1D),
          body: SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),

                const SizedBox(height: 24),
                _buildAlbumArt(),

                const SizedBox(height: 32),
                _buildSongInfo(),

                const SizedBox(height: 28),
                _buildProgressSlider(),

                const SizedBox(height: 24),
                _buildControls(),

                const SizedBox(height: 32),
                _buildQueuePreview(),
              ],
            ),
          ),
        );
      },
    );
  }

  //Top Bar
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                'NOW PLAYING',
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '${_currentIndex + 1} / ${widget.playlist.length}',
                style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(
            width: 38,
            height: 38,
          )
        ],
      ),
    );
  }

  Widget _buildAlbumArt() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: YoutubePlayer(
          controller: _ytController,
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color(0xFFA7338A),
          onReady: () => setState(() => _isLoading = false),
        ),
      ),
    );
  }

  //Song Info
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

  //Progress Slider
  Widget _buildProgressSlider() {
    String fmt(double val) {
      final total = 225;
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
                  fmt(_sliderValue),
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

  //Controls
  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
            onTap: () {
              _isPlaying ? _ytController.pause() : _ytController.play();
              setState(() => _isPlaying = !_isPlaying);
            },
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

  //Queue Preview
  Widget _buildQueuePreview() {
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
