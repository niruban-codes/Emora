import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/models/song_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

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
  // late int _currentIndex;
  // // double _sliderValue = 0;
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  late int _currentIndex;
  //List<int> _playbackOrder = [];
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isUserSeeking = false;

  bool _isPlaying = true;
  bool _isShuffle = false;
  bool _isRepeat = false;

  // Animation for album art pop in
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;

  Song get _song => widget.playlist[_currentIndex];

  final String baseUrl =
      "https://emora-api-backend-ggccceepbsa2f4dk.eastasia-01.azurewebsites.net/favorites";
  final String currentUid = "test_user_uid";

  Future<void> _toggleFavorite() async {
    final song = _song;
    final isFav = song.isFavorite;

    setState(() {
      song.isFavorite = !isFav;
    });

    try {
      if (isFav) {
        final response = await http.delete(
          Uri.parse('$baseUrl/$currentUid/remove'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"videoId": song.id}),
        );
        if (response.statusCode != 200) throw Exception("Failed to remove");
      } else {
        final response = await http.post(
          Uri.parse('$baseUrl/$currentUid/add'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "videoId": song.id,
            "title": song.title,
            "artist": song.artist,
            "thumbnail": song.coverUrl,
            "mood": song.mood,
          }),
        );
        if (response.statusCode != 200) throw Exception("Failed to save");
      }
    } catch (e) {
      setState(() {
        song.isFavorite = isFav;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating favorite: $e')));
    }
  }

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
    )..addListener(_onPlayerControllerUpdate);
  }

  void _onPlayerControllerUpdate() {
    if (mounted && _ytController.value.isReady && !_isUserSeeking) {
      setState(() {
        _currentPosition = _ytController.value.position;
        _totalDuration = _ytController.value.metaData.duration;
        _isPlaying = _ytController.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _ytController.removeListener(_onPlayerControllerUpdate);
    _animCtrl.dispose();
    super.dispose();
  }

  void _playNext() {
    if (_isRepeat) {
      _ytController.seekTo(Duration.zero);
      _ytController.play();
      return;
    }

    if (_isShuffle && widget.playlist.length > 1) {
      int newIndex;
      do {
        newIndex = Random().nextInt(widget.playlist.length);
      } while (newIndex == _currentIndex);

      setState(() {
        _currentIndex = newIndex;
        _currentPosition = Duration.zero;
        _isPlaying = true;
      });
    } else if (_currentIndex < widget.playlist.length - 1) {
      setState(() {
        _currentIndex++;
        _currentPosition = Duration.zero;
        //_isPlaying = true;
      });
    } else {
      return;
    }

    _ytController.load(_song.id);
    //_ytController.play();
    _animCtrl.forward(from: 0);
  }

  void _playPrev() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _currentPosition = Duration.zero;
        //_isPlaying = true;
      });
      _ytController.load(_song.id);
      _ytController.play();
      _animCtrl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _ytController,
        showVideoProgressIndicator: false,
        progressIndicatorColor: const Color(0xFFA7338A),
        onReady: () => setState(() => _isLoading = false),
        // onEnded: (metaData) {
        //   Future.delayed(const Duration(milliseconds: 200), () {
        //     if (mounted) {
        //     _playNext();
        //     }
        //   });
        // },
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
          const SizedBox(width: 38, height: 38),
        ],
      ),
    );
  }

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
            onTap: _toggleFavorite,
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
    final totalMs = _totalDuration.inMilliseconds.toDouble();
    final currentMs = _currentPosition.inMilliseconds.toDouble();

    double sliderValue = (totalMs > 0 && currentMs <= totalMs)
        ? currentMs
        : 0.0;
    double maxSliderValue = totalMs > 0 ? totalMs : 1.0;

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
              value: sliderValue,
              min: 0,
              max: maxSliderValue,
              onChangeStart: (val) {
                _isUserSeeking = true;
              },
              onChanged: (val) {
                setState(() {
                  _currentPosition = Duration(milliseconds: val.toInt());
                });
              },
              onChangeEnd: (val) {
                _ytController.seekTo(Duration(milliseconds: val.toInt()));
                _isUserSeeking = false;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_currentPosition),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                Text(
                  _formatDuration(_totalDuration),
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
