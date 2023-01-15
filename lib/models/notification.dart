import 'package:cloud_firestore/cloud_firestore.dart';


enum NotificationType {
  LIKE,
  COMMENT,
  NEW_OUTFIT,
  ACCEPTED_INVITE,
  RECEIVED_INVITE
}


class CustomNotification {
  final String sentFrom;
  final String type;
  final int creationDate;
  String? reference;

  CustomNotification({
    required this.sentFrom,
    required this.type,
    required this.creationDate,
  });

  factory CustomNotification.fromJson(Map<dynamic, dynamic> json) => CustomNotification(
    sentFrom: json['sentFrom'] as String,
    creationDate: json['creationDate'] as int,
    type: json['type'] as String,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    "sentFrom": sentFrom.toString(),
    "creationDate": creationDate,
    "type": type,
  };

  factory CustomNotification.fromSnapshot(DocumentSnapshot snapshot){
    final notif = CustomNotification.fromJson(snapshot.data() as Map<String, dynamic>);
    notif.reference = snapshot.reference.id;
    return notif;
  }
}