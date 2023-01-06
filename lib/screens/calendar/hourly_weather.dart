import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/weather_data.dart';
import '../../services/managers/weather_manager.dart';

class HourlyWeather extends StatelessWidget {
  HourlyWeather({super.key});
  List<String> days = [];
  List<String> times = [];
  List<double> temps = [];
  List<String> icons = [];

  @override
  Widget build(BuildContext context) {
    days = Provider.of<WeatherManager>(context, listen: true).getDays;
    times = Provider.of<WeatherManager>(context, listen: true).getTime;
    temps = Provider.of<WeatherManager>(context, listen: true).getTemps;
    icons = Provider.of<WeatherManager>(context, listen: true).getIcons;

    return HourlyWeatherRow(
        days: days, times: times, temps: temps, icons: icons);
  }
}

class HourlyWeatherRow extends StatelessWidget {
  HourlyWeatherRow(
      {Key? key,
      required this.days,
      required this.times,
      required this.temps,
      required this.icons})
      : super(key: key);
  final List<String> days;
  final List<String> times;
  final List<double> temps;
  final List<String> icons;
  List<WeatherData> weatherDataItems = [];

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < days.length; i++) {
      WeatherData data = WeatherData(
          day: days[i], time: times[i], temp: temps[i], iconUrl: icons[i]);
      weatherDataItems.add(data);
    }
    return Row(children: <Widget>[
      Expanded(
          child: SizedBox(
              height: 100.0,
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
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
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
            SizedBox(
              height: 5,
            ),
            Text('${data.iconUrl}', style: TextStyle(fontSize: 25)),
            Text(
              '$temp°',
              style: textTheme.bodyText1!.copyWith(fontWeight: fontWeight),
            ),
          ],
        ));
  }
}
