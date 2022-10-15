import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mokamayu/services/auth.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final CollectionReference mainCollection = db.collection('users');

class DatabaseService {
  static String? userUid = AuthService().getCurrentUserUID();

  // Main collection - Users
  static Future<void> addUser() async {
    Map<String, dynamic> dataNewUser = <String, dynamic>{
      "user_id": userUid,
      "created": DateTime.now()
    };
    await mainCollection.doc(userUid).set(dataNewUser)
        .whenComplete(() => print("New user added to the database"))
        .catchError((e) => print(e));
  }
  static Stream<QuerySnapshot> readAllUsers() {
      return mainCollection.snapshots();
    }
  static Future<void> deleteUser({
    required String docId,
  }) async {
    await mainCollection.doc(userUid)
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }

}