import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mokamayu/services/auth.dart';
import '../../models/wardrobe/clothes.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final CollectionReference userCollection = db.collection('users');

class DatabaseService {
  static String? userUid = AuthService().getCurrentUserUID();

  final CollectionReference userClothesCollection =
      db.collection('users').doc(userUid).collection('clothes');
  final CollectionReference userFriendsCollection =
      db.collection('users').doc(userUid).collection('friends');
  final CollectionReference userOutfitCollection =
      db.collection('users').doc(userUid).collection('outfits');

  static Future<void> addUser() async {
    Map<String, dynamic> newUser = <String, dynamic>{
      "user_id": userUid,
      "created": DateTime.now()
    };
    await userCollection
        .doc(userUid)
        .set(newUser)
        .whenComplete(() => print("New user added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> addToWardrobe(Clothes clothes) async {
    await db
        .collection('users')
        .doc(userUid)
        .collection('clothes')
        .add(clothes.toMap());
  }

  static Stream<QuerySnapshot> readClothes() {
    return db
        .collection('users')
        .doc(userUid)
        .collection('clothes')
        .snapshots();
  }
}
