import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/services/authentication/auth.dart';

import '../../models/models.dart';
import '../database/database_service.dart';

class ProfileManager extends ChangeNotifier {
  UserData? _customUser;

  DocumentReference<Map<String, dynamic>> get usersCollection =>
      db.collection('users').doc(AuthService().getCurrentUserID());

  // Default user - in the Authentication tab
  User? get authUser => AuthService().currentUser;

  // Custom user - in the "users" collection
  UserData? get customUser => _customUser;

  void createUser(String email, String username, String uid) async {
    await authUser?.updateDisplayName(username);
    _customUser = UserData(email: email, username: username, uid: uid);
    usersCollection.set(customUser!.toFirestore());
  }

  Future<UserData?> getUserInfo() async {
    if (authUser != null) {
      DocumentSnapshot? snapshot = await usersCollection.get();
      return UserData.fromSnapshot(snapshot);
    }
    return null;
  }

  Future<void> updateEmail(String newEmail) async {
    await authUser?.updateEmail(newEmail);
    customUser?.email = newEmail;
    updateUsersCollection();
    notifyListeners();
  }

  Future<void> updateUsername(String newUsername) async {
    await authUser?.updateDisplayName(newUsername);
    customUser?.username = newUsername;
    updateUsersCollection();
    notifyListeners();
  }

  Future<void> updateProfilePicture(String newPhotoPath) async {
    await authUser?.updatePhotoURL(newPhotoPath);
    customUser?.profilePicture = newPhotoPath;
    updateUsersCollection();
    notifyListeners();
  }

  Future<void> updateProfileName(String newProfileName) async {
    customUser?.profileName = newProfileName;
    updateUsersCollection();
    notifyListeners();
  }

  Future<void> updateBirthdayDate(DateTime newDate) async {
    customUser?.birthdayDate = newDate;
    updateUsersCollection();
    notifyListeners();
  }

  void updateUsersCollection() {
    usersCollection.update(customUser!.toFirestore());
  }
}
