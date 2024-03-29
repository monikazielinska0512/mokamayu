// ignore_for_file: avoid_print, unnecessary_null_comparison

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

  bool block = false;
  bool get getBlock => block;

  List<String>? itemTypes;
  List<String>? itemSizes;
  List<String>? itemStyles;
  List<String>? itemColors;
  List<String>? itemMaterials;

  void blockEdit(bool newblock) {
    block = newblock;
  }

  void setWardrobeItemList(Future<List<WardrobeItem>> itemList) {
    futureWardrobeItemList = itemList;
    notifyListeners();
  }

  void setWardrobeItemListCopy(Future<List<WardrobeItem>>? itemList) {
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

  void setColors(List<String>? colors) {
    itemColors = colors;
  }

  List<String>? get getColors => itemColors;

  void setMaterials(List<String>? materials) {
    itemMaterials = materials;
  }

  List<String>? get getMaterials => itemMaterials;

  Future<List<WardrobeItem>> readWardrobeItemOnce() async {
    QuerySnapshot snapshot = await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('wardrobe')
        .get();

    List<WardrobeItem> itemList = [];
    for (var element in snapshot.docs) {
      WardrobeItem item = WardrobeItem.fromSnapshot(element);
      itemList.add(item);
    }
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
      List<String> colorsList,
      List<String> materialsList,
      List<WardrobeItem> itemList) async {
    List<WardrobeItem> filteredList = [];
    typesList =
        typesList.isNotEmpty ? typesList : Tags.getLanguagesTypes(context);
    sizesList = sizesList.isNotEmpty ? sizesList : Tags.sizes;
    stylesList =
        stylesList.isNotEmpty ? stylesList : Tags.getLanguagesStyles(context);

    colorsList =
        colorsList.isNotEmpty ? colorsList : Tags.getLanguagesColors(context);

    materialsList = materialsList.isNotEmpty
        ? materialsList
        : Tags.getLanguagesMaterials(context);

    var stylesSet = Set.of(stylesList);
    var colorsSet = Set.of(colorsList);
    var materialsSet = Set.of(materialsList);

    for (var element in itemList) {
      WardrobeItem item = element;
      bool type = typesList.contains(item.type);
      bool styles = stylesSet.containsAll(item.styles);
      bool colors = colorsSet.containsAll(item.colors);
      bool materials = materialsSet.containsAll(item.materials);
      bool size = sizesList.contains(item.size);

      if (type && styles && colors && materials && size) {
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
    typesList =
        typesList.isNotEmpty ? typesList : Tags.getLanguagesTypes(context);

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

  void updateWardrobeItem(
      String reference,
      String? name,
      String? type,
      String? size,
      String? photoURL,
      List<String>? styles,
      List<String>? colors,
      List<String>? materials) {
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
          'colors': colors,
          'materials': materials
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
  }

  void resetBeforeCreatingNewOutfit() {
    nullListItemCopy();
    setTypes([]);
    setSizes([]);
    setStyles([]);
    setColors([]);
    setMaterials([]);
  }
}
