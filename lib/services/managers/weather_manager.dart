import 'package:flutter/foundation.dart';

class WeatherManager extends ChangeNotifier {
  List<String> days = [];
  List<String> get getDays => days;

  void addDay(String day) {
    days.add(day);
    notifyListeners();
  }

  void nullDay() {
    days = [];
    notifyListeners();
  }

  List<String> times = [];
  List<String> get getTime => times;

  void addTime(String time) {
    times.add(time);
    notifyListeners();
  }

  void nullTime() {
    times = [];
    notifyListeners();
  }

  List<double> temps = [];
  List<double> get getTemps => temps;

  void addTemp(double temp) {
    temps.add(temp);
    notifyListeners();
  }

  void nullTemp() {
    temps = [];
    notifyListeners();
  }

  List<String> weatherIcons = [];
  List<String> get getIcons => weatherIcons;

  void addIcon(String icon) {
    weatherIcons.add(icon);
    notifyListeners();
  }

  void nullIcons() {
    weatherIcons = [];
    notifyListeners();
  }
}
