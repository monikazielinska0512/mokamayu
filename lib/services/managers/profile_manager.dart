import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/services/authentication/auth.dart';
import '../../models/models.dart';
import '../database/database_service.dart';

class ProfileManager extends ChangeNotifier {
  UserData? _currentCustomUser;

  DocumentReference<Map<String, dynamic>> get currentUserDocument =>
      db.collection('users').doc(AuthService().getCurrentUserID());

  // Default user - in the Authentication tab
  User? get currentAuthUser => AuthService().currentUser;

  // Custom user - in the "users" collection
  UserData? get currentCustomUser => _currentCustomUser;

  void createUser(String email, String username, String uid) async {
    await currentAuthUser?.updateDisplayName(username);
    _currentCustomUser = UserData(email: email, username: username, uid: uid, friends: []);
    currentUserDocument.set(currentCustomUser!.toFirestore());
  }

  Future<UserData?> getCurrentUserData() async {
    if (currentAuthUser != null) {
      DocumentSnapshot? snapshot = await currentUserDocument.get();
      _currentCustomUser = UserData.fromSnapshot(snapshot);
      return _currentCustomUser;
    }
    return null;
  }

  Future<UserData?> getUserData(String? uid) async {
    if (uid != null) {
      DocumentSnapshot? snapshot = await db.collection('users').doc(uid).get();
      UserData user = UserData.fromSnapshot(snapshot);
      if (uid == AuthService().getCurrentUserID()){
        _currentCustomUser = user;
      }
      return user;
    }
    return null;
  }

  Future<void> updateEmail(String newEmail) async {
    await currentAuthUser?.updateEmail(newEmail);
    currentCustomUser?.email = newEmail;
    updateUsersCollection();
    notifyListeners();
  }

  Future<void> updateUsername(String newUsername) async {
    await currentAuthUser?.updateDisplayName(newUsername);
    currentCustomUser?.username = newUsername;
    updateUsersCollection();
    notifyListeners();
  }

  Future<void> updateProfilePicture(String? newPhotoPath) async {
    await currentAuthUser?.updatePhotoURL(newPhotoPath);
    currentCustomUser?.profilePicture = newPhotoPath;
    updateUsersCollection();
    notifyListeners();
  }

  Future<void> updateProfileName(String newProfileName) async {
    currentCustomUser?.profileName = newProfileName;
    updateUsersCollection();
    notifyListeners();
  }

  Future<void> updateBirthdayDate(DateTime newDate) async {
    currentCustomUser?.birthdayDate = newDate;
    updateUsersCollection();
    notifyListeners();
  }

  Future<void> updatePrivacy(bool isPrivate) async {
    currentCustomUser?.privateProfile = isPrivate;
    updateUsersCollection();
    notifyListeners();
  }

  void updateUsersCollection() {
    currentUserDocument.update(currentCustomUser!.toFirestore());
  }

  void updateAnyUsersCollection(UserData user) {
    db
      .collection('users')
      .doc(user.uid)
      .update(user.toFirestore())
      .then((_) => print('Updated'))
      .catchError((error) => print('Update failed: $error'));
  }

  Future<void> sendFriendInvite(UserData friend) async {
    friend.friends!.add({"id": _currentCustomUser!.uid, "status": FriendshipState.RECEIVED_INVITE.toString()});
    currentCustomUser!.friends!.add({"id": friend.uid, "status": FriendshipState.INVITE_PENDING.toString()});
    updateUsersCollection();
    updateAnyUsersCollection(friend);
    notifyListeners();
  }

  Future<void> cancelFriendInvite(UserData friend) async {
    friend.friends!.removeWhere((element) => element['id'] == _currentCustomUser!.uid);
    currentCustomUser!.friends!.removeWhere((element) => element['id'] == friend.uid);
    updateUsersCollection();
    updateAnyUsersCollection(friend);
    notifyListeners();
  }

  Future<void> acceptFriendInvite(UserData friend) async {
    friend.friends!.removeWhere((element) => element['id'] == _currentCustomUser!.uid);
    currentCustomUser!.friends!.removeWhere((element) => element['id'] == friend.uid);
    friend.friends!.add({"id": _currentCustomUser!.uid, "status": FriendshipState.FRIENDS.toString()});
    currentCustomUser!.friends!.add({"id": friend.uid, "status": FriendshipState.FRIENDS.toString()});
    updateUsersCollection();
    updateAnyUsersCollection(friend);
    notifyListeners();
  }

  Future<void> rejectFriendInvite(UserData friend) async {
    friend.friends!.removeWhere((element) => element['id'] == _currentCustomUser!.uid);
    currentCustomUser!.friends!.removeWhere((element) => element['id'] == friend.uid);
    updateUsersCollection();
    updateAnyUsersCollection(friend);
    notifyListeners();
  }

  Future<void> removeFriend(UserData friend) async {
    friend.friends!.removeWhere((element) => element['id'] == _currentCustomUser!.uid);
    currentCustomUser!.friends!.removeWhere((element) => element['id'] == friend.uid);
    updateUsersCollection();
    updateAnyUsersCollection(friend);
    notifyListeners();
  }

  String getFriendshipStatus(String friendId) {
    var friend = currentCustomUser!.friends!.where((element) => element["id"] == friendId);
    return friend.isNotEmpty
    ? friend.first['status']!
    : FriendshipState.STRANGERS.toString();
  }
  
  List<UserData> getFriendsList(){
    List <String> friends = [];
    for (var element in currentCustomUser!.friends!) {friends.add(element['id']!);}
    return [];
  }
}

