import 'package:cloud_firestore/cloud_firestore.dart';

class Outfit {
  final String owner;
  final String createdBy;
  final List<String> styles;
  final String season;
  final String cover;
  final List<String>? elements;
  final Map<String, String>? map;
  String? reference;

  Outfit({
    required this.owner,
    required this.createdBy,
    required this.styles,
    required this.season,
    required this.cover,
    this.elements,
    this.map,
    this.reference,
  });

  Outfit.init()
      : owner = '',
        createdBy = '',
        styles = [],
        season = '',
        cover = '',
        elements = [],
        map = {};

  factory Outfit.fromJson(Map<dynamic, dynamic> json) => Outfit(
      owner: json['owner'] ?? json['createdBy'] as String,
      createdBy: json['createdBy'] as String,
      styles: List.from(json['styles']),
      season: json['season'] as String,
      cover: json['cover'] as String,
      map: Map.from(json['map']),
      elements: List.from(json['elements']),
      reference: json['reference']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "owner": owner.toString(),
        "createdBy": createdBy.toString(),
        'styles': styles,
        "season": season.toString(),
        "cover": cover.toString(),
        "elements": elements,
        "map": map,
        "reference": reference,
      };

  factory Outfit.fromSnapshot(DocumentSnapshot snapshot) {
    final item = Outfit.fromJson(snapshot.data() as Map<String, dynamic>);
    item.reference = snapshot.reference.id;
    return item;
  }
}
