import 'package:flutter/foundation.dart';

import '../../models/calendar_event.dart';
import '../../models/outfit.dart';

class CalendarManager extends ChangeNotifier {
  List<Outfit?> pickedOutfits = [];
  List<Outfit?> get getPickedOutfits => pickedOutfits;

  Map<Outfit?, bool> outfitSelectedMap = {};
  Map<Outfit?, bool> get getOutfitsMap => outfitSelectedMap;

  Map<DateTime, List<Event>> events = {};
  Map<DateTime, List<Event>> get getEvents => events;

  DateTime day = DateTime.now();
  DateTime get getDay => day;

  void removeEvent(Event event) {
    events.forEach((key, value) {
      if (value.contains(event)) {
        value.removeWhere((element) => element == event);
      }
    });
    notifyListeners();
  }

  void nullOutfitsMap() {
    outfitSelectedMap = {};
  }

  void nullPickedOutfits() {
    pickedOutfits = [];
  }

  void selectOutfit(Outfit? outfit, bool? selected) {
    if (selected == false) {
      outfitSelectedMap.containsKey(outfit)
          ? outfitSelectedMap[outfit] = true
          : outfitSelectedMap.addAll({outfit: true});
    } else {
      outfitSelectedMap[outfit] = false;
    }
    notifyListeners();
  }

  void addOutfit(Outfit? outfit) {
    pickedOutfits.add(outfit);
    notifyListeners();
  }

  void removeOutfit(Outfit? outfit) {
    pickedOutfits.removeWhere((element) => element == outfit);
    notifyListeners();
  }

  void setSelectedEvents(Map<DateTime, List<Event>> selectedEvents) {
    events = selectedEvents;
    notifyListeners();
  }

  void setSelectedDay(DateTime selectedDay) {
    day = selectedDay;
  }
}
