import 'outfit.dart';

class Event {
  Outfit outfit;
  String? name;
  Event({required this.outfit, this.name});

  Event.init()
      : outfit = Outfit.init(),
        name = "";

  Map<String, dynamic> toJson() {
    return {'outfit': outfit, 'name': name};
  }

  Event.fromJson(Map<String, dynamic> json)
      : outfit = json['outfit'],
        name = json['name'];
}
