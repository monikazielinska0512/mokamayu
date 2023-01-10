import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/text_styles.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:mokamayu/services/api/weather.dart';
import 'package:mokamayu/services/managers/calendar_manager.dart';
import 'package:mokamayu/services/managers/weather_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/colors.dart';
import '../../models/calendar_event.dart';
import '../../services/authentication/auth.dart';
import '../../services/managers/outfit_manager.dart';
import '../../widgets/buttons/floating_button.dart';
import '../../widgets/buttons/icon_text_button.dart';
import '../../widgets/fundamental/fundamentals.dart';
import '../../widgets/photo/wardrobe_item_card.dart';
import 'hourly_weather.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Event>> selectedEvents = {};
  List<Outfit>? outfitList;
  final AuthService _auth = AuthService();
  final TextEditingController _cityTextController = TextEditingController();
  WeatherModel weatherModel = WeatherModel();
  int? temperature;
  String? currentWeatherIcon;
  bool showCurrentWeather = false;

  prefsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      outfitList =
          Provider.of<OutfitManager>(context, listen: false).getFinalOutfitList;
    }
    setState(() {
      String? encodedMap = prefs.getString(_auth.getCurrentUserID());
      // print(encodedMap);
      Map<String, dynamic> getEvents = json.decode(encodedMap ?? "{}");
      List<Event> list = [];
      getEvents.forEach((key, value) {
        var val = (json.decode(value) as List).map((e) => e as String).toList();
        for (var element in val) {
          Map<String, dynamic> map = jsonDecode(element);
          Map<String, dynamic> mapOutfit = map['outfit'];

          Outfit outfit = Outfit(
              createdBy: mapOutfit['createdBy'] as String,
              style: mapOutfit['style'] as String,
              season: mapOutfit['season'] as String,
              cover: mapOutfit['cover'] as String,
              map: Map.from(mapOutfit['map']),
              elements: List.from(mapOutfit['elements']),
              reference: mapOutfit['reference']);

          Outfit finalOutfit = Outfit.init();
          for (var element in outfitList!) {
            if (element.reference == outfit.reference) {
              finalOutfit = element;
            }
          }

          final event = Event(outfit: finalOutfit);
          list.add(event);
        }
        selectedEvents[DateTime.parse(key)] = list;
        list = [];
      });
    });
  }

  void updateUI() async {
    var weatherData = await weatherModel.getWeatherByLocation();

    setState(() {
      var condition = weatherData['weather'][0]['id'];
      currentWeatherIcon = weatherModel.getWeatherIcon(condition);
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
    });
  }

  @override
  void initState() {
    super.initState();
    selectedEvents = {};
    // updateUI();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () => prefsData());
    });
  }

  List<Event> _getEventsfromDay(DateTime day) {
    return selectedEvents[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    selectedEvents =
        Provider.of<CalendarManager>(context, listen: true).getEvents;
    return BasicScreen(
        type: "Calendar",
        leftButtonType: "dots",
        isRightButtonVisible: true,
        backgroundColor: Colors.transparent,
        context: context,
        isFullScreen: true,
        body: buildCalendar());
  }

  Widget buildCalendar() {
    return Stack(children: [
      Column(children: [
        const Padding(
          padding: EdgeInsets.only(top: 75),
        ),
        TableCalendar<Event>(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsfromDay,
            calendarStyle: const CalendarStyle(
              markersAlignment: Alignment.bottomRight,
              selectedDecoration: BoxDecoration(
                color: ColorsConstants.peachy,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: ColorsConstants.darkPeach,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) => events.isNotEmpty
                  ? Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: ColorsConstants.darkBrick,
                      ),
                      child: Text(
                        '${events.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  : null,
            )),
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 20, right: 70),
              child: TextField(
                  controller: _cityTextController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        if (_cityTextController != null) {
                          Provider.of<WeatherManager>(context, listen: false)
                              .resetLists();
                          var weatherData = await weatherModel
                              .getCityWeather(_cityTextController.text);
                          double longtitude = weatherData['coord']['lon'];
                          double lattitude = weatherData['coord']['lat'];
                          var forecastCoordsData = await weatherModel
                              .getForecastByCoords(longtitude, lattitude);
                          for (var i = 0;
                              i < forecastCoordsData['list'].length;
                              i++) {
                            var day = DateFormat('EEE').format(DateTime.parse(
                                forecastCoordsData['list'][i]['dt_txt']));
                            Provider.of<WeatherManager>(context, listen: false)
                                .addDay(day);
                            var hour = DateFormat.Hm().format(DateTime.parse(
                                forecastCoordsData['list'][i]['dt_txt']));
                            Provider.of<WeatherManager>(context, listen: false)
                                .addTime(hour);
                            var iconUrl = weatherModel.getWeatherIcon(
                                forecastCoordsData['list'][i]['weather'][0]
                                    ['id']);
                            Provider.of<WeatherManager>(context, listen: false)
                                .addIcon(iconUrl);
                            Provider.of<WeatherManager>(context, listen: false)
                                .addTemp(forecastCoordsData['list'][i]['main']
                                        ['temp']
                                    .toDouble());
                          }
                        }
                      },
                    ),
                    labelText: 'Enter City',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  )),
            )),
            showCurrentWeather
                ? Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Text(
                          "Current weather",
                          style: TextStyles.paragraphRegular14(),
                        ),
                        const SizedBox(height: 5),
                        Row(children: [
                          Text('$temperature°  ',
                              style: const TextStyle(fontSize: 18)),
                          Text('$currentWeatherIcon',
                              style: const TextStyle(fontSize: 25)),
                        ])
                      ],
                    ))
                : Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: IconTextButton(
                      onPressed: () {
                        updateUI();
                        showCurrentWeather = true;
                      },
                      icon: Icons.sunny,
                      text: "Show current weather",
                      width: 130,
                      height: 60,
                      backgroundColor: ColorsConstants.mint,
                    ),
                  ),
          ],
        ),
        HourlyWeather(),
        Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, bottom: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Looks for ${DateFormat.MMMMd().format(_selectedDay)}:",
                  style: TextStyles.h5(ColorsConstants.grey),
                ))),
        SizedBox(
            height: 140,
            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    ..._getEventsfromDay(_selectedDay)
                        .map((Event event) => WardrobeItemCard(
                            size: 58, outfit: event.outfit, event: event))
                        .toList(),
                  ],
                )))
      ]),
      buildFloatingButton()
    ]);
  }

  Widget buildFloatingButton() {
    return FloatingButton(
        onPressed: () {
          _showModal(context);
        },
        icon: const Icon(Icons.add),
        backgroundColor: ColorsConstants.mint,
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
        alignment: Alignment.bottomRight);
  }

  void _showModal(
    context,
  ) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          GestureDetector(
              onTap: () => context.pop(),
              child: Stack(children: const [
                BackgroundImage(
                    imagePath: "assets/images/full_background.png",
                    imageShift: 0,
                    opacity: 0.3),
              ])),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            height: MediaQuery.of(context).size.height * 0.30,
            child: Center(
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0, left: 0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Ionicons.close_outline,
                              size: 25,
                              color: Colors.grey,
                            )),
                      )),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 20, left: 0),
                            child: Column(
                              children: [
                                dialogCardCalendar(
                                    "Add looks for ${DateFormat.MMMMd().format(_selectedDay)}",
                                    () {
                                  Provider.of<CalendarManager>(context,
                                          listen: false)
                                      .setSelectedEvents(selectedEvents);
                                  Provider.of<CalendarManager>(context,
                                          listen: false)
                                      .setSelectedDay(_selectedDay);

                                  context.push('/pick-outfits-calendar');

                                  Navigator.of(context).pop();
                                }, MediaQuery.of(context).size.width * 0.04)
                              ],
                            )),
                      ])
                ],
              ),
            ),
          )
        ]);
      },
    );
  }
}

Widget dialogCardCalendar(String text, Function onTap, double pad) {
  return SizedBox(
    width: 280,
    height: 65,
    child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          shadowColor: Colors.transparent,
          backgroundColor: ColorsConstants.whiteAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 13),
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )))
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: pad),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.grey,
                )),
          ],
        )),
  );
}
