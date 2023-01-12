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
      if(!notif.read) {
        temp.add(notif);
      }
    }
    print("readNotificationsOnce");
    notificationList = temp;
    return notificationList;
  }

  Future<void> addNotificationToFirestore(CustomNotification item, String uid) async {
    await db
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .add(item.toJson());
    print("dodano?");
    notifyListeners();
  }

  void notificationRead(String reference) {
    db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('notifications')
        .doc(reference)
        .update({"read": true})
        .then((_) => print('Read'))
        .catchError((error) => print('Update failed: $error'));
  }

}
