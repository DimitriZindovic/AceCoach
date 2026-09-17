import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/history/session_detail_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/session_result/session_result_screen.dart';
import '../screens/session_setup/session_setup_screen.dart';
import 'app_shell.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// Route names, used with `context.goNamed` / `pushNamed`.
abstract final class AppRoutes {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String sessionSetup = 'sessionSetup';
  static const String sessionResult = 'sessionResult';
  static const String history = 'history';
  static const String sessionDetail = 'sessionDetail';
  static const String profile = 'profile';
}

/// The app router. Re-evaluates its redirect whenever the auth state emits.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = _RouterRefreshNotifier();
  ref.listen(authStateProvider, (_, _) => refresh.refresh());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: SplashScreen.routePath,
    refreshListenable: refresh,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(
        path: SplashScreen.routePath,
        name: AppRoutes.splash,
        pageBuilder: (context, state) => _fadePage(state, const SplashScreen()),
      ),
      GoRoute(
        path: LoginScreen.routePath,
        name: AppRoutes.login,
        pageBuilder: (context, state) => _fadePage(state, const LoginScreen()),
      ),
      GoRoute(
        path: RegisterScreen.routePath,
        name: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomeScreen.routePath,
                name: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: SessionSetupScreen.routePath,
                name: AppRoutes.sessionSetup,
                builder: (context, state) => const SessionSetupScreen(),
                routes: [
                  GoRoute(
                    path: SessionResultScreen.routeSegment,
                    name: AppRoutes.sessionResult,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SessionResultScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HistoryScreen.routePath,
                name: AppRoutes.history,
                builder: (context, state) => const HistoryScreen(),
                routes: [
                  GoRoute(
                    path: SessionDetailScreen.routeSegment,
                    name: AppRoutes.sessionDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => SessionDetailScreen(
                      sessionId:
                          state.pathParameters[SessionDetailScreen
                              .sessionIdParameter]!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ProfileScreen.routePath,
                name: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Auth guard.
///
/// - While the first auth event is pending, stay on the splash screen.
/// - Signed out: only the auth routes are reachable.
/// - Signed in: auth routes and the splash redirect home.
String? _redirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authStateProvider);
  final location = state.matchedLocation;
  final isSplash = location == SplashScreen.routePath;
  final isAuthRoute =
      location == LoginScreen.routePath || location == RegisterScreen.routePath;

  if (auth.isLoading && !auth.hasValue) {
    return isSplash ? null : SplashScreen.routePath;
  }
  final signedIn = auth.value != null;
  if (!signedIn) {
    return isAuthRoute ? null : LoginScreen.routePath;
  }
  if (isAuthRoute || isSplash) return HomeScreen.routePath;
  return null;
}

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

/// Bridges the auth stream to go_router's [Listenable]-based refresh.
class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}
