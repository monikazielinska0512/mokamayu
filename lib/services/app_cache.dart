import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/calendar_event.dart';

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

  Future<void> cacheIndexList(List<int> indexList) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> strList = indexList.map((i) => i.toString()).toList();
    prefs.setStringList("indexList", strList);
  }

  Future<void> cacheEvents(Map<String, String> events) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("events", json.encode(events));
  }

  // Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
  //   Map<String, dynamic> newMap = {};
  //   map.forEach((key, value) {
  //     newMap[key.toString()] = map[key]!;
  //   });
  //   return newMap;
  // }
}
