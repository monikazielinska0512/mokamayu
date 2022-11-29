import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/models/outfit.dart';
import '../authentication/auth.dart';
import '../database/database_service.dart';

class OutfitManager extends ChangeNotifier {
  List<Outfit> finalOutfitList = [];
  Future<List<Outfit>>? futureOutfitList;

  Future<List<Outfit>>? get getWardrobeItemList => futureOutfitList;
  List<Outfit> get getfinalWardrobeItemList => finalOutfitList;

  void setWardrobeItem(Future<List<Outfit>> itemList) {
    futureOutfitList = itemList;
    notifyListeners();
  }

  Future<List<Outfit>> readWardrobeItemOnce() async {
    QuerySnapshot snapshot = await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('outfit')
        .get();

    List<Outfit> outfitList = [];
    snapshot.docs.forEach((element) {
      Outfit item = Outfit.fromSnapshot(element);
      outfitList.add(item);
    });

    finalOutfitList = outfitList;
    return finalOutfitList;
  }

  Future<void> addOutfitToFirebase(Outfit item) async {
    await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('outfit')
        .add(item.toJson());

    notifyListeners();
  }
}
