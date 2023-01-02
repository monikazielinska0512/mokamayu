import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../database/database_service.dart';

class FriendsManager extends ChangeNotifier {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  final DocumentReference userFriendsCollection =
      db.collection('friends').doc(DatabaseService.userID);

// TODO(karina): implement the following methods:
//
// Stream<DocumentSnapshot<Object?>> getFriendsList() =>
//     userFriendsCollection.snapshots();
//
// Future<void> updateFriendsList(List<String> friendsList) async {
//   userFriendsCollection.set({'friends': friendsList});
// }
//
// Future<List<String>> get friendsList =>
//     getFriendsList().first.then((value) => value.get('friends'));

// Future<String> getFriendshipStatus(String friend) {}

  Future<void> sendFriendInvite(String friend) async {

  }

  Future<void> cancelFriendInvite(String friend) async {}

  Future<void> acceptFriendInvite(String friend) async {}

  Future<void> rejectFriendInvite(String friend) async {}
}

