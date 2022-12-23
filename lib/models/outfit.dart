import 'package:cloud_firestore/cloud_firestore.dart';

class Outfit {
  final String createdBy;
  final String? style;
  final String? season;
  final String cover;
  final List<String>? elements;
  final Map<String, String>? map;
  final int index;
  String? reference;

  Outfit({
    required this.createdBy,
    this.style,
    this.season,
    required this.cover,
    this.elements,
    this.map,
    required this.index,
    this.reference,
  });

  Outfit.init()
      : createdBy = '',
        style = '',
        season = '',
        cover = '',
        elements = [],
        map = {},
        index = 0;

  factory Outfit.fromJson(Map<dynamic, dynamic> json) => Outfit(
      createdBy: json['createdBy'] as String,
      style: json['style'] as String,
      season: json['season'] as String,
      cover: json['cover'] as String,
      map: Map.from(json['map']),
      index: json['index'],
      elements: List.from(json['elements']));

  Map<String, dynamic> toJson() => <String, dynamic>{
        "createdBy": createdBy.toString(),
        "style": style.toString(),
        "season": season.toString(),
        "cover": cover.toString(),
        "elements": elements,
        "map": map,
        "index": index,
      };

  factory Outfit.fromSnapshot(DocumentSnapshot snapshot) {
    final item = Outfit.fromJson(snapshot.data() as Map<String, dynamic>);
    item.reference = snapshot.reference.id;
    return item;
  }
}
