import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../database/database_service.dart';

enum FriendshipState {
  STRANGERS,
  // Our invite is waiting for the other person's response.
  INVITE_PENDING,
  // We received a friend invite but haven't responded yet.
  RECEIVED_INVITE,
  FRIENDS
}

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
//
// Future<FriendshipStatus> getFriendshipStatus(User friend);
//
// Future<void> sendFriendInvite(User friend) async {}
//
// Future<void> cancelFriendInvite(User friend) async {}
//
// Future<void> acceptFriendInvite(User friend) async {}
//
// Future<void> rejectFriendInvite(User friend) async {}
}
