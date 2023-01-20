// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/authentication/auth.dart';

import '../database/database_service.dart';

class NotificationsManager extends ChangeNotifier {
  late List<CustomNotification> notificationList;
  List<CustomNotification> get getNotificationList => notificationList;

  Future<List<CustomNotification>> readNotificationsOnce() async {
    List<CustomNotification> temp = [];
    QuerySnapshot snapshot = await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('notifications')
        .get();
    for (var element in snapshot.docs) {
      CustomNotification notif = CustomNotification.fromSnapshot(element);

      temp.add(notif);
    }
    print("readNotificationsOnce");
    notificationList = temp;
    return notificationList;
  }

  Future<void> addNotificationToFirestore(
      CustomNotification item, String uid) async {
    await db
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .add(item.toJson());
    print("dodano?");
    notifyListeners();
  }

  void deleteNotification(String reference) {
    db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('notifications')
        .doc(reference)
        .delete().then((_) => print('Deleted'))
        .catchError((error) => print(' $error'));
  }
}
