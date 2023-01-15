import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mokamayu/models/post.dart';

import '../authentication/auth.dart';
import '../database/database_service.dart';

class PostManager extends ChangeNotifier {
  List<Post> finalPostList = [];
  List<Post> finalCurrentUserPostList = [];
  Future<List<Post>>? futurePostList;
  Future<List<Post>>? get getPostList => futurePostList;

  Future<List<Post>>? get getFinalCurrentUserPostList async =>
      finalCurrentUserPostList;

  List<Post> get getFinalPostList => finalPostList;
  List<Post> friendsPostList = [];

  void setPosts(Future<List<Post>> postList) {
    futurePostList = postList;
  }

  Future<List<Post>> readPostsOnce() async {
    QuerySnapshot snapshot = await db
        .collectionGroup('posts')
        .get();

    List<Post> postList = [];
    for (var element in snapshot.docs) {
      Post item = Post.fromSnapshot(element);
      postList.add(item);
    }
    finalPostList = postList;
    return finalPostList;
  }

  Future<List<Post>> getUserPosts(String uid) async {
    QuerySnapshot snapshot =
        await db.collection('users').doc(uid).collection('posts').get();

    return snapshot.docs.map((element) => Post.fromSnapshot(element)).toList();
  }

  Future<Post?> getPostByUid(String uid) async {
    final docRef = db
        .collection("users")
        .doc(AuthService().getCurrentUserID())
        .collection("posts")
        .doc(uid);
    docRef.get().then(
          (DocumentSnapshot doc) {
        return doc;
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return null;
  }

  Future<List<Post>>? getCurrentUserPosts() async {
    QuerySnapshot snapshot = await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('posts')
        .get();
    var list = snapshot.docs.map((element) => Post.fromSnapshot(element)).toList();
    list.sort((b, a) => a.creationDate.compareTo(b.creationDate));
    finalCurrentUserPostList = list;
    return finalCurrentUserPostList;
  }

  Future<void> addPostToFirestore(Post item, String uid) async {
    await db
        .collection('users')
        .doc(uid)
        .collection('posts')
        .add(item.toJson());

    notifyListeners();
  }

  List<Post> readFeedPostsOnce(List<String> friendList, List<Post> postList) {
    List<Post> list = [];
    for (var element in postList) {
      if (friendList.contains(element.createdBy)) {
        list.add(element);
      }
    }
    list.sort((b, a) => a.creationDate.compareTo(b.creationDate));
    friendsPostList = list;
    return friendsPostList;
  }

  void likePost(String reference, String owner, List<String> likes) {
    db
        .collection('users')
        .doc(owner)
        .collection('posts')
        .doc(reference)
        .update({"likes": likes})
        .then((_) => print('Liked'))
        .catchError((error) => print('Update failed: $error'));
  }
  void commentPost(String reference, String owner, List<Map<String, String>> comments) {
    db
        .collection('users')
        .doc(owner)
        .collection('posts')
        .doc(reference)
        .update({"comments": comments})
        .then((_) => print('Commented'))
        .catchError((error) => print('Update failed: $error'));
    notifyListeners();
  }

  void updatePost(String reference, String cover) {
    db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('posts')
        .doc(reference)
        .update({
          "cover": cover,
        })
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));
  }

  void removePost(String? reference) {
    db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('posts')
        .doc(reference)
        .delete()
        .then((_) => print('Deleted'))
        .catchError((error) => print(' $error'));
  }
}
