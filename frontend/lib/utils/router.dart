// Import your screens
import 'package:frontend/screens/music/playlist_details_screen.dart';
import 'package:frontend/screens/music/search_mood_screen.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/launch_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/', // App starts here
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/launch', builder: (context, state) => const LaunchScreen()),
    GoRoute(
      path: '/playlist',
      builder: (context, state) => const PlaylistDetailsScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchMoodScreen(),
    ),
    // ... your other routes
  ],
);
