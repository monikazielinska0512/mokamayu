import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<DocumentSnapshot<Object?>> getFriendsList() =>
      userFriendsCollection.snapshots();

  Future<void> updateFriendsList(List<String> friendsList) async {
    await db.collection('friends').doc(userID).set({'friends': friendsList});
  }




}
