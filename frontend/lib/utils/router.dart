import 'package:go_router/go_router.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:frontend/screens/launch_screen.dart';
import 'package:frontend/screens/auth/register_screen.dart';
import 'package:frontend/screens/auth/register_with_email_screen.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/emotion/emotion_detection_screen.dart';
import 'package:frontend/screens/emotion/result_screen.dart';
import 'package:frontend/screens/emotion/mood_model.dart';
import 'package:frontend/models/song_model.dart';
import 'package:frontend/screens/music/playlist_details_screen.dart';
import 'package:frontend/screens/music/search_mood_screen.dart';
import 'package:frontend/screens/music/player_screen.dart';
import 'package:frontend/screens/profile/profile_screen.dart';
import 'package:frontend/screens/profile/account_setting.dart';
import 'package:frontend/screens/profile/insights_screen.dart';
import 'package:frontend/screens/profile/mood_analysis_screen.dart';
import 'package:frontend/screens/profile/monthly_analysis_screen.dart'; // 👈 added
import 'package:frontend/screens/history_screen.dart'; // 👈 added
import 'package:frontend/screens/notification_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/launch', builder: (context, state) => const LaunchScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/registerEmail',
      builder: (context, state) => const RegisterWithEmailScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchMoodScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ), // 👈 added
    // ── Profile ───────────────────────────────────────────────────────────
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileSettingsScreen(),
    ),
    GoRoute(
      path: '/account-settings',
      builder: (context, state) => const AccountSettingScreen(),
    ),
    GoRoute(
      path: '/insights',
      builder: (context, state) => const InsightsScreen(),
    ),
    GoRoute(
      path: '/mood-analytics',
      builder: (context, state) => const MoodAnalyticsScreen(),
    ),
    GoRoute(
      path: '/monthly-analytics',
      builder: (context, state) => const MonthlyAnalysisScreen(),
    ), // 👈 added
    // ── Playlist & Player ─────────────────────────────────────────────────
    GoRoute(
      path: '/playlist',
      builder: (context, state) {
        final mood = state.extra as MoodModel?;
        return PlaylistDetailsScreen(
          mood: mood ?? MoodModel.fromString('peaceful'),
        );
      },
    ),
    GoRoute(
      path: '/player',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final songs = extra['songs'] as List<Song>;
        final index = extra['index'] as int;
        return PlayerScreen(
          currentSong: songs[index],
          playlist: songs,
          initialIndex: index,
        );
      },
    ),

    //Notification
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    
    // ── Emotion flow ──────────────────────────────────────────────────────
    GoRoute(
      path: '/scan',
      builder: (context, state) => const EmotionDetectionScreen(),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) {
        final mood = state.extra as MoodModel?;
        return ResultScreen(mood: mood ?? MoodModel.fromString('peaceful'));
      },
    ),
  ],
);
