import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  String email;
  String username;
  String? profileName;
  String? profilePicture;
  DateTime? birthdayDate;
  bool privateProfile;
  String? reference;

  UserData(
      {required this.uid,
      required this.email,
      required this.username,
      this.profileName,
      this.profilePicture,
      this.birthdayDate,
      this.privateProfile = false,
      this.reference});

  factory UserData.fromFirestore(Map<dynamic, dynamic> json) => UserData(
        uid: json['uid'] as String,
        email: json['email'] as String,
        username: json['username'] as String,
        profileName: json['profileName'] as String?,
        profilePicture: json['profilePicture'] as String?,
        birthdayDate: json['birthdayDate'] as DateTime?,
        privateProfile: json['privateProfile'] as bool,
      );

  Map<String, dynamic> toFirestore() => <String, dynamic>{
        "uid": uid.toString(),
        "email": email.toString(),
        "username": username.toString(),
        "profileName": profileName,
        "profilePicture": profilePicture,
        "birthdayDate": birthdayDate,
        "privateProfile": privateProfile,
      };

  factory UserData.fromSnapshot(DocumentSnapshot snapshot) {
    final user =
        UserData.fromFirestore(snapshot.data() as Map<String, dynamic>);
    user.reference = snapshot.reference.id;
    return user;
  }
}
