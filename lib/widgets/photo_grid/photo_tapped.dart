import 'package:flutter/foundation.dart';

import '../../models/outfit_container.dart';

class PhotoTapped extends ChangeNotifier {
  Map<List<String>, OutfitContainer> map = {};
  List<String> listOfIds = [];
  late String screenshot;
  String get getScreenshot => screenshot;
  Map<List<String>, OutfitContainer> get getMap => map;

  void nullMap(List<String> ids) {
    map = {};
    ids.forEach((element) => listOfIds.removeWhere((el) => el == element));
    notifyListeners();
  }

  void setScreenshot(String newScreenshot) {
    screenshot = newScreenshot;
    notifyListeners();
  }

  void photoRemoved(String id) {
    listOfIds.remove(id);
  }

  void addToMap(String photoURL, String id) {
    if (!listOfIds.contains(id)) {
      map.addAll({
        [photoURL, id]: OutfitContainer(
          height: 100.0,
          width: 100.0,
          rotation: 0.0,
          scale: 1.0,
          xPosition: 0.1,
          yPosition: 0.1,
        )
      });
      listOfIds.add(id);
    }
    notifyListeners();
  }
}
