import 'package:cloud_firestore/cloud_firestore.dart';


class Post{
  final String createdBy;
  final String createdFor;
  final String cover;
  final int creationDate;
  final List<String>? likes;
  final List<Map<String, String>>? comments;
  String? reference;

  Post({
    required this.createdBy,
    required this.createdFor,
    required this.cover,
    required this.creationDate,
    this.likes,
    this.comments,
    this.reference,
  });

  factory Post.fromJson(Map<dynamic, dynamic> json) => Post(
    createdBy: json['createdBy'] as String,
    createdFor: json['createdFor'] as String,
    cover: json['cover'] as String,
    creationDate: json['creationDate'] as int,
    likes: List.from(json['likes']),
    comments: json['comments'] = (json['comments'] as List)
        .map((e) => Map<String, String>.from(e)).toList(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    "createdBy": createdBy.toString(),
    "createdFor": createdFor.toString(),
    "cover": cover.toString(),
    "creationDate": creationDate,
    "likes": likes,
    "comments": comments,
  };

  factory Post.fromSnapshot(DocumentSnapshot snapshot){
    final post = Post.fromJson(snapshot.data() as Map<String, dynamic>);
    post.reference = snapshot.reference.id;
    return post;
  }
}
