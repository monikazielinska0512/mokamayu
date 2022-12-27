import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mokamayu/models/post.dart';
import '../../models/comment.dart';
import '../authentication/auth.dart';
import '../database/database_service.dart';
import 'dart:math';

class PostManager extends ChangeNotifier {
  List<Post> finalPostList = [];
  Future<List<Post>>? futurePostList;
  Future<List<Post>>? get getPostList => futurePostList;
  List<Post> get getFinalPostList => finalPostList;
  List<int> postIndexes = [0];
  int index = 0;
  bool indexSet = false;
  int get getMaxPostIndexes => postIndexes.reduce(max);
  List<int> get getIndexList => postIndexes;
  int get getIndex => index;
  bool get getIndexSet => indexSet;

  void removeFromIndexes(int idxToRemove) {
    postIndexes.removeWhere((el) => el == idxToRemove);
  }

  void addToIndexes(int idxToAdd) {
    print(postIndexes);
    postIndexes.add(idxToAdd);
  }

  void setIndex(int newIdx) {
    index = newIdx;
  }

  void setOutfitIndexesList(List<int> list) {
    postIndexes = list;
  }

  void indexIsSet(bool decision) {
    indexSet = decision;
    notifyListeners();
  }

  void setPosts(Future<List<Post>> postList) {
    futurePostList = postList;
  }

  Future<List<Post>> readPostsOnce() async {
    QuerySnapshot snapshot = await db
        .collection('users/*/posts')
        .get();

    List<Post> postList = [];
    for (var element in snapshot.docs) {
      Post item = Post.fromSnapshot(element);
      postList.add(item);
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

  void updatePost(String reference, String? cover, List<Comment>? comments, int? likes) {
    db
        .collection('users/*/posts')
        .doc(reference)
        .update({
      "cover": cover,
      "comments": comments,
      "likes": likes
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
