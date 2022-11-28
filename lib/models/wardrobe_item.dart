import 'package:cloud_firestore/cloud_firestore.dart';

class WardrobeItem {
  final String? name;
  final String? type;
  final String? size;
  final String? photoURL;
  final List<String>? styles;
  final DateTime? created;
  String? reference;

  WardrobeItem({
    required this.name,
    required this.type,
    required this.size,
    required this.photoURL,
    this.styles,
    this.created,
    this.reference,
  });

  factory WardrobeItem.fromJson(Map<dynamic, dynamic> json) => WardrobeItem(
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

  factory WardrobeItem.fromSnapshot(DocumentSnapshot snapshot) {
    final item = WardrobeItem.fromJson(snapshot.data() as Map<String, dynamic>);
    item.reference = snapshot.reference.id;
    return item;
  }
}
