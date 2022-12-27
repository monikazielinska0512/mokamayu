import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/services/authentication/auth.dart';

import '../../models/models.dart';
import '../database/database_service.dart';

class UserListManager extends ChangeNotifier {
  User? get currentAuthUser => AuthService().currentUser;
  List<UserData> userList = [];
  List<UserData> get getUserList => userList;


  Future<List<UserData>> readUserOnce() async {
    List<UserData> temp = [];
    QuerySnapshot snapshot = await db
        .collection('users')
        .get();
    for (var element in snapshot.docs) {
      UserData user = UserData.fromSnapshot(element);
      if (user.uid != currentAuthUser?.uid) {
        temp.add(user);
      }
    }
    userList = temp;
    return userList;
  }


}
