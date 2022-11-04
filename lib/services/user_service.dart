import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  String get username =>
      currentUser?.displayName ?? currentUser?.email ?? 'Username';

// TODO(karina): implement the following methods:

// Future<List<String>> get friendsList => DatabaseService()
//     .getFriendsList()
//     .first
//     .then((value) => value.get('friends'));

// bool get isFriendsWith {}

// sendFriendInvite()

// cancelFriendInvite()

// acceptFriendInvite()

// rejectFriendInvite()

// updateProfilePicture()

//
}
