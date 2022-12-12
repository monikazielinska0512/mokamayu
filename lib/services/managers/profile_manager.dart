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
    _currentCustomUser = UserData(email: email, username: username, uid: uid);
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

  Future<UserData?> getUserData(User? user) async {
    if (user != null) {
      DocumentSnapshot? snapshot =
          await db.collection('users').doc(user.uid).get();
      return UserData.fromSnapshot(snapshot);
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

  Future<void> updateProfilePicture(String newPhotoPath) async {
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
}
