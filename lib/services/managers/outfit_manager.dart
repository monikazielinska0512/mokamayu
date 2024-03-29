import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mokamayu/models/outfit.dart';

import '../../constants/tags.dart';
import '../authentication/auth.dart';
import '../database/database_service.dart';

class OutfitManager extends ChangeNotifier {
  List<Outfit> finalOutfitList = [];
  List<Outfit> finalOutfitListCopy = [];
  Future<List<Outfit>>? futureOutfitList;
  Future<List<Outfit>>? futureOutfitListCopy;

  Future<List<Outfit>>? get getOutfitList => futureOutfitList;

  Future<List<Outfit>>? get getOutfitListCopy => futureOutfitListCopy;

  List<Outfit> get getFinalOutfitList => finalOutfitList;
  List<String> outfitStyle = [];
  String? outfitSeason = "";
  List<String>? outfitStyles;
  List<String>? outfitSeasons;

  void setOutfits(Future<List<Outfit>> outfitsList) {
    futureOutfitList = outfitsList;
    notifyListeners();
  }

  void setOutfitsCopy(Future<List<Outfit>>? outfitsList) {
    futureOutfitListCopy = outfitsList;
    notifyListeners();
  }

  void setStyle(List<String> style) {
    outfitStyle = style;
  }

  List<String> get getStyle => outfitStyle;

  void setSeason(String? season) {
    outfitSeason = season;
  }

  String? get getSeason => outfitSeason;

  void setStyles(List<String>? styles) {
    outfitStyles = styles;
  }

  List<String>? get getStyles => outfitStyles;

  void setSeasons(List<String>? seasons) {
    outfitSeasons = seasons;
  }

  List<String>? get getSeasons => outfitSeasons;

  void nullListItemCopy() {
    futureOutfitListCopy = null;
    notifyListeners();
  }

  Future<List<Outfit>> readOutfitsOnce() async {
    QuerySnapshot snapshot = await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('outfits')
        .get();

    List<Outfit> outfitList = [];
    for (var element in snapshot.docs) {
      Outfit item = Outfit.fromSnapshot(element);
      outfitList.add(item);
    }
    finalOutfitList = outfitList;
    return finalOutfitList;
  }

  Future<List<Outfit>> readOutfitsForUser(String uid) async {
    QuerySnapshot snapshot =
        await db.collection('users').doc(uid).collection('outfits').get();

    return snapshot.docs
        .map((element) => Outfit.fromSnapshot(element))
        .toList();
  }

  Future<void> addOutfitToFirestore(Outfit item, String uid) async {
    await db
        .collection('users')
        .doc(uid)
        .collection('outfits')
        .add(item.toJson());

    notifyListeners();
  }

  void updateOutfit(String reference, List<String> styles, String? season,
      String? cover, List<String>? elements, Map<String, String>? map) {
    db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('outfits')
        .doc(reference)
        .update({
          "styles": styles,
          "season": season,
          "cover": cover,
          "elements": elements,
          "map": map,
        })
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));
  }

  Future<List<Outfit>> filterOutfits(
      BuildContext context,
      List<String> stylesList,
      List<String> seasonsList,
      List<Outfit> itemList) async {
    List<Outfit> filteredList = [];
    seasonsList =
        seasonsList.isNotEmpty ? seasonsList : OutfitTags.getSeasons(context);
    stylesList = stylesList.isNotEmpty
        ? stylesList
        : OutfitTags.getLanguagesStyles(context);
    var set = Set.of(stylesList);

    for (var element in itemList) {
      Outfit item = element;
      bool season = seasonsList.contains(item.season);
      bool style = set.containsAll(item.styles);

      if (season && style) {
        filteredList.add(item);
      }
    }

    // ignore: unnecessary_null_comparison
    filteredList != null
        ? finalOutfitListCopy = filteredList
        : finalOutfitListCopy = itemList;

    return finalOutfitListCopy;
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

  void resetSingleTags() {
    setSeason("");
    setStyle([]);
  }

  void resetTagLists() {
    setStyles([]);
    setSeasons([]);
  }
}
