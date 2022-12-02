import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Outfit {
  final String? createdBy;
  final String? style;
  final String? season;
  final Uint8List? cover;
  final List<String>? elements;
  String? reference;

  Outfit({
    this.createdBy,
    this.style,
    this.season,
    this.cover,
    this.elements,
    this.reference,
  });

  factory Outfit.fromJson(Map<dynamic, dynamic> json) => Outfit(
      createdBy: json['createdBy'] as String,
      style: json['style'] as String,
      season: json['season'] as String,
      cover: json['cover'] as Uint8List,
      elements: List.from(json['elements']));

  Map<String, dynamic> toJson() => <String, dynamic>{
        "createdBy": createdBy.toString(),
        "style": style.toString(),
        "season": season.toString(),
        "cover": cover.toString(),
        "elements": elements.toString(),
      };

  factory Outfit.fromSnapshot(DocumentSnapshot snapshot) {
    final item = Outfit.fromJson(snapshot.data() as Map<String, dynamic>);
    item.reference = snapshot.reference.id;
    return item;
  }
}
