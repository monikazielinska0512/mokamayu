import 'package:flutter/foundation.dart';

class PhotoTapped extends ChangeNotifier {
  List<String> id_list = [];
  List<String> get getList => id_list;
  String setid = "";

  String get getId => setid;

  void setId(String id) {
    setid = id;
    notifyListeners();
  }

  void add(String id) {
    !id_list.contains(id) ? id_list.add(id) : null;
    notifyListeners();
  }
}
