import 'package:cloud_firestore/cloud_firestore.dart';

class WardrobeItem {
  final String name;
  final String type;
  final String size;
  final String photoURL;
  final List<String> styles;
  final DateTime created;
  String? reference;

  WardrobeItem({
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
          name: item['name'] as String,
          type: item['type'] as String,
          size: item['size'] as String,
          photoURL: item['photoURL'] as String,
          styles: List.from(item['styles']),
          created: DateTime.parse(item['created'] as String));

  Map<String, dynamic> toFirestore() => <String, dynamic>{
        'name': name.toString(),
        'type': type.toString(),
        'size': size.toString(),
        'photoURL': photoURL.toString(),
        'styles': styles,
        'created': created.toString(),
      };

  factory WardrobeItem.fromSnapshot(DocumentSnapshot snapshot) {
    final item =
        WardrobeItem.fromFirestore(snapshot.data() as Map<String, dynamic>);
    item.reference = snapshot.reference.id;
    return item;
  }
}
