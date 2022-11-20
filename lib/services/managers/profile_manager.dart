import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/services/authentication/auth.dart';

import '../../models/user/login_user.dart';

class ProfileManager extends ChangeNotifier {
  User get getUser => AuthService().currentUser!;

  Future<void> editProfileInfo(LoginUser newInfo) async {}

  Future<void> updateProfilePicture(String newPhotoPath) async {}
}
