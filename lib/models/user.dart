import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  String email;
  String username;
  String? profilePicture;
  DateTime? birthdayDate;
  String? reference;

  UserData(
      {required this.uid,
      required this.email,
      required this.username,
      this.profilePicture,
      this.birthdayDate,
      this.reference});

  factory UserData.fromFirestore(Map<dynamic, dynamic> json) => UserData(
      email: json['email'] as String,
      username: json['username'] as String,
      uid: json['uid'] as String,
      profilePicture: json['profilePicture'] as String?,
      birthdayDate: json['birthdayDate'] as DateTime?);

  Map<String, dynamic> toFirestore() => <String, dynamic>{
        "email": email.toString(),
        "username": username.toString(),
        "uid": uid.toString(),
        "profilePicture": profilePicture,
        "birthdayDate": birthdayDate,
      };

  factory UserData.fromSnapshot(DocumentSnapshot snapshot) {
    final user =
        UserData.fromFirestore(snapshot.data() as Map<String, dynamic>);
    user.reference = snapshot.reference.id;
    return user;
  }
}
