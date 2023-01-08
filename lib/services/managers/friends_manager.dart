import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/services.dart';

class FriendsManager extends ChangeNotifier {
  List<UserData> friendList = [];

  List<UserData> get getFriendList => friendList;
  List<String> friendIdsList = [];

  List<String> get getFriendIdsList => friendIdsList;
  List<UserData> requestList = [];

  List<UserData> get getRequestList => requestList;

  Future<List<UserData>> readFriendsOnce(UserData currentUser) async {
    List<String> friends = [];
    for (var element in currentUser.friends!) {
      if (element['status'] == FriendshipState.FRIENDS.toString()) {
        friends.add(element['id']!);
      }
    }

    List<UserData> temp = [];
    QuerySnapshot snapshot = await db.collection('users').get();
    for (var element in snapshot.docs) {
      UserData user = UserData.fromSnapshot(element);
      if (friends.contains(user.uid)) {
        temp.add(user);
      }
    }
    friendList = temp;
    return friendList;
  }

  List<String> readFriendsIdsOnce(UserData currentUser) {
    List<String> friends = [];
    for (var element in currentUser.friends!) {
      if (element['status'] == FriendshipState.FRIENDS.toString()) {
        friends.add(element['id']!);
      }
    }
    friendIdsList = friends;
    return friendIdsList;
  }

  Future<List<UserData>> readRequestsOnce(UserData currentUser) async {
    List<String> friends = [];
    for (var element in currentUser.friends!) {
      if (element['status'] == FriendshipState.RECEIVED_INVITE.toString()) {
        friends.add(element['id']!);
      }
    }

    List<UserData> temp = [];
    QuerySnapshot snapshot = await db.collection('users').get();
    for (var element in snapshot.docs) {
      UserData user = UserData.fromSnapshot(element);
      if (friends.contains(user.uid)) {
        temp.add(user);
      }
    }
    requestList = temp;
    return requestList;
  }

  bool isMyFriend(String uid) {
    return getFriendIdsList.contains(uid);
  }
}
