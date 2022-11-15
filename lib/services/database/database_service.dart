import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/wardrobe/clothes.dart';
import '../authentication/auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Stream<QuerySnapshot>? clothes;

class DatabaseService {
  static String? userID = AuthService().getCurrentUserID();

  final CollectionReference userClothesCollection =
  db.collection('users').doc(userID).collection('clothes');
  final CollectionReference userOutfitCollection =
  db.collection('users').doc(userID).collection('outfits');

  final DocumentReference userFriendsCollection =
  db.collection('friends').doc(userID);

  static Stream<QuerySnapshot> readOutfits() {
    return db.collection('users').doc(userID).collection('outfits').snapshots();
  }

  static Stream<QuerySnapshot>? getClothesFromWardrobe() {
    return clothes;
  }

  Stream<DocumentSnapshot<Object?>> getFriendsList() =>
      userFriendsCollection.snapshots();

  Future<void> updateFriendsList(List<String> friendsList) async {
    await db.collection('friends').doc(userID).set({'friends': friendsList});
  }

  static Future<void> removeClothes(String id) async {
    await db
        .collection("users")
        .doc(AuthService().getCurrentUserID())
        .collection("clothes")
        .doc(id)
        .delete()
        .then(
          (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e"),
    );
  }

  static Future<void> updateClothes(String id, Clothes clothes) async {
    await db
        .collection("users")
        .doc(AuthService().getCurrentUserID())
        .collection("clothes")
        .doc(id)
        .update({
      "name": clothes.name,
      "type": clothes.type,
      "size": clothes.size,
      "photoURL": clothes.photoURL,
      "created": clothes.created,
      "styles": clothes.styles,
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }
}