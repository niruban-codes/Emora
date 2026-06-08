import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/models/song_model.dart';

class GenrePlaylistScreen extends StatefulWidget {
  final String genre;
  final List<Song>? songs; // Made nullable to detect dynamic loading

  const GenrePlaylistScreen({
    super.key,
    required this.genre,
    this.songs,
  });

  @override
  State<GenrePlaylistScreen> createState() => _GenrePlaylistScreenState();
}

class _GenrePlaylistScreenState extends State<GenrePlaylistScreen> {
  List<Song> _displaySongs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.songs != null) {
      _displaySongs = widget.songs!;
    } else {
      _fetchTrendingSongs();
    }
  }

  Future<void> _fetchTrendingSongs() async {
    setState(() => _isLoading = true);
    try {
      // TODO----Connect actual backend API service fetch function here later
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildTopBar(context),
            const SizedBox(height: 24),
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(child: _buildSongList(context)),
          ],
        ),
      ),
    );
  }

  // ── Top Bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.centerLeft,
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.genre,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_displaySongs.length} songs',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.4),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ── Song List ─────────────────────────────────────────────────────────────
  Widget _buildSongList(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFCE93D8)),
      );
    }

    if (_displaySongs.isEmpty) {
      return Center(
        child: Text(
          'No songs available',
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.35),
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _displaySongs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _buildSongTile(context, index),
    );
  }    

  Widget _buildSongTile(BuildContext context, int index) {
    final song = _displaySongs[index];

    return GestureDetector(
      onTap: () {
        context.push('/player', extra: {
          'songs': _displaySongs,
          'index': index,
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF14122A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Cover art
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
                  color: const Color(0xFF1E1E3A),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white24,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Title & artist
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song.artist,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Duration
            Text(
              song.duration,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.35),
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 10),
            // More icon
            Icon(
              Icons.more_vert,
              color: Colors.white.withOpacity(0.3),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}