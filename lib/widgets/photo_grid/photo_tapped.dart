import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mokamayu/widgets/drag_target_container.dart';

class PhotoTapped extends ChangeNotifier {
  Map<List<String>, ContainerList> map = {};
  List<String> listOfIds = [];
  late Uint8List screenshot;
  Uint8List get getScreenshot => screenshot;
  Map<List<String>, ContainerList> get getMap => map;

  void nullMap(List<String> ids) {
    map = {};
    ids.forEach((element) => listOfIds.removeWhere((el) => el == element));
    notifyListeners();
  }

  void setScreenshot(Uint8List newScreenshot) {
    screenshot = newScreenshot;
    notifyListeners();
  }

  void photoRemoved(String id) {
    listOfIds.remove(id);
  }

  void addToMap(String photoURL, String id) {
    if (!listOfIds.contains(id)) {
      map.addAll({
        [photoURL, id]: ContainerList(
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
