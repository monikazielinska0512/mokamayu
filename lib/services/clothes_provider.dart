import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mokamayu/models/wardrobe/clothes.dart';
import 'authentication/auth.dart';
import 'database/database_service.dart';

class ClothesProvider extends ChangeNotifier {
  List<Clothes> clothesList = [];
  late Future<List<Clothes>> futureClothesList;
  Future<List<Clothes>> get getClothesList => futureClothesList;

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
    List<Clothes> _clothes = snapshot.docs
        .map((d) => Clothes.fromFirestore(d.data() as Map<String, dynamic>))
        .toList() as List<Clothes>;

    clothesList = _clothes;
    // futureClothesList = clothesList as Future<List<Clothes>>;
    notifyListeners();
    return clothesList;
  }
}
