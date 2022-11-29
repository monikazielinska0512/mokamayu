// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class WardrobeItem {
//   final String? name;
//   final String? type;
//   final String? size;
//   final String? photoURL;
//   final List<String>? styles;
//   final DateTime? created;
//   String? reference;
// //
// //   WardrobeItem({
//     required this.name,
//     required this.type,
//     required this.size,
//     required this.photoURL,
//     this.styles,
//     this.created,
//     this.reference,
//   });
// //
// //   factory WardrobeItem.fromJson(Map<dynamic, dynamic> item) => WardrobeItem(
// //         name: item['name'] as String,
// //         type: item['type'] as String,
// //         size: item['size'] as String,
// //         photoURL: item['photoURL'] as String,
// //         created: item['created'] as DateTime?,
// //         styles: item['styles'] is Iterable
// //             ? List.from(item['styles']) as List<String>?
// //             : null,
// //       );
// //
// //   Map<String, dynamic> toJson() => <String, dynamic>{
// //         "name": name,
// //         "type": type,
// //         "size": size,
// //         "photoURL": photoURL,
// //         "created": created.toString(),
// //         "styles": styles,
// //       };
// //
// //   factory WardrobeItem.fromSnapshot(DocumentSnapshot snapshot) {
// //     final item = WardrobeItem.fromJson(snapshot.data() as Map<String, dynamic>);
// //     item.reference = snapshot.reference.id;
// //     return item;
// //   }
// // }

import 'package:cloud_firestore/cloud_firestore.dart';

class WardrobeItem {
  final String id;
  final String name;
  final String type;
  final String size;
  final String photoURL;
  final List<String> styles;
  final DateTime created;
  DocumentReference? reference;

  WardrobeItem({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.photoURL,
    required this.styles,
    required this.created,
    this.reference,
  });

  factory WardrobeItem.fromFirestore(Map<dynamic, dynamic> item) =>
      WardrobeItem(
          id: item['id'] as String,
          name: item['name'] as String,
          type: item['type'] as String,
          size: item['size'] as String,
          photoURL: item['photoURL'] as String,
          styles: item['styles'] as List<String>,
          created: DateTime.parse(item['created'] as String));

  Map<String, dynamic> toFirestore() => <String, dynamic>{
        'id': id.toString(),
        'name': name.toString(),
        'type': type.toString(),
        'size': size.toString(),
        'photoURL': photoURL.toString(),
        'styles': styles.toString(),
        'created': created.toString(),
      };

  factory WardrobeItem.fromSnapshot(DocumentSnapshot snapshot) {
    final item =
        WardrobeItem.fromFirestore(snapshot.data() as Map<String, dynamic>);
    item.reference = snapshot.reference;
    return item;
  }
}
