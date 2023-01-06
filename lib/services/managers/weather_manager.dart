import 'package:flutter/foundation.dart';

class WeatherManager extends ChangeNotifier {
  List<String> days = [];
  List<String> get getDays => days;

  void addDay(String day) {
    days.add(day);
    notifyListeners();
  }

  List<String> times = [];
  List<String> get getTime => times;

  void addTime(String time) {
    times.add(time);
    notifyListeners();
  }

  List<double> temps = [];
  List<double> get getTemps => temps;

  void addTemp(double temp) {
    temps.add(temp);
    notifyListeners();
  }

  List<String> weatherIcons = [];
  List<String> get getIcons => weatherIcons;

  void addIcon(String icon) {
    weatherIcons.add(icon);
    notifyListeners();
  }

  void resetLists() {
    times = [];
    weatherIcons = [];
    temps = [];
    days = [];
    notifyListeners();
  }
}
