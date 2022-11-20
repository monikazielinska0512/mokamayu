// class Clothes {
//   final String? name;
//   final String? type;
//   final String? size;
//   final String? photoURL;
//   final List<String>? styles;
//   final DateTime? created;
//
//   Clothes({
//     required this.name,
//     required this.type,
//     required this.size,
//     required this.photoURL,
//     this.styles,
//     this.created,
//   });
//
//   factory Clothes.fromFirestore(
//     Map<String, dynamic> data,
//   ) {
//     return Clothes(
//       name: data['name'],
//       type: data['type'],
//       size: data['size'],
//       photoURL: data['photoURL'],
//       created: data['created'],
//       styles: data['styles'] is Iterable ? List.from(data['styles']) : null,
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       if (name != null) "name": name,
//       if (type != null) "type": type,
//       if (size != null) "size": size,
//       if (photoURL != null) "photoURL": photoURL,
//       if (created != null) "created": created,
//       if (styles != null) "styles": styles,
//     };
//   }
//
//
//   factory Clothes.fromJson(Map<dynamic, dynamic> json) => Clothes(
//     name: data['name'] as String,
//     type: data['type'],
//     size: data['size'],
//     photoURL: data['photoURL'],
//     created: data['created'],
//     styles: data['styles'] is Iterable ? List.from(data['styles']) : null,
//     text: json['text'] as String,
//     date: DateTime.parse(json['date'] as String),
//     email: json['email'] as String?,
//   );
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//     'date': date.toString(),
//     'text': text,
//     'email': email,
//   };
//
//   factory Message.fromSnapshot(DocumentSnapshot snapshot) {
//     final message = Message.fromJson(snapshot.data() as Map<String, dynamic>);
//     message.reference = snapshot.reference;
//     return message;
//   }
//
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class Clothes {
  final String? name;
  final String? type;
  final String? size;
  final String? photoURL;
  final List<String>? styles;
  final DateTime? created;
  DocumentReference? reference;

  Clothes({
    required this.name,
    required this.type,
    required this.size,
    required this.photoURL,
    this.styles,
    this.created,
    this.reference,
  });

  factory Clothes.fromJson(Map<dynamic, dynamic> json) => Clothes(
        name: json['name'] as String,
        type: json['type'] as String,
        size: json['size'] as String,
        photoURL: json['photoURL'] as String,
        created: json['created'] as DateTime?,
        styles: json['styles'] is Iterable
            ? List.from(json['styles']) as List<String>?
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "name": name,
        "type": type,
        "size": size,
        "photoURL": photoURL,
        "created": created.toString(),
        "styles": styles,
      };

  factory Clothes.fromSnapshot(DocumentSnapshot snapshot) {
    final clothes = Clothes.fromJson(snapshot.data() as Map<String, dynamic>);
    clothes.reference = snapshot.reference;
    return clothes;
  }
}
