import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/outfit_container.dart';
import 'package:mokamayu/screens/screens.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:mokamayu/services/managers/outfit_manager.dart';
import '../models/wardrobe_item.dart';
import '../screens/outfits/outfit_summary_screen.dart';
import '../screens/outfits/outfits_add_attributes_screen.dart';
import '../widgets/drag_target_container.dart';

class AppRouter {
  final AppStateManager appStateManager;
  final ProfileManager profileManager;
  final WardrobeManager wardrobeManager;
  final OutfitManager outfitManager;

  AppRouter(this.appStateManager, this.profileManager, this.wardrobeManager,
      this.outfitManager);

  late final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: appStateManager,
    initialLocation: '/home/${NavigationBarTab.wardrobe}',
    routes: [
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        name: 'reset-password',
        path: '/reset-password',
        builder: (context, state) => const ResetPassword(),
      ),
      GoRoute(
        name: 'home',
        path: '/home/:tab',
        builder: (context, state) {
          final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
          return HomeScreen(key: state.pageKey, currentTab: tab);
        },
      ),
      GoRoute(
        name: 'pick-photo',
        path: '/pick-photo',
        builder: (context, state) => AddPhotoScreen(),
      ),
      GoRoute(
          path: '/add-wardrobe-item/:file',
          name: 'add-wardrobe-item',
          builder: (context, state) {
            String file = state.params['file']!;
            return AddWardrobeItemForm(
                photo: file, isEdit: false, disableFields: false);
          }),
      GoRoute(
          path: '/wardrobe-item',
          name: 'wardrobe-item',
          builder: (context, state) {
            return AddWardrobeItemForm(
                editItem: state.extra as WardrobeItem,
                isEdit: true,
                disableFields: true);
          }),
      GoRoute(
          name: 'create-outfit-page',
          path: '/create-outfit-page',
          builder: (context, state) {
            return CreateOutfitPage(
                itemList: state.extra as Future<List<WardrobeItem>>?);
          }),
      GoRoute(
          name: 'outfit-add-attributes-screen',
          path: '/outfit-add-attributes-screen',
          builder: (context, state) {
            return OutfitsAddAttributesScreen(
                map: state.extra as Map<List<dynamic>, OutfitContainer>);
          }),
      GoRoute(
          name: 'outfit-summary-screen',
          path: '/outfit-summary-screen',
          builder: (context, state) {
            return OutfitSummaryScreen(
                map: state.extra as Map<List<dynamic>, OutfitContainer>?);
          }),
      GoRoute(
          name: 'edit-profile',
          path: '/edit-profile',
          builder: (context, state) {
            return const EditProfileScreen();
          }),
    ],
    redirect: (_, GoRouterState state) {
      final loggedIn = appStateManager.isLoggedIn;
      final loggingIn = state.subloc == '/login';
      final registering = state.subloc == '/register';
      final resettingPassword = state.subloc == '/reset-password';
      if (!loggedIn) {
        if (loggingIn || registering || resettingPassword) {
          return null;
        }
        return '/login';
      }
      if (loggingIn) return '/home/${NavigationBarTab.wardrobe}';
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
