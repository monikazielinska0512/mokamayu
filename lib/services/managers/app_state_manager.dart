import 'dart:async';
import 'package:flutter/material.dart';

import '../app_cache.dart';
import '../authentication/auth.dart';

class NavigationBarTab {
  static const int closet = 0;
  static const int outfits = 1;
  static const int social = 2;
  static const int profile = 3;
}

class AppStateManager extends ChangeNotifier {
  bool _loggedIn = false;
  int _selectedTab = NavigationBarTab.closet;
  final _appCache = AppCache();
  final AuthService _auth = AuthService();

  bool get isLoggedIn => _loggedIn;

  int get getSelectedTab => _selectedTab;

  Future<void> initializeApp() async {
    _loggedIn = await _appCache.isUserLoggedIn();
  }

  void login() async {
    _loggedIn = true;
    await _appCache.cacheUser();
    notifyListeners();
  }

  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }

  void logout() async {
    _loggedIn = false;
    _selectedTab = 0;
    _auth.signOut();

    // Reinitialize the app
    await _appCache.invalidate();
    await initializeApp();
    notifyListeners();
  }
}
