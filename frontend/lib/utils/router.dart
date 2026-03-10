import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/emotion/emotion_detection_screen.dart';
import '../screens/music/player_screen.dart';
// Note: Import other screens here as you build them out.

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/detect',
      builder: (context, state) => const EmotionDetectionScreen(),
    ),
    GoRoute(path: '/player', builder: (context, state) => const PlayerScreen()),
    // Add routes for Login, Register, Playlist, etc.
  ],
);
