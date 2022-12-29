import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mokamayu/models/models.dart';

import '../../constants/tags.dart';
import '../authentication/auth.dart';
import '../database/database_service.dart';

class WardrobeManager extends ChangeNotifier {
  List<WardrobeItem> finalWardrobeItemList = [];
  List<WardrobeItem> finalWardrobeItemListCopy = [];
  Future<List<WardrobeItem>>? futureWardrobeItemList;
  Future<List<WardrobeItem>>? futureWardrobeItemListCopy;

  Future<List<WardrobeItem>>? get getWardrobeItemList => futureWardrobeItemList;

  Future<List<WardrobeItem>>? get getWardrobeItemListCopy =>
      futureWardrobeItemListCopy;

  List<WardrobeItem> get getFinalWardrobeItemList => finalWardrobeItemList;

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

  void nullListItemCopy() {
    futureWardrobeItemListCopy = null;
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

    return snapshot.docs
        .map((element) => WardrobeItem.fromSnapshot(element))
        .toList();
  }

  Future<List<WardrobeItem>> filterWardrobe(
      BuildContext context,
      List<String> typesList,
      List<String> stylesList,
      List<String> sizesList,
      List<WardrobeItem> itemList) async {
    List<WardrobeItem> filteredList = [];
    typesList = typesList.isNotEmpty ? typesList : Tags.types;
    sizesList = sizesList.isNotEmpty ? sizesList : Tags.sizes;
    stylesList = stylesList.isNotEmpty ? stylesList : Tags.styles;

    var set = Set.of(stylesList);

    itemList.forEach((element) {
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
    });

    filteredList != null
        ? finalWardrobeItemListCopy = filteredList
        : finalWardrobeItemListCopy = itemList;

    return finalWardrobeItemListCopy;
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
}
