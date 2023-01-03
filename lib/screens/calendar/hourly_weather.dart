import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokamayu/models/wardrobe_item.dart';
import 'package:provider/provider.dart';

import '../../models/weather_data.dart';
import '../../services/managers/weather_manager.dart';

class HourlyWeather extends StatelessWidget {
  HourlyWeather({super.key});
  List<String> days = [];
  List<String> times = [];
  List<double> temps = [];

  @override
  Widget build(BuildContext context) {
    // final items = [0, 8, 16, 24, 32];
    days = Provider.of<WeatherManager>(context, listen: true).getDays;
    times = Provider.of<WeatherManager>(context, listen: true).getTime;
    temps = Provider.of<WeatherManager>(context, listen: true).getTemps;

    return HourlyWeatherRow(days: days, times: times, temps: temps);
  }
}

class HourlyWeatherRow extends StatelessWidget {
  HourlyWeatherRow(
      {Key? key, required this.days, required this.times, required this.temps})
      : super(key: key);
  final List<String> days;
  final List<String> times;
  final List<double> temps;
  List<WeatherData> weatherDataItems = [];

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < days.length; i++) {
      WeatherData data =
          WeatherData(day: days[i], time: times[i], temp: temps[i]);
      weatherDataItems.add(data);
    }
    return Row(children: <Widget>[
      Expanded(
          child: SizedBox(
              height: 55.0,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  ...weatherDataItems
                      .map((WeatherData data) => HourlyWeatherItem(data: data))
                      .toList(),
                ],
              )))
    ]);
  }
}

class HourlyWeatherItem extends StatelessWidget {
  const HourlyWeatherItem({Key? key, required this.data}) : super(key: key);
  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const fontWeight = FontWeight.normal;
    final temp = data.temp;
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            Text(
              data.day,
              style: textTheme.caption!.copyWith(fontWeight: fontWeight),
            ),
            Text(
              data.time,
              style: textTheme.caption!.copyWith(fontWeight: fontWeight),
            ),
            // const SizedBox(height: 8),
            // WeatherIconImage(iconUrl: data.iconUrl, size: 48),
            // const SizedBox(height: 8),
            Text(
              '$temp°',
              style: textTheme.bodyText1!.copyWith(fontWeight: fontWeight),
            ),
          ],
        ));
  }
}
