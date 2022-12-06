import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Outfit {
  final String createdBy;
  final String? style;
  final String? season;
  final String cover;
  final List<String>? elements;
  String? reference;

  Outfit({
    required this.createdBy,
    this.style,
    this.season,
    required this.cover,
    this.elements,
    this.reference,
  });

  factory Outfit.fromFirestore(Map<dynamic, dynamic> json) => Outfit(
      createdBy: json['createdBy'] as String,
      style: json['style'] as String,
      season: json['season'] as String,
      cover: json['cover'] as String,
      elements: List.from(json['elements']));

  Map<String, dynamic> toFirestore() => <String, dynamic>{
        "createdBy": createdBy.toString(),
        "style": style.toString(),
        "season": season.toString(),
        "cover": cover.toString(),
        "elements": elements,
      };

  factory Outfit.fromSnapshot(DocumentSnapshot snapshot) {
    final item = Outfit.fromFirestore(snapshot.data() as Map<String, dynamic>);
    item.reference = snapshot.reference.id;
    return item;
  }
}
