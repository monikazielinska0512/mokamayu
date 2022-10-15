class Clothes {
  String name;
  String size;
  String type;
  List<String>? styles;
  DateTime? created;

  Clothes(
      {required this.name,
      required this.type,
      required this.size,
      this.styles,
      this.created});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'size': size,
      'styles': styles,
      'created': DateTime.now()
    };
  }
}
