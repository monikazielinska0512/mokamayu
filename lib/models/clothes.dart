import 'package:cloud_firestore/cloud_firestore.dart';

class Clothes {
  final String? id;
  final String name;
  final String type;
  final String size;
  final List<String>? styles;

  Clothes(
      {this.id,
        required this.name,
        required this.type,
        required this.size,
        this.styles});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'size': size,
      'styles': styles
    };
  }

  Clothes.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
        type = doc.data()!["type"],
        size = doc.data()!["size"],
        styles = doc.data()?["styles"] == null ? null : doc.data()?["styles"].cast<String>();
}