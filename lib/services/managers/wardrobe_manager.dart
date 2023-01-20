// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mokamayu/models/models.dart';

import '../../constants/tags.dart';
import '../authentication/auth.dart';
import '../database/database_service.dart';

class WardrobeManager extends ChangeNotifier {
  List<WardrobeItem> finalWardrobeItemList = [];
  List<WardrobeItem> finalWardrobeItemListCopy = [];

  List<WardrobeItem> finalFriendWardrobeItemList = [];
  List<WardrobeItem> finalFriendWardrobeItemListCopy = [];

  Future<List<WardrobeItem>>? futureWardrobeItemList;
  Future<List<WardrobeItem>>? futureWardrobeItemListCopy;

  Future<List<WardrobeItem>>? futureFriendWardrobeItemList;
  Future<List<WardrobeItem>>? futureFriendWardrobeItemListCopy;

  List<WardrobeItem> get getFinalWardrobeItemList => finalWardrobeItemList;

  List<WardrobeItem> get getFinalFriendWardrobeItemList =>
      finalFriendWardrobeItemList;

  Future<List<WardrobeItem>>? get getWardrobeItemList => futureWardrobeItemList;

  Future<List<WardrobeItem>>? get getWardrobeItemListCopy =>
      futureWardrobeItemListCopy;

  Future<List<WardrobeItem>>? get getFriendWardrobeItemList =>
      futureFriendWardrobeItemList;

  Future<List<WardrobeItem>>? get getFriendWardrobeItemListCopy =>
      futureFriendWardrobeItemListCopy;

  List<String>? itemTypes;
  List<String>? itemSizes;
  List<String>? itemStyles;

  void setWardrobeItemList(Future<List<WardrobeItem>> itemList) {
    futureWardrobeItemList = itemList;
    notifyListeners();
  }

  void setWardrobeItemListCopy(Future<List<WardrobeItem>> itemList) {
    futureWardrobeItemListCopy = itemList;
    notifyListeners();
  }

  void setFriendWardrobeItemList(Future<List<WardrobeItem>> itemList) {
    futureFriendWardrobeItemList = itemList;
    notifyListeners();
  }

  void setFriendWardrobeItemListCopy(Future<List<WardrobeItem>> itemList) {
    futureFriendWardrobeItemListCopy = itemList;
    notifyListeners();
  }

  void nullListItemCopy() {
    futureWardrobeItemListCopy = null;
    futureFriendWardrobeItemListCopy = null;
    notifyListeners();
  }

  void setTypes(List<String>? types) {
    itemTypes = types;
  }

  List<String>? get getTypes => itemTypes;

  void setSizes(List<String>? sizes) {
    itemSizes = sizes;
  }

  List<String>? get getSizes => itemSizes;

  void setStyles(List<String>? styles) {
    itemStyles = styles;
  }

  List<String>? get getStyles => itemStyles;

  Future<List<WardrobeItem>> readWardrobeItemOnce() async {
    QuerySnapshot snapshot = await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('wardrobe')
        .get();

    List<WardrobeItem> itemList = [];
    snapshot.docs.forEach((element) {
      WardrobeItem item = WardrobeItem.fromSnapshot(element);
      itemList.add(item);
    });
    finalWardrobeItemList = itemList;
    return finalWardrobeItemList;
  }

  Future<List<WardrobeItem>> readWardrobeItemsForUser(String uid) async {
    QuerySnapshot snapshot =
        await db.collection('users').doc(uid).collection('wardrobe').get();

    finalFriendWardrobeItemList = snapshot.docs
        .map((element) => WardrobeItem.fromSnapshot(element))
        .toList();
    return finalFriendWardrobeItemList;
  }

  Future<List<WardrobeItem>> filterWardrobe(
      BuildContext context,
      List<String> typesList,
      List<String> stylesList,
      List<String> sizesList,
      List<WardrobeItem> itemList) async {
    List<WardrobeItem> filteredList = [];
    typesList = typesList.isNotEmpty ? typesList : Tags.getLanguagesTypes(context);
    sizesList = sizesList.isNotEmpty ? sizesList : Tags.sizes;
    stylesList = stylesList.isNotEmpty ? stylesList : Tags.getLanguagesStyles(context);

    var set = Set.of(stylesList);

    for (var element in itemList) {
      WardrobeItem item = element;
      bool type = typesList.contains(item.type);
      bool styles = set.containsAll(item.styles);
      bool size = sizesList.contains(item.size);

      // print("Name:" +
      //     item.name +
      //     "\ntype: " +
      //     type.toString() +
      //     "\nstyles: " +
      //     styles.toString() +
      //     "\nsize: " +
      //     size.toString());

      if (type && styles && size) {
        filteredList.add(item);
      }
    }

    filteredList != null
        ? finalWardrobeItemListCopy = filteredList
        : finalWardrobeItemListCopy = itemList;

    return finalWardrobeItemListCopy;
  }

  Future<List<WardrobeItem>> filterFriendWardrobe(BuildContext context,
      List<String> typesList, List<WardrobeItem> itemList) async {
    List<WardrobeItem> filteredList = [];
    typesList = typesList.isNotEmpty ? typesList : Tags.getLanguagesTypes(context);

    filteredList =
        itemList.where((item) => typesList.contains(item.type)).toList();

    finalFriendWardrobeItemListCopy = filteredList;
    return finalFriendWardrobeItemListCopy;
  }

  void addWardrobeItem(WardrobeItem item) {
    db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('wardrobe')
        .add(item.toFirestore());
    notifyListeners();
  }

  void updateWardrobeItem(String reference, String? name, String? type,
      String? size, String? photoURL, List<String>? styles) {
    db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('wardrobe')
        .doc(reference)
        .update({
          'name': name,
          'type': type,
          'size': size,
          'photoURL': photoURL,
          'styles': styles,
        })
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));
  }

  void removeWardrobeItem(String? reference) {
    db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('wardrobe')
        .doc(reference)
        .delete()
        .then((_) => print('Deleted'))
        .catchError((error) => print(' $error'));
    // notifyListeners();
  }

  void resetBeforeCreatingNewOutfit() {
    nullListItemCopy();
    setTypes([]);
    setSizes([]);
    setStyles([]);
  }
}
