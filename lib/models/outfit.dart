import 'package:cloud_firestore/cloud_firestore.dart';

class Outfit {
  final String? createdBy;
  final String? style;
  final String? season;
  final String? cover;
  final List<String>? elements;
  final DateTime? created;
  String? reference;

  Outfit({
    this.createdBy,
    this.style,
    this.season,
    this.cover,
    this.elements,
    this.created,
    this.reference,
  });

  factory Outfit.fromJson(Map<dynamic, dynamic> json) => Outfit(
        createdBy: json['created_by'] as String,
        style: json['style'] as String,
        season: json['season'] as String,
        cover: json['cover'] as String,
        created: json['created'] as DateTime?,
        elements: json['elements'] is Iterable
            ? List.from(json['elements']) as List<String>?
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "createdBy": createdBy,
        "style": style,
        "season": season,
        "cover": cover,
        "created": created.toString(),
        "elements": elements,
      };

  factory Outfit.fromSnapshot(DocumentSnapshot snapshot) {
    final item = Outfit.fromJson(snapshot.data() as Map<String, dynamic>);
    item.reference = snapshot.reference.id;
    return item;
  }
}
