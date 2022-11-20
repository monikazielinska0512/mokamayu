import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mokamayu/services/authentication/authentication.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Stream<QuerySnapshot>? clothes;

class DatabaseService {
  static String? userID = AuthService().getCurrentUserID();

  final CollectionReference userOutfitCollection =
      db.collection('users').doc(userID).collection('outfits');

  static Stream<QuerySnapshot> readOutfits() {
    return db.collection('users').doc(userID).collection('outfits').snapshots();
  }
}
