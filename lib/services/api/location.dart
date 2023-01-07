import 'package:geolocator/geolocator.dart';

class Location {
  late double latitude;
  late double longitide;
  String apiKey = '9e00a812e596fc76f86b4b2c0bb3faf8';
  late int status;

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return Future.error('Location Not Available');
        }
      } else {
        throw Exception('Error');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      longitide = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}
