import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/models/song_model.dart';

class _FavSong {
  final String title;
  final String artist;
  final String duration;
  final String mood;
  final Color moodColor;
  final IconData icon;
  final String coverUrl;

  const _FavSong({
    required this.title,
    required this.artist,
    required this.duration,
    required this.mood,
    required this.moodColor,
    required this.icon,
    required this.coverUrl,
  });
}

// mood buttons
const _kMoods = ['All', 'Happy', 'Sad', 'Neutral', 'Fear', 'Angry', 'Surprise'];

class FavoritesScreen extends StatefulWidget {
  final String initialMood;
  const FavoritesScreen({super.key, this.initialMood = 'All'});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  String _selectedMood = 'All';
  int? _playingIndex;

  // swap out for real data source
  final List<_FavSong> _allSongs = const [
    _FavSong(
      title: 'Morning Zen',
      artist: 'Serenity Now',
      duration: '3:45',
      mood: 'Happy',
      moodColor: Color(0xFFFFB74D),
      icon: Icons.sentiment_very_satisfied_rounded,
      coverUrl: 'https://picsum.photos/seed/morningzen/100/100',
    ),
    _FavSong(
      title: 'Quiet Waters',
      artist: 'Flowing Echoes',
      duration: '4:12',
      mood: 'Neutral',
      moodColor: Color(0xFF90A4AE),
      icon: Icons.lens_blur_rounded,
      coverUrl: 'https://picsum.photos/seed/quietwaters/100/100',
    ),
    _FavSong(
      title: 'First Light',
      artist: 'Ambient Dreams',
      duration: '2:58',
      mood: 'Happy',
      moodColor: Color(0xFFFFB74D),
      icon: Icons.sentiment_very_satisfied_rounded,
      coverUrl: 'https://picsum.photos/seed/firstlight/100/100',
    ),
    _FavSong(
      title: 'Soft Horizon',
      artist: 'Luna Park',
      duration: '5:30',
      mood: 'Sad',
      moodColor: Color(0xFF64B5F6),
      icon: Icons.sentiment_dissatisfied_rounded,
      coverUrl: 'https://picsum.photos/seed/softhorizon/100/100',
    ),
    _FavSong(
      title: 'Dew Drops',
      artist: "Nature's Whisper",
      duration: '3:15',
      mood: 'Neutral',
      moodColor: Color(0xFF90A4AE),
      icon: Icons.lens_blur_rounded,
      coverUrl: 'https://picsum.photos/seed/dewdrops/100/100',
    ),
    _FavSong(
      title: 'Velvet Thunder',
      artist: 'Storm Studio',
      duration: '4:00',
      mood: 'Angry',
      moodColor: Color(0xFFE57373),
      icon: Icons.local_fire_department_outlined,
      coverUrl: 'https://picsum.photos/seed/velvetthunder/100/100',
    ),
    _FavSong(
      title: 'Shadow Walk',
      artist: 'Dark Corridor',
      duration: '3:33',
      mood: 'Fear',
      moodColor: Color(0xFF9575CD),
      icon: Icons.sentiment_very_dissatisfied_outlined,
      coverUrl: 'https://picsum.photos/seed/shadowwalk/100/100',
    ),
    _FavSong(
      title: 'Electric Spark',
      artist: 'Flash Lab',
      duration: '2:47',
      mood: 'Surprise',
      moodColor: Color(0xFF4DB6AC),
      icon: Icons.flare_rounded,
      coverUrl: 'https://picsum.photos/seed/electricspark/100/100',
    ),
  ];

  List<_FavSong> get _filtered => _selectedMood == 'All'
      ? _allSongs
      : _allSongs.where((s) => s.mood == _selectedMood).toList();

  Song _toSong(_FavSong s) => Song(
    id: 'default-id',
    title: s.title,
    artist: s.artist,
    duration: s.duration,
    coverUrl: 'default-cover-url',
  );

  void _navigateToPlayer(List<_FavSong> songs, int index) {
    setState(() => _playingIndex = index);
    final realSongs = songs.map(_toSong).toList();
    context.push('/player', extra: {'songs': realSongs, 'index': index});
  }

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.initialMood;
    _animController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final songs = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(songs),
              const SizedBox(height: 16),
              _buildMoodFilter(),
              const SizedBox(height: 8),
              Expanded(child: _buildSongList(songs)),
              if (_playingIndex != null) _buildMiniPlayer(songs),
            ],
          ),
        ),
      ),
    );
  }

  // App bar
  Widget _buildAppBar(List<_FavSong> songs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white70,
                size: 22,
              ),
            ),
          Expanded(
            child: Center(
              child: Text(
                'Favorites',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (songs.isNotEmpty) _navigateToPlayer(songs, 0);
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFA7338A), width: 2),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Color(0xFFA7338A),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Mood filter chips
  Widget _buildMoodFilter() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _kMoods.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final mood = _kMoods[i];
          final selected = mood == _selectedMood;
          return GestureDetector(
            onTap: () => setState(() => _selectedMood = mood),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFA7338A)
                    : const Color(0xFF1E1A35),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: selected ? const Color(0xFFA7338A) : Colors.white12,
                ),
              ),
              child: Text(
                mood,
                style: GoogleFonts.poppins(
                  color: selected ? Colors.white : Colors.white60,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // song list
  Widget _buildSongList(List<_FavSong> songs) {
    if (songs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_border_rounded,
              color: Colors.white24,
              size: 52,
            ),
            const SizedBox(height: 12),
            Text(
              'No favorites yet',
              style: GoogleFonts.poppins(
                color: Colors.white38,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      itemCount: songs.length,
      itemBuilder: (context, index) => _buildSongTile(songs, index),
    );
  }

  //  Single song tile — tap opens full PlayerScreen
  Widget _buildSongTile(List<_FavSong> songs, int index) {
    final song = songs[index];
    final isPlaying = _playingIndex == index;

    return GestureDetector(
      onTap: () => _navigateToPlayer(songs, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isPlaying ? const Color(0xFF2A1060) : const Color(0xFF1E1A35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPlaying ? const Color(0xFFA7338A) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                song.coverUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.music_note_rounded,
                  color: Color(0xFFA7338A),
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
                      color: isPlaying ? const Color(0xFFA7338A) : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.artist,
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              song.duration,
              style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showSongOptions(context, song),
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white38,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPlayer(List<_FavSong> songs) {
    final song = songs[_playingIndex!];
    return GestureDetector(
      onTap: () => _navigateToPlayer(songs, _playingIndex!),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFA7338A), Color(0xFF6A1B6A)],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                song.coverUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.music_note_rounded, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    song.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    song.artist,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_playingIndex! > 0) {
                  _navigateToPlayer(songs, _playingIndex! - 1);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.skip_previous_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => setState(() => _playingIndex = null),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pause_rounded,
                  color: Color(0xFFA7338A),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                if (_playingIndex! < songs.length - 1) {
                  _navigateToPlayer(songs, _playingIndex! + 1);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.skip_next_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Bottom sheet options
  void _showSongOptions(BuildContext context, _FavSong song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1A35),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              song.title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              song.artist,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _optionTile(
              Icons.play_circle_outline_rounded,
              'Play Now',
              () => Navigator.pop(context),
            ),
            _optionTile(
              Icons.playlist_add_rounded,
              'Add to Playlist',
              () => Navigator.pop(context),
            ),
            _optionTile(
              Icons.favorite_rounded,
              'Remove from Favorites',
              () => Navigator.pop(context),
              color: const Color(0xFFE040FB),
            ),
            _optionTile(
              Icons.share_rounded,
              'Share',
              () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionTile(
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
