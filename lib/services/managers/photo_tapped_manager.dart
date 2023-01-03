import 'package:flutter/foundation.dart';

import '../../models/outfit.dart';
import '../../models/outfit_container.dart';

class PhotoTapped extends ChangeNotifier {
  Map<List<dynamic>, OutfitContainer> mapDynamic = {};
  List<String> listOfIds = [];
  late String screenshot;

  String get getScreenshot => screenshot;
  Outfit? item;

  Map<List<dynamic>, OutfitContainer> get getMapDynamic => mapDynamic;

  void setObject(Outfit? newItem) {
    item = newItem;
  }

  Outfit? get getObject => item;

  void nullMap(List<String> ids) {
    mapDynamic.clear();
    ids.forEach((element) => listOfIds.removeWhere((el) => el == element));
    notifyListeners();
  }

  void nullWholeMap() {
    listOfIds = [];
    mapDynamic.clear();
    notifyListeners();
  }

  void setScreenshot(String newScreenshot) {
    screenshot = newScreenshot;
    notifyListeners();
  }

  void setMap(Map<List<dynamic>, OutfitContainer> newMap) {
    mapDynamic = newMap;
  }

  void photoRemoved(String id) {
    listOfIds.remove(id);
  }

  void addToMap(String photoURL, String id) {
    if (!listOfIds.contains(id)) {
      mapDynamic.addAll({
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
