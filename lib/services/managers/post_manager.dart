import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mokamayu/models/post.dart';
import '../authentication/auth.dart';
import '../database/database_service.dart';


class PostManager extends ChangeNotifier {
  List<Post> finalPostList = [];
  Future<List<Post>>? futurePostList;
  Future<List<Post>>? get getPostList => futurePostList;
  List<Post> get getFinalPostList => finalPostList;

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
      if (item.createdBy != AuthService().getCurrentUserID()) {
        postList.add(item);
      }
    }
    finalPostList = postList;
    return finalPostList;
  }

  Future<void> addPostToFirestore(Post item) async {
    await db
        .collection('users')
        .doc(AuthService().getCurrentUserID())
        .collection('posts')
        .add(item.toJson());

    notifyListeners();
  }

  void likePost(String reference, String author, List<String> likes) {
    db
        .collection('users')
        .doc(author)
        .collection('posts')
        .doc(reference)
        .update({
          "likes": likes
        })
        .then((_) => print('Liked'))
        .catchError((error) => print('Update failed: $error'));
  }
  void commentPost(String reference, String author, List<Map<String, String>> comments) {
    db
        .collection('users')
        .doc(author)
        .collection('posts')
        .doc(reference)
        .update({
        "comments": comments
    })
        .then((_) => print('Commented'))
        .catchError((error) => print('Update failed: $error'));
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
