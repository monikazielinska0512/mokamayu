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
import 'package:mokamayu/widgets/fields/search_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mokamayu/widgets/widgets.dart';
import '../../constants/colors.dart';
import '../../generated/l10n.dart';
import '../../models/calendar_event.dart';
import '../../services/authentication/auth.dart';
import '../../services/managers/outfit_manager.dart';
import '../../widgets/buttons/predefined_buttons.dart';
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
  bool showHourlyWeather = false;

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
              owner: mapOutfit['owner'] as String,
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
        title: S.of(context).calendar,
        leftButton: DotsButton(context),
        rightButton: NotificationsButton(context),
        backgroundColor: Colors.transparent,
        context: context,
        isFullScreen: false,
        body: Stack(children: [
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            buildWeather(),
            SingleChildScrollView(
                child:
                    Column(children: [buildCalendar(), buildPlannedOutfits()]))
          ]),
          buildFloatingButton()
        ]));
  }

  Widget buildWeather() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _cityTextController,
              decoration: SearchBarStyle(
                "Enter city",
                icon: null,
                suffixIcon: IconButton(
                  icon: const Icon(Ionicons.search_outline,
                      color: ColorsConstants.darkBrick),
                  onPressed: () async {
                    showHourlyWeather = true;
                    updateUI();
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
                          forecastCoordsData['list'][i]['weather'][0]['id']);
                      Provider.of<WeatherManager>(context, listen: false)
                          .addIcon(iconUrl);
                      Provider.of<WeatherManager>(context, listen: false)
                          .addTemp(forecastCoordsData['list'][i]['main']['temp']
                              .toDouble());
                    }
                  },
                ),
              ),
            ),
          ),
          showCurrentWeather
              ? Padding(
                  padding: const EdgeInsets.only(left: 15, right: 5),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorsConstants.sunflower.withOpacity(0.1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).current_weather,
                            style: TextStyles.paragraphRegular14(),
                          ),
                          // const SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('$currentWeatherIcon',
                                    style: TextStyles
                                        .paragraphRegularSemiBold20()),
                                const SizedBox(width: 5),
                                Text('$temperature°  ',
                                    style: TextStyles
                                        .paragraphRegularSemiBold18()),
                              ])
                        ],
                      )))
              : Padding(
                  padding: const EdgeInsets.only(left: 15, right: 5),
                  child: IconTextButton(
                    onPressed: () {
                      updateUI();
                      showCurrentWeather = true;
                    },
                    icon: Ionicons.sunny_outline,
                    text: S.of(context).show_current_weather,
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.08,
                    backgroundColor: ColorsConstants.mint.withOpacity(0.6),
                  ),
                ),
        ],
      ),
      showHourlyWeather == true
          ? Padding(padding: const EdgeInsets.all(10), child: HourlyWeather())
          : Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(width: 0)),
    ]);
  }

  Widget buildCalendar() {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorsConstants.darkBrick.withOpacity(0.2)),
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorsConstants.white),
            child: TableCalendar<Event>(
                availableCalendarFormats: const {
                  CalendarFormat.twoWeeks: '2 weeks',
                  CalendarFormat.week: 'Week'
                },
                headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    formatButtonPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    formatButtonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorsConstants.sunflower.withOpacity(0.2)),
                    formatButtonTextStyle:
                        TextStyles.paragraphRegularSemiBold14(
                            ColorsConstants.sunflower),
                    leftChevronIcon:
                        const Icon(Ionicons.chevron_back, color: Colors.black),
                    leftChevronPadding: const EdgeInsets.all(0),
                    rightChevronIcon: const Icon(Ionicons.chevron_forward,
                        color: Colors.black),
                    rightChevronPadding: const EdgeInsets.only(left: 10),
                    rightChevronMargin: const EdgeInsets.all(0),
                    leftChevronMargin: const EdgeInsets.all(0),
                    titleTextStyle: TextStyles.paragraphRegularSemiBold16(),
                    headerPadding: const EdgeInsets.all(5)),
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyles.paragraphRegularSemiBold12(
                        ColorsConstants.darkBrick),
                    weekendStyle: TextStyles.paragraphRegularSemiBold12(
                        ColorsConstants.darkBrick)),
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
                calendarStyle: CalendarStyle(
                  cellMargin: const EdgeInsets.all(5),
                  todayTextStyle: TextStyles.paragraphRegular12(Colors.white),
                  defaultTextStyle: TextStyles.paragraphRegular12(),
                  weekendTextStyle: TextStyles.paragraphRegularSemiBold12(),
                  selectedTextStyle:
                      TextStyles.paragraphRegularSemiBold12(Colors.white),
                  markersAlignment: Alignment.bottomRight,
                  selectedDecoration: const BoxDecoration(
                    color: ColorsConstants.peachy,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: const BoxDecoration(
                    color: ColorsConstants.darkPeach,
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) => events.isNotEmpty
                      ? Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ColorsConstants.darkBrick,
                          ),
                          child: Text(
                            '${events.length}',
                            style: TextStyles.paragraphRegularSemiBold12(
                                ColorsConstants.white),
                          ),
                        )
                      : null,
                ))));
  }

  Widget buildPlannedOutfits() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(top: 10, left: 5, bottom: 10),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "${S.of(context).looks_for} ${DateFormat.MMMMd().format(_selectedDay)}:",
                style:
                    TextStyles.paragraphRegularSemiBold16(ColorsConstants.grey),
              ))),
      SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 15),
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  ..._getEventsfromDay(_selectedDay)
                      .map((Event event) => WardrobeItemCard(
                          size: 80, outfit: event.outfit, event: event))
                      .toList(),
                ],
              )))
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
                                    "${S.of(context).add_looks_for} ${DateFormat.MMMMd().format(_selectedDay)}",
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
  return FittedBox(
    fit: BoxFit.fitWidth,
    // width: 280,
    // height: 65,
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
                          padding: const EdgeInsets.only(top: 13, bottom: 15),
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
