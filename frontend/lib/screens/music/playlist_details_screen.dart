import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screens/emotion/mood_model.dart';
import 'package:frontend/models/song_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaylistDetailsScreen extends StatefulWidget {
  final MoodModel mood;
  const PlaylistDetailsScreen({super.key, required this.mood});

  @override
  State<PlaylistDetailsScreen> createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen> {
  int _playingIndex = 0;
  List<Song> _songs = [];
  bool _isLoading = true;

  MoodModel get _mood => widget.mood;

  @override
  void initState() {
    super.initState();
    _fetchMoodPlaylist();
  }

  Future<void> _fetchMoodPlaylist() async {
    try {
      final uri = Uri.parse(
        "https://emora-api-backend-ggccceepbsa2f4dk.eastasia-01.azurewebsites.net/youtube/recommend-music",
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'emotion': _mood.label.toLowerCase()}),
      );

      print("Azure Response Code: ${response.statusCode}");
      print("Azure Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _songs = data.map((e) => Song.fromJson(e)).toList();
            _isLoading = false;
          });
        }
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching mood playlist: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _openPlayer(int index) {
    context.push('/player', extra: {'songs': _songs, 'index': index});
  }

  @override
  Widget build(BuildContext context) {
    final songs = _songs;
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildTopBar()),
                SliverToBoxAdapter(child: _buildCoverSection(songs)),
                SliverToBoxAdapter(child: _buildActionButtons(songs)),

                if (_isLoading)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: _mood.primaryColor,
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildSongTile(songs[index], index),
                      childCount: songs.length,
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
          if (!_isLoading && songs.isNotEmpty) _buildMiniPlayer(songs),
        ],
      ),
    );
  }

  //Top Bar
  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            Text(
              'Playlist',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.5,
              ),
            ),
            const SizedBox(width: 22),
          ],
        ),
      ),
    );
  }

  //Cover Section
  Widget _buildCoverSection(List<Song> songs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _mood.primaryColor.withOpacity(0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _mood.primaryColor.withOpacity(0.8),
                      _mood.secondaryColor.withOpacity(0.5),
                      const Color(0xFF0F0E2A),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.graphic_eq_rounded,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${_mood.label[0]}${_mood.label.substring(1).toLowerCase()} Playlist',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Emora Curated',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 13,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  '•',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${songs.length} tracks',
                style: GoogleFonts.poppins(
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

  //Play / Shuffle Buttons
  Widget _buildActionButtons(List<Song> songs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _playingIndex = 0);
                _openPlayer(0);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_mood.primaryColor, _mood.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: _mood.primaryColor.withOpacity(0.5),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
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
                      style: GoogleFonts.poppins(
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
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _mood.primaryColor, width: 1.8),
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
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
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

  //Song Tile
  Widget _buildSongTile(Song song, int index) {
    final bool isPlaying = index == _playingIndex;

    return GestureDetector(
      onTap: () {
        setState(() => _playingIndex = index);
        _openPlayer(index);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isPlaying
              ? _mood.primaryColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Hero(
              tag: 'album_art_${song.id}',
              child: ClipRRect(
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
                      color: _mood.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: isPlaying
                          ? Border.all(color: _mood.primaryColor, width: 1.5)
                          : null,
                    ),
                    child: isPlaying
                        ? Icon(
                            Icons.bar_chart_rounded,
                            color: _mood.labelColor,
                            size: 26,
                          )
                        : Icon(
                            Icons.music_note_rounded,
                            color: Colors.white.withOpacity(0.5),
                            size: 22,
                          ),
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
                      color: isPlaying ? _mood.labelColor : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song.artist,
                    style: GoogleFonts.poppins(
                      color: isPlaying
                          ? _mood.labelColor.withOpacity(0.7)
                          : Colors.white.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              ['3:45', '4:12', '2:58', '5:30', '3:22', '4:45'][index % 6],
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
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

  //Mini Player
  Widget _buildMiniPlayer(List<Song> songs) {
    final current = songs[_playingIndex];
    return GestureDetector(
      onTap: () => _openPlayer(_playingIndex),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_mood.primaryColor, _mood.secondaryColor.withOpacity(0.7)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _mood.primaryColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                current.coverUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.graphic_eq_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    current.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    current.artist,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_playingIndex < songs.length - 1) {
                  setState(() => _playingIndex++);
                }
              },
              child: Icon(
                Icons.skip_next_rounded,
                color: Colors.white.withOpacity(0.85),
                size: 26,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.pause_rounded,
                color: _mood.primaryColor,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
