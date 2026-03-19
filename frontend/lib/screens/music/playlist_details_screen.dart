import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screens/emotion/mood_model.dart';
import 'package:frontend/models/song_model.dart';

class PlaylistDetailsScreen extends StatefulWidget {
  final MoodModel mood;
  const PlaylistDetailsScreen({super.key, required this.mood});

  @override
  State<PlaylistDetailsScreen> createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen> {
  int _currentNavIndex = 2;
  int _playingIndex = 0;

  MoodModel get _mood => widget.mood;

  // Build a Song list from MoodModel data
  List<Song> get _songs {
    final playlists = _mood.playlistTitles;
    return List.generate(playlists.length, (i) {
      return Song(
        id: '${_mood.type.name}_$i',
        title: i == 0 ? _mood.songTitle : playlists[i],
        artist: i == 0 ? _mood.artist : _mood.label,
        coverUrl: 'https://picsum.photos/200?${_mood.type.index * 10 + i}',
      );
    });
  }

  // Navigate to PlayerScreen passing full playlist + tapped index
  void _openPlayer(int index) {
    context.push('/player', extra: {'songs': _songs, 'index': index});
  }

  @override
  Widget build(BuildContext context) {
    final songs = _songs;
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E2A),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildTopBar()),
                SliverToBoxAdapter(child: _buildCoverSection(songs)),
                SliverToBoxAdapter(child: _buildActionButtons(songs)),
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
          _buildMiniPlayer(songs), // 👈 tap mini player → open player
          _buildBottomNav(),
        ],
      ),
    );
  }

  // ── Top Bar ───────────────────────────────────────────────────────────────
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
            const Text(
              'PLAYLIST',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.5,
              ),
            ),
            const Icon(Icons.search_rounded, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }

  // ── Cover Section ─────────────────────────────────────────────────────────
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
                  child: Text(
                    _mood.emoji,
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${_mood.label[0]}${_mood.label.substring(1).toLowerCase()} Playlist',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
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
                '${songs.length} tracks',
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

  // ── Play / Shuffle Buttons ────────────────────────────────────────────────
  Widget _buildActionButtons(List<Song> songs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _playingIndex = 0);
                _openPlayer(0); // 👈 Play button opens player at index 0
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
        ],
      ),
    );
  }

  // ── Song Tile ─────────────────────────────────────────────────────────────
  Widget _buildSongTile(Song song, int index) {
    final bool isPlaying = index == _playingIndex;

    return GestureDetector(
      onTap: () {
        setState(() => _playingIndex = index);
        _openPlayer(index); // 👈 tap song → open player at that index
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
            // Album art thumbnail
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
                    style: TextStyle(
                      color: isPlaying ? _mood.labelColor : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song.artist,
                    style: TextStyle(
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
              style: TextStyle(
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

  // ── Mini Player ───────────────────────────────────────────────────────────
  Widget _buildMiniPlayer(List<Song> songs) {
    final current = songs[_playingIndex];
    return GestureDetector(
      onTap: () =>
          _openPlayer(_playingIndex), // 👈 tap mini player → open player
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
                  child: Center(
                    child: Text(
                      _mood.emoji,
                      style: const TextStyle(fontSize: 20),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    current.artist,
                    style: TextStyle(
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

  // ── Bottom Nav ────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      _NavItem(icon: Icons.home_rounded, label: 'HOME', route: '/home'),
      _NavItem(icon: Icons.explore_rounded, label: 'EXPLORE', route: '/search'),
      _NavItem(
        icon: Icons.library_music_rounded,
        label: 'LIBRARY',
        route: null,
      ),
      _NavItem(icon: Icons.history_rounded, label: 'History', route: null),
      _NavItem(icon: Icons.person_rounded, label: 'PROFILE', route: null),
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
              if (items[i].route != null) {
                context.push(items[i].route!);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  items[i].icon,
                  color: isActive
                      ? _mood.primaryColor
                      : Colors.white.withOpacity(0.4),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  items[i].label,
                  style: TextStyle(
                    color: isActive
                        ? _mood.primaryColor
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

class _NavItem {
  final IconData icon;
  final String label;
  final String? route;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
