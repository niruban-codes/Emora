import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// ── Screens ────────────────────────────────────────────────────────────────
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
import 'package:frontend/screens/profile/monthly_analysis_screen.dart';
import 'package:frontend/screens/history_screen.dart';
import 'package:frontend/screens/notification_screen.dart';
import 'package:frontend/screens/music/library_screen.dart';
import 'package:frontend/screens/main_layout.dart';
import 'package:frontend/screens/admin_dashboard/dashboard_screen.dart';
import 'package:frontend/screens/favorite_screen.dart';
import 'package:frontend/screens/admin_dashboard/main_wrapper.dart';
import 'package:frontend/screens/music/genre_playlist_screen.dart';
import 'package:frontend/screens/admin_dashboard/main_wrapper.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // ═══════════════════════════════════════════════════════════════════════
    // FULL SCREEN ROUTES (No Bottom Navigation Bar)
    // ═══════════════════════════════════════════════════════════════════════
    GoRoute(
      path: '/',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/launch',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LaunchScreen(),
    ),
    GoRoute(
      path: '/register',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/registerEmail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RegisterWithEmailScreen(),
    ),
    GoRoute(
      path: '/genre-playlist',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return GenrePlaylistScreen(
          genre: (extra['genre'] as String?) ?? 'Unknown Genre',
          songs: extra['songs'] as List<Song>?, 
        );
      },
    ),
    GoRoute(
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/scan',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const EmotionDetectionScreen(),
    ),
    GoRoute(
      path: '/notifications',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/admin-dashboard',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const MainWrapper(),
    ),
    GoRoute(
      path: '/favorites',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final mood = state.extra as String? ?? 'All';
        return FavoritesScreen(initialMood: mood);
      },
    ),
    // Player
    GoRoute(
      path: '/player',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final songs = extra['songs'] as List<Song>? ?? [];
        final index = extra['index'] as int? ?? 0;

        if (songs.isEmpty) {
          return const Scaffold(body: Center(child: Text("No tracks found")));
        }

        final safeIndex = index.clamp(0, songs.length - 1);
        return PlayerScreen(
          currentSong: songs[safeIndex],
          playlist: songs,
          initialIndex: safeIndex,
        );
      },
    ),
    GoRoute(
      path: '/result',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
  try {
          final extra = state.extra;

          // 1. Check if we received the custom Map passed from EmotionDetectionScreen
          if (extra is Map<String, dynamic>) {
            // Unpack the pre-constructed MoodModel from the map
            if (extra.containsKey('mood') && extra['mood'] is MoodModel) {
              return ResultScreen(mood: extra['mood'] as MoodModel);
            }
            
            // Fallback parsing if the raw backend Map layout was parsed directly
            final emotionStr = (extra['dominant_emotion'] ?? extra['emotion'] ?? extra['mood'] ?? 'neutral').toString();
            return ResultScreen(mood: MoodModel.fromString(emotionStr));
          } 
          
          // 2. Check if it was passed cleanly as just a MoodModel object
          if (extra is MoodModel) {
            return ResultScreen(mood: extra);
          }
          
          // 3. Fallback safely if no parameter structure matches
          return ResultScreen(mood: MoodModel.fromString('neutral'));
        } catch (e, stackTrace) {
          debugPrint("❌ GoRouter Result Processing Exception caught safely: $e");
          return ResultScreen(mood: MoodModel.fromString('neutral'));
        }
      },
    ),
    GoRoute(
      path: '/playlist',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        try {
          final extra = state.extra;

          if (extra is Map<String, dynamic>) {
            final emotionStr = (extra['dominant_emotion'] ?? extra['emotion'] ?? extra['mood'] ?? 'neutral').toString();
            return PlaylistDetailsScreen(mood: MoodModel.fromString(emotionStr));
          } 

          if (extra is MoodModel) {
            return PlaylistDetailsScreen(mood: extra);
          }

          // 3. NEW: Check if the app sent a plain text String (Fixes your ResultScreen crash!)
          if (extra is String) {
            return PlaylistDetailsScreen(mood: MoodModel.fromString(extra));
          }
          
          return PlaylistDetailsScreen(mood: MoodModel.fromString('neutral'));
        } catch (e, stackTrace) {
          debugPrint("❌ GoRouter Playlist Navigation Error: $e");
          debugPrint("Stacktrace: $stackTrace");
          return PlaylistDetailsScreen(mood: MoodModel.fromString('neutral'));
        }
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // SHELL ROUTES (Wrapped in MainLayout with Bottom Navigation Bar)
    // ═══════════════════════════════════════════════════════════════════════
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Return the MainLayout, passing the shell to display the current tab
        return MainLayout(navigationShell: navigationShell);
      },
      branches: [
        // ── Branch 0: HOME ──
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // ── Branch 1: EXPLORE ──
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchMoodScreen(),
            ),
          ],
        ),

        // ── Branch 2: LIBRARY (and its sub-pages) ──
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryScreen(),
            ),
          ],
        ),

        // ── Branch 3: HISTORY ──
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),

        // ── Branch 4: PROFILE (and its sub-pages) ──
        StatefulShellBranch(
          routes: [
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
            ),
          ],
        ),
      ],
    ),
  ],
);
