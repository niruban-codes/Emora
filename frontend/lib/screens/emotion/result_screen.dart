import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screens/emotion/mood_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/firestore_service.dart';
import 'package:frontend/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/song_model.dart';

class ResultScreen extends StatefulWidget {
  final MoodModel mood;
  const ResultScreen({super.key, required this.mood});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  int _currentNavIndex = 2;

  // NEW: State variables to hold the live songs
  List<Song> _recommendedSongs = [];
  bool _isLoadingSongs = true;

  Color get _primary => widget.mood.primaryColor;
  Color get _secondary => widget.mood.secondaryColor;
  Color get _labelColor => widget.mood.labelColor;

  @override
  void initState() {
    super.initState();
    _initializeData();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(ResultScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mood != widget.mood) {
      setState(() {
        _isLoadingSongs = true;
        _recommendedSongs = [];
      });
      _initializeData();
    }
  }

  Future<void> _initializeData() async {
    await _fetchRecommendedSongs();
    _savePlaylistToFirebase();
    _saveScanToAzureHistory();
  }

  Future<void> _fetchRecommendedSongs() async {
    try {
      final uri = Uri.parse(
        "https://emora-api-backend-ggccceepbsa2f4dk.eastasia-01.azurewebsites.net/youtube/recommend-music",
      );
      final uid = FirebaseAuth.instance.currentUser?.uid;

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emotion': widget.mood.label.toLowerCase(),
          'uid': uid,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _recommendedSongs = data
                .map((e) => Song.fromJson(e, defaultMood: widget.mood.label))
                .toList();
            _isLoadingSongs = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching recommended songs: $e");
      if (mounted) {
        setState(() => _isLoadingSongs = false);
      }
    }
  }

  Future<void> _savePlaylistToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("⚠️ No user logged in. Skipping playlist save.");
      return;
    }

    final firestoreService = FirestoreService();

    List<Map<String, dynamic>> playlistData = widget.mood.playlistTitles.map((
      title,
    ) {
      return {
        'playlistName': title,
        'mainSong': widget.mood.songTitle,
        'artist': widget.mood.artist,
      };
    }).toList();

    try {
      await firestoreService.savePlaylistHistory(
        emotion: widget.mood.label,
        songs: playlistData,
      );
      print("✅ History saved successfully!");
    } catch (e) {
      print("❌ Error saving history: $e");
    }
  }

  Future<void> _saveScanToAzureHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final tracks = _recommendedSongs
        .map(
          (song) => {
            'title': song.title,
            'artist': song.artist,
            'thumbnail': song.coverUrl,
            'videoId': song.id,
          },
        )
        .toList();

    if (tracks.isEmpty) {
      tracks.add({
        'title': widget.mood.songTitle,
        'artist': widget.mood.artist,
      });
    }

    try {
      final success = await ApiService().saveMoodHistoryToAzure(
        uid: user.uid,
        emotion: widget.mood.label.toLowerCase(),
        tracks: tracks,
      );

      if (success) {
        print("✅ Scan successfully saved to Azure History!");
      }
    } catch (e) {
      print("❌ Error saving scan to Azure: $e");
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D0C1D), Color(0xFF0D0C1D)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildMoodLabel(),
                        const SizedBox(height: 12),
                        _buildMoodDescription(),
                        const SizedBox(height: 32),
                        _buildSongSection(),
                        const SizedBox(height: 24),

                        const SizedBox(height: 32),
                        _buildBottomButtons(context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //  Top Bar
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleBtn(Icons.arrow_back, onTap: () => context.go('/home')),
          Text(
            'Current Mood',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 38),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(padding: const EdgeInsets.all(8.0),
      child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  //  Face Scan Area
  Widget _buildFaceScanArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF0D0C1D).withOpacity(0.5),
          border: Border.all(color: _primary.withOpacity(0.4), width: 1.5),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/face_scan.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.2,
                        colors: [
                          _primary.withOpacity(0.15),
                          const Color(0xFF0D0C1D),
                        ],
                      ),
                    ),
                    child: Center(),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _primary.withOpacity(0.15),
                        Colors.transparent,
                        _primary.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 130,
              left: 20,
              right: 20,
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, _primary, Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'NEURAL ANALYSIS',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 14,
              child: Text(
                'STATUS: COMPLETE',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 9,
                  letterSpacing: 1,
                ),
              ),
            ),
            ..._cornerBrackets(_primary),
            Positioned(
              bottom: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: _primary.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.mood.label,
                      style: GoogleFonts.poppins(
                        color: _labelColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 14,
              right: 14,
              child: Row(
                children: [
                  Text(
                    'X: 42.1  Y: 88.4',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 9,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.adjust, color: _primary, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Mood Label
  Widget _buildMoodLabel() {
    return Center(
      child: Column(
        children: [
          Text(
            'CURRENT MOOD',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [_primary, _secondary],
            ).createShader(bounds),
            child: Text(
              widget.mood.label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 44,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodDescription() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          widget.mood.description,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.45),
            fontSize: 13,
            height: 1.6,
          ),
        ),
      ),
    );
  }

  //  Song Section
  //  Song Section
  Widget _buildSongSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECOMMENDED FOR YOU',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),

          if (_isLoadingSongs)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: Colors.white54),
              ),
            )
          else if (_recommendedSongs.isEmpty)
            const Text(
              "No songs found",
              style: TextStyle(color: Colors.white54),
            )
          else
            // Take exactly 2 songs from the randomly generated list
            ..._recommendedSongs.take(2).toList().asMap().entries.map((entry) {
              final index = entry.key;
              final song = entry.value;

              return GestureDetector(
                onTap: () {
                  // Pass the FULL list of 10 songs to the player, but start at the clicked index
                  context.push(
                    '/player',
                    extra: {'songs': _recommendedSongs, 'index': index},
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          song.coverUrl,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _primary.withOpacity(0.3),
                                  _secondary.withOpacity(0.2),
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.music_note,
                              color: _labelColor,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              song.artist,
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [_primary, _secondary],
                          ),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  //  Mood Playlists
  Widget _buildMoodPlaylists() {
    final playlists = widget.mood.playlistTitles;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MOOD PLAYLISTS',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ...playlists.asMap().entries.map((entry) {
            final index = entry.key;
            final title = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _primary.withOpacity(0.15 + index * 0.05),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _primary.withOpacity(0.4),
                          _secondary.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.queue_music,
                      color: _labelColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.mood.label,
                          style: GoogleFonts.poppins(
                            color: _labelColor.withOpacity(0.7),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.white24, size: 20),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  //  Bottom Buttons
  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 8,
                shadowColor: _primary.withOpacity(0.5),
              ),
              onPressed: () => context.push('/playlist', extra: widget.mood),
              child: Text(
                'Play Mood Playlist',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.25)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              icon: Icon(
                Icons.refresh,
                color: Colors.white.withOpacity(0.65),
                size: 18,
              ),
              label: Text(
                'Recalibrate Scan',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 14,
                ),
              ),
              onPressed: () => context.push('/scan'),
            ),
          ),
        ],
      ),
    );
  }

  //  Corner Brackets
  List<Widget> _cornerBrackets(Color color) {
    const size = 20.0;
    const stroke = 2.0;

    Widget b(bool top, bool left) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border(
          top: top ? BorderSide(color: color, width: stroke) : BorderSide.none,
          bottom: !top
              ? BorderSide(color: color, width: stroke)
              : BorderSide.none,
          left: left
              ? BorderSide(color: color, width: stroke)
              : BorderSide.none,
          right: !left
              ? BorderSide(color: color, width: stroke)
              : BorderSide.none,
        ),
      ),
    );

    return [
      Positioned(top: 10, left: 10, child: b(true, true)),
      Positioned(top: 10, right: 10, child: b(true, false)),
      Positioned(bottom: 10, left: 10, child: b(false, true)),
      Positioned(bottom: 10, right: 10, child: b(false, false)),
    ];
  }
}
