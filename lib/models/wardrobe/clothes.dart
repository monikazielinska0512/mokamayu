class Clothes {
  String name;
  String size;
  String type;
  String photoURL;
  List<String>? styles;
  DateTime? created;

  Clothes(
      {required this.name,
      required this.type,
      required this.size,
      required this.photoURL,
      this.styles,
      this.created});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'size': size,
      'styles': styles,
      'photo_url': photoURL,
      'created': DateTime.now()
    };
  }
}
