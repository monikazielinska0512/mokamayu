import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/colors.dart';
import '../../widgets/buttons/floating_button.dart';
import '../../widgets/fundamental/fundamentals.dart';
import '../outfits/create_outfit_dialog.dart';
import 'create_calendar_dialog.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
        type: "",
        leftButtonType: "dots",
        isRightButtonVisible: true,
        context: context,
        isFullScreen: true,
        body: buildBody());
  }

  Widget buildBody() {
    return Stack(children: [
      Column(children: [
        const Padding(
          padding: EdgeInsets.only(top: 80),
        ),
        TableCalendar(
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
        ),
      ]),
      buildFloatingButton()
    ]);
  }

  Widget buildFloatingButton() {
    return CustomCalendarDialog(
        selectedDay: DateFormat.MMMMd().format(_selectedDay));
  }
}
