import 'package:frontend/screens/auth/register_screen.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/auth/register_with_email_screen.dart';
import 'package:frontend/screens/music/playlist_details_screen.dart';
import 'package:frontend/screens/home_screen.dart'; // 👈 added
import 'package:go_router/go_router.dart';
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
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ), // 👈 added
    // TODO: GoRoute(path: '/search', builder: (context, state) => const SearchMoodScreen()),
  ],
);
