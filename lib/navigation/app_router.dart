import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/authenticate/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../services/managers/managers.dart';

class AppRouter {
  final AppStateManager appStateManager;
  final ProfileManager profileManager;
  final ClothesManager clothesManager;

  AppRouter(this.appStateManager, this.profileManager, this.clothesManager);

  late final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: appStateManager,
    initialLocation: '/home/${NavigationBarTab.closet}',
    routes: [
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'home',
        path: '/home/:tab',
        builder: (context, state) {
          final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
          return HomeScreen(key: state.pageKey, currentTab: tab);
        },
      ),
    ],
    redirect: (_, GoRouterState state) {
      final loggedIn = appStateManager.isLoggedIn;
      final loggingIn = state.subloc == '/login';
      if (!loggedIn) return loggingIn ? null : '/login';
      if (loggingIn) return '/home/${NavigationBarTab.closet}';
      return null;
    },
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
            ),
          ),
        ),
      );
    },
  );
}
