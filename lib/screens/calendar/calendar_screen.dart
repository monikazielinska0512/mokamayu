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
  FocusNode myFocusNode = FocusNode();

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
    myFocusNode = FocusNode();
    selectedEvents = {};
    // updateUI();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () => prefsData());
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
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
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [buildWeather(), buildProfileGallery(context)]),
          buildFloatingButton()
        ]));
  }

  Widget buildWeather() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              focusNode: myFocusNode,
              controller: _cityTextController,
              decoration: SearchBarStyle(
                "Enter city",
                icon: null,
                suffixIcon: IconButton(
                  icon: const Icon(Ionicons.search_outline,
                      color: ColorsConstants.darkBrick),
                  onPressed: () async {
                    showHourlyWeather = true;
                    myFocusNode.unfocus();
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
          buildCurrentWeatherWidget()
        ],
      ),
      showHourlyWeather == true
          ? HourlyWeather()
          : Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(width: 0)),
    ]);
  }

  Widget buildCurrentWeatherWidget() {
    return showCurrentWeather
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
                              style: TextStyles.paragraphRegularSemiBold20()),
                          const SizedBox(width: 5),
                          Text('$temperature°  ',
                              style: TextStyles.paragraphRegularSemiBold18()),
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
          );
  }

  Map<String, Widget>? getTabs() =>
      {"Calendar": buildCalendar(), "Planned outfits": buildPlannedOutfits()};

  Widget buildProfileGallery(BuildContext context) {
    List<Tab>? tabs = getTabs()
        ?.keys
        .map((label) => Tab(
            child: Text(label,
                style: TextStyles.paragraphRegularSemiBold14(),
                textAlign: TextAlign.center)))
        .toList();
    return tabs == null
        ? Container()
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
              child: DefaultTabController(
                length: tabs.length,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TabBar(
                      padding: const EdgeInsets.only(top: 0, bottom: 5),
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorsConstants.peachy.withOpacity(0.3)),
                      indicatorColor: ColorsConstants.darkBrick,
                      labelStyle: TextStyles.paragraphRegular16(),
                      labelColor: ColorsConstants.darkBrick,
                      unselectedLabelColor: ColorsConstants.grey,
                      tabs: tabs,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: getTabs()!
                            .values
                            .map((widget) => Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: widget))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
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
            child: SingleChildScrollView(
                child: TableCalendar<Event>(
                    calendarFormat: _calendarFormat,
                    headerStyle: HeaderStyle(
                        titleCentered: true,
                        formatButtonShowsNext: false,
                        formatButtonPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        formatButtonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorsConstants.sunflower.withOpacity(0.2)),
                        formatButtonTextStyle:
                            TextStyles.paragraphRegularSemiBold14(
                                ColorsConstants.sunflower),
                        leftChevronIcon: const Icon(Ionicons.chevron_back,
                            color: Colors.black),
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
                    focusedDay: _selectedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
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
                      todayTextStyle:
                          TextStyles.paragraphRegular12(Colors.white),
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
                    )))));
  }

  Widget buildPlannedOutfits() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(top: 5, left: 5, bottom: 10),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "${S.of(context).looks_for} ${DateFormat.MMMMd().format(_selectedDay)}:",
                style:
                    TextStyles.paragraphRegularSemiBold16(ColorsConstants.grey),
              ))),
      Expanded(
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: _getEventsfromDay(_selectedDay).isNotEmpty
                  ? ListView(shrinkWrap: true, children: [
                      ..._getEventsfromDay(_selectedDay)
                          .map((Event event) => WardrobeItemCard(
                              size: 50, outfit: event.outfit, event: event))
                          .toList(),
                    ])
                  : Container(
                      decoration: BoxDecoration(
                          color: ColorsConstants.sunflower.withOpacity(0.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            const Icon(
                              Ionicons.sad_outline,
                              size: 25,
                              color: Colors.grey,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(30),
                                child: Text(
                                    "Brak zaplanowanych stylizaci na ten dzień",
                                    textAlign: TextAlign.center,
                                    style: TextStyles.paragraphRegular14(
                                        Colors.grey)))
                          ])))))
    ]);
  }

  Widget buildFloatingButton() {
    return FloatingButton(
        onPressed: () {
          _showModal(context);
        },
        icon: const Icon(Icons.add),
        backgroundColor: ColorsConstants.mint,
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 20),
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
            height: MediaQuery.of(context).size.height * 0.25,
            child: Center(
              child: Column(
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 20, left: 0),
                            child: Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Provider.of<CalendarManager>(context,
                                              listen: false)
                                          .setSelectedEvents(selectedEvents);
                                      Provider.of<CalendarManager>(context,
                                              listen: false)
                                          .setSelectedDay(_selectedDay);

                                      context.push('/pick-outfits-calendar');

                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color:
                                                  ColorsConstants.whiteAccent,
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.12,
                                            width: double.maxFinite,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(children: [
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                              child: Icon(
                                                                  Ionicons
                                                                      .radio_button_off_outline,
                                                                  color: ColorsConstants
                                                                      .darkBrick)),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${S.of(context).add_looks_for} ${DateFormat.MMMMd().format(_selectedDay)}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyles
                                                                    .paragraphRegularSemiBold16(),
                                                              ),
                                                            ],
                                                          )
                                                        ]),
                                                        const Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color: Colors.grey),
                                                      ],
                                                    )))))),
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
