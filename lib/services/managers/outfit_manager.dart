import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:mokamayu/screens/screens.dart';
import '../authentication/auth.dart';
import '../database/database_service.dart';

class OutfitManager extends ChangeNotifier {
  List<Outfit> finalOutfitList = [];
  Future<List<Outfit>>? futureOutfitList;

  Future<List<Outfit>>? get getOutfitList => futureOutfitList;
  List<Outfit> get getfinalOutfitList => finalOutfitList;

  void setOutfits(Future<List<Outfit>> outfitsList) {
    futureOutfitList = outfitsList;
    notifyListeners();
  }

  Future<List<Outfit>> readOutfitsOnce() async {
    QuerySnapshot snapshot = await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('outfits')
        .get();

    // List<Outfit> outfitList = [];
    // snapshot.docs.forEach((element) {
    //   //print(element);
    //   Outfit item = Outfit.fromSnapshot(element);
    //   outfitList.add(item);
    // });
    List<Outfit> outfitList = snapshot.docs
        .map((d) => Outfit.fromJson(d.data() as Map<String, dynamic>))
        .toList();

    print(outfitList);

    finalOutfitList = outfitList;
    return finalOutfitList;
  }

  Future<void> addOutfitToFirestore(Outfit item) async {
    await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('outfits')
        .add(item.toJson());

    notifyListeners();
  }
}
