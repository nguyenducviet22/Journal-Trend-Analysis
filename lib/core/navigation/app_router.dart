import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../injection_container.dart';
import '../../features/personalization/presentation/screens/setup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/journal/presentation/screens/journal_screen.dart';
import '../../features/journal/presentation/screens/publication_detail_screen.dart';
import '../../features/journal/presentation/screens/journal_detail_screen.dart';
import '../../features/keywords/presentation/screens/keywords_screen.dart';
import '../../features/author/presentation/screens/author_detail_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../constants/prefs_keys.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> journalNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'journal');
final GlobalKey<NavigatorState> keywordsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'keywords');
final GlobalKey<NavigatorState> profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  redirect: (context, state) {
    try {
      final prefs = getIt<SharedPreferences>();
      final name = prefs.getString(PrefsKeys.fullName);
      final isPersonalized = name != null && name.trim().isNotEmpty;
      final isGoingToSetup = state.matchedLocation == '/setup';

      if (!isPersonalized && !isGoingToSetup) {
        return '/setup';
      }
      if (isPersonalized && isGoingToSetup) {
        return '/home';
      }
    } catch (e, st) {
      debugPrint('Router redirect error: $e\n$st');
      return '/setup'; // Fail-safe: redirect to setup on catastrophic DI failure
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/setup',
      builder: (context, state) => const PersonalizationSetupScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: journalNavigatorKey,
          routes: [
            GoRoute(
              path: '/journal',
              builder: (context, state) => const JournalScreen(),
              routes: [
                GoRoute(
                  path: 'publication/:id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return PublicationDetailScreen(paperId: id);
                  },
                ),
                GoRoute(
                  path: 'detail/:jid',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final jid = state.pathParameters['jid'] ?? '';
                    return JournalDetailScreen(journalId: jid);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: keywordsNavigatorKey,
          routes: [
            GoRoute(
              path: '/keywords',
              builder: (context, state) => const KeywordsScreen(),
              routes: [
                GoRoute(
                  path: 'author/:aid',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final aid = state.pathParameters['aid'] ?? '';
                    return AuthorDetailScreen(authorId: aid);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: profileNavigatorKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Keywords',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
