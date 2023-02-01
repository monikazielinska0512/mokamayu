import 'outfit.dart';

class Event {
  Outfit outfit;
  Event({
    required this.outfit,
  });

  Event.init() : outfit = Outfit.init();

  Map<String, dynamic> toJson() {
    return {
      'outfit': outfit,
    };
  }

  Event.fromJson(Map<String, dynamic> json) : outfit = json['outfit'];
}
