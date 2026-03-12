// Import your screens
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/launch_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/', // App starts here
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/launch', builder: (context, state) => const LaunchScreen()),
    // ... your other routes
  ],
);
