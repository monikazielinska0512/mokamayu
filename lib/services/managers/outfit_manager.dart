import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mokamayu/models/outfit.dart';
import '../authentication/auth.dart';
import '../database/database_service.dart';

class OutfitManager extends ChangeNotifier {
  List<Outfit> finalOutfitList = [];
  Future<List<Outfit>>? futureOutfitList;

  Future<List<Outfit>>? get getOutfitList => futureOutfitList;
  List<Outfit> get getfinalOutfitList => finalOutfitList;

  int get getOutfitsNumber => finalOutfitList.length;

  String? outfitStyle = "";
  String? outfitSeason = "";

  void setOutfits(Future<List<Outfit>> outfitsList) {
    futureOutfitList = outfitsList;
  }

  void setStyle(String? style) {
    outfitStyle = style;
  }

  String? get getStyle => outfitStyle;

  void setSeason(String? season) {
    outfitSeason = season;
  }

  String? get getSeason => outfitSeason;

  Future<List<Outfit>> readOutfitsOnce() async {
    QuerySnapshot snapshot = await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('outfits')
        .get();

    List<Outfit> outfitList = [];
    snapshot.docs.forEach((element) {
      Outfit item = Outfit.fromSnapshot(element);
      outfitList.add(item);
    });
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

  void updateOutfit(String reference, String? style, String? season,
      String? cover, List<String>? elements, Map<String, String>? map) {
    db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('outfits')
        .doc(reference)
        .update({
          "style": style,
          "season": season,
          "cover": cover,
          "elements": elements,
          "map": map,
        })
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));
  }

  void removeOutfit(String? reference) {
    db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('outfits')
        .doc(reference)
        .delete()
        .then((_) => print('Deleted'))
        .catchError((error) => print(' $error'));
  }
}
