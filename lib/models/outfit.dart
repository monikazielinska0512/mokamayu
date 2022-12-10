import 'dart:typed_data';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/drag_target_container.dart';

class Outfit {
  final String createdBy;
  final String? style;
  final String? season;
  final String cover;
  final List<String>? elements;
  final String? map;
  String? reference;

  Outfit({
    required this.createdBy,
    this.style,
    this.season,
    required this.cover,
    this.elements,
    this.map,
    this.reference,
  });

  factory Outfit.fromFirestore(Map<dynamic, dynamic> json) => Outfit(
      createdBy: json['createdBy'] as String,
      style: json['style'] as String,
      season: json['season'] as String,
      cover: json['cover'] as String,
      map: json['map'] as String,
      elements: List.from(json['elements']));

  Map<String, dynamic> toFirestore() => <String, dynamic>{
        "createdBy": createdBy.toString(),
        "style": style.toString(),
        "season": season.toString(),
        "cover": cover.toString(),
        "elements": elements,
        "map": map.toString()
      };

  factory Outfit.fromSnapshot(DocumentSnapshot snapshot) {
    final item = Outfit.fromFirestore(snapshot.data() as Map<String, dynamic>);
    item.reference = snapshot.reference.id;
    return item;
  }
}
