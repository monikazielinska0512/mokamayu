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
  final bool read;
  final String type;
  final int creationDate;
  final String? additionalData;
  String? reference;

  CustomNotification({
    required this.sentFrom,
    this.read = false,
    required this.type,
    required this.creationDate,
    this.additionalData
  });

  factory CustomNotification.fromJson(Map<dynamic, dynamic> json) => CustomNotification(
    sentFrom: json['sentFrom'] as String,
    read: json['read'] as bool,
    creationDate: json['creationDate'] as int,
    type: json['type'] as String,
    additionalData: json['additionalData'] as String?
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    "sentFrom": sentFrom.toString(),
    "read": read,
    "creationDate": creationDate,
    "type": type,
    "additionalData": additionalData
  };

  factory CustomNotification.fromSnapshot(DocumentSnapshot snapshot){
    final notif = CustomNotification.fromJson(snapshot.data() as Map<String, dynamic>);
    notif.reference = snapshot.reference.id;
    return notif;
  }
}