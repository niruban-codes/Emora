import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screens/emotion/mood_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // Mood grid now driven by allMoods from mood_model.dart — no local list needed.

  final List<Map<String, String>> _playlists = [
    {'title': 'Midnight Pulse', 'mood': 'HAPPY'},
    {'title': 'Ocean Breeze', 'mood': 'NEUTRAL'},
    {'title': 'Urban Night', 'mood': 'SAD'},
    {'title': 'Rainy Echoes', 'mood': 'ANGRY'},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildTopBar(),
                      const SizedBox(height: 28),
                      _buildAnalyzeButton(), 
                      const SizedBox(height: 32),
                      _sectionHeader('Search by Mood', showSeeAll: false),
                      const SizedBox(height: 16),
                      _buildMoodGrid(),
                      const SizedBox(height: 18),
                      _buildViewFavoritesButton(),
                      const SizedBox(height: 32),
                      _sectionHeader('Trending Playlists', showSeeAll: false),
                      const SizedBox(height: 16),
                      _buildPlaylistGrid(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //UI Components 
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogoIcon(),
        Row(children: [_notificationButton()]),
      ],
    );
  }

  Widget _buildLogoIcon() {
    return Image.asset(
      'assets/images/logo.png',
      width: 40,
      height: 40,
      fit: BoxFit.contain,
    );
  }

  Widget _buildAnalyzeButton() {
    return ElevatedButton(
      // Navigate to EmotionDetectionScreen via GoRouter
      onPressed: () => context.push('/scan'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            color: Colors.black,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            'Analyze Mood',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, {bool showSeeAll = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (showSeeAll)
          Text(
            'See all',
            style: GoogleFonts.poppins(
              color: const Color(0xFFA7338A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildMoodGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: allMoods.length,
      itemBuilder: (context, index) => _moodCard(allMoods[index]),
    );
  }

//view fav button 
  Widget _buildViewFavoritesButton() {
    return OutlinedButton(
      onPressed: () => context.push('/favorites'),
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFF1E1A35),
        side: const BorderSide(color: Color.fromARGB(29, 255, 255, 255)), 
        minimumSize: const Size(double.infinity, 45),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_rounded,
            color: const Color(0xFFE040FB),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'View Favorites',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  //emotion icon colors
  Widget _moodCard(MoodModel mood) {
    IconData moodIcon;
    Color moodColor = Colors.white;

    switch (mood.label.toLowerCase()) { 
      case 'happy':
        moodIcon = Icons.sentiment_very_satisfied_rounded;
        moodColor = const Color(0xFFFFB74D);
        break;
      case 'sad':
        moodIcon = Icons.sentiment_dissatisfied_rounded;
        moodColor = const Color(0xFF64B5F6);
        break;
      case 'neutral':
        moodIcon = Icons.lens_blur_rounded;
        moodColor = Colors.grey.shade400;
        break;
      case 'fear':
        moodIcon = Icons.sentiment_very_dissatisfied_outlined;
        moodColor = const Color(0xFF9575CD);
        break;
      case 'angry':
        moodIcon = Icons.local_fire_department_outlined;
        moodColor = const Color(0xFFE57373);
        break;
      case 'surprise':
        moodIcon = Icons.flare_rounded;
        moodColor = const Color(0xFF4DB6AC);
        break;
      default:
        moodIcon = Icons.face;
    }

    //6 emotions containers  --------------------------------------------------
    return GestureDetector(
      onTap: () {
        // Direct to the functional Playlist Screens
        context.push('/playlist', extra: mood);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1A35), 
          borderRadius: BorderRadius.circular(24), 
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              moodIcon,
              color: moodColor, 
              size: 30,
            ),
            const SizedBox(height: 12),
            Text(
              mood.label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),    
    );
  }

  Widget _buildPlaylistGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: _playlists.length,
      itemBuilder: (context, index) => _playlistCard(_playlists[index]),
    );
  }

  Widget _playlistCard(Map<String, String> playlist) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2A1A4E).withOpacity(0.8),
            const Color(0xFF0D0A1E),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFA7338A),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              playlist['mood']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            playlist['title']!,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circularIconButton(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E45),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white70, size: 20),
    );
  }

  Widget _notificationButton() {
    return GestureDetector(
      onTap: () => context.push('/notifications'),
      child: Stack(
        children: [
          _circularIconButton(Icons.notifications_outlined),
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFA7338A),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
