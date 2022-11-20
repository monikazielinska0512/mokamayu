import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mokamayu/models/models.dart';
import '../authentication/auth.dart';
import '../database/database_service.dart';

class ClothesManager extends ChangeNotifier {
  List<Clothes> clothesList = [];
  Future<List<Clothes>>? futureClothesList;

  Future<List<Clothes>>? get getClothesList => futureClothesList;

  void setClothes(Future<List<Clothes>> clothesList) {
    futureClothesList = clothesList;
    notifyListeners();
  }

  Future<List<Clothes>> readClothesOnce() async {
    QuerySnapshot snapshot = await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('clothes')
        .get();
    List<Clothes> clothes = snapshot.docs
        .map((d) => Clothes.fromJson(d.data() as Map<String, dynamic>))
        .toList();

    clothesList = clothes;
    return clothesList;
  }

  Future<void> addClothes(Clothes clothes) async {
    await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('clothes')
        .add(clothes.toJson());

    notifyListeners();
  }
}
