import 'package:go_router/go_router.dart';

import 'features/settings/view/screens/about_screen.dart';
import 'features/settings/view/screens/disclaimer_screen.dart';
import 'features/settings/view/screens/settings_screen.dart';
import 'features/watermarker/view/screens/editor_screen.dart';
import 'features/watermarker/view/screens/home_screen.dart';

/// Application-level route configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/editor', builder: (context, state) => const EditorScreen()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
    GoRoute(
      path: '/disclaimer',
      builder: (context, state) => const DisclaimerScreen(),
    ),
  ],
);
