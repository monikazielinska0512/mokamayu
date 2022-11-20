import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static const user = 'user';

  Future<void> invalidate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(user, false);
  }

  Future<void> cacheUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(user, true);
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(user) ?? false;
  }
}
