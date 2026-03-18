import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/screens/auth/register_screen.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/auth/register_with_email_screen.dart';
import 'package:frontend/screens/music/playlist_details_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/emotion/emotion_detection_screen.dart';
import 'package:frontend/screens/emotion/result_screen.dart';
import 'package:frontend/screens/emotion/mood_model.dart';
import '../screens/splash_screen.dart';
import '../screens/launch_screen.dart';

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
    GoRoute(
      path: '/playlist',
      builder: (context, state) => const PlaylistDetailsScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

    // ── Emotion flow ──────────────────────────────────────────────────────────
    GoRoute(
      path: '/scan',
      builder: (context, state) => const EmotionDetectionScreen(),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) {
        // 1. Safely cast to MoodModel? so it doesn't crash if null
        final mood = state.extra as MoodModel?;

        // 2. Fallback to a default mood if extra is missing (e.g., during Hot Reload)
        if (mood == null) {
          // Defaulting to 'peaceful' so the UI still renders safely
          return ResultScreen(mood: MoodModel.fromString('peaceful'));
        }

        // 3. Normal flow
        return ResultScreen(mood: mood);
      },
    ),
  ],
);
