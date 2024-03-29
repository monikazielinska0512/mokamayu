import 'package:mokamayu/services/api/location.dart';
import 'package:mokamayu/services/api/network_data.dart';

import '../../constants/constants.dart';

const weatherApiUrl = 'https://api.openweathermap.org/data/2.5/weather';
const forecastApiUrl = 'http://api.openweathermap.org/data/2.5/forecast';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    var url = '$weatherApiUrl?q=$cityName&appid=$apiKey&units=metric';
    NetworkData networkHelper = NetworkData(url);
    var weatherData = networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getWeatherByLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkData networkHelper = NetworkData(
        '$weatherApiUrl?lat=${location.latitude}&lon=${location.longitide}&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getForecastByCoords(
      double longtitude, double lattitude) async {
    NetworkData networkHelper = NetworkData(
        '$forecastApiUrl?lat=$lattitude&lon=$longtitude&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }
}
