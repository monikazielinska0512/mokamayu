import 'package:cloud_firestore/cloud_firestore.dart';

class Clothes {
  final String name;
  final String type;
  final String size;
  final String photoURL;
  final List<String>? styles;
  final DateTime? created;


  Clothes({
    required this.name,
    required this.type,
    required this.size,
    required this.photoURL,
    this.styles,
    this.created,
  });


  factory Clothes.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Clothes(
      name: data?['name'],
      type: data?['type'],
      size: data?['size'],
      photoURL: data?['photoURL'],
      created: data?['created'],
      styles: data?['styles'] is Iterable ? List.from(data?['styles']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (type != null) "type": type,
      if (size != null) "size": size,
      if (photoURL != null) "photoURL": photoURL,
      if (created != null) "created": created,
      if (styles != null) "styles": styles,
    };
  }

  String get getName {
    return name;
  }

  String get getType {
    return type;
  }
  String get getSize {
    return size;
  }
  String get URL {
    return photoURL;
  }
  List<String>? get getStyles {
    return styles;
  }
}
