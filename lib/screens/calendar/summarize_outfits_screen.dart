import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/calendar_event.dart';
import '../../models/outfit.dart';
import '../../services/managers/app_state_manager.dart';
import '../../services/managers/calendar_manager.dart';
import '../../widgets/fundamental/basic_page.dart';
import '../../widgets/fundamental/snackbar.dart';
import '../../widgets/photo/wardrobe_item_card.dart';

class SummarizeOutfitsScreen extends StatelessWidget {
  const SummarizeOutfitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
        type: S.of(context).summary,
        leftButtonType: "back",
        isRightButtonVisible: true,
        rightButtonType: "add",
        onPressed: () {
          DateTime day =
              Provider.of<CalendarManager>(context, listen: false).getDay;
          Map<DateTime, List<Event>> events =
              Provider.of<CalendarManager>(context, listen: false).getEvents;
          List<Outfit?> outfitList =
              Provider.of<CalendarManager>(context, listen: false)
                  .getPickedOutfits;

          if (outfitList.length > 0) {
            if (events[day] != null) {
              for (var element in outfitList) {
                events[day]!.add(
                  Event(outfit: element!),
                );
              }
            } else {
              events[day] = [Event(outfit: outfitList[0]!)];
              if (outfitList.length > 1) {
                for (var i = 1; i < outfitList.length; i++) {
                  events[day]!.add(
                    Event(outfit: outfitList[i]!),
                  );
                }
              }
            }
            Provider.of<CalendarManager>(context, listen: false)
                .setSelectedEvents(events);
            Map<String, String> encodedEvents = encodeMap(events);

            Provider.of<AppStateManager>(context, listen: false)
                .cacheEvents(encodedEvents);
            Provider.of<CalendarManager>(context, listen: false)
                .nullOutfitsMap();
            Provider.of<CalendarManager>(context, listen: false)
                .nullPickedOutfits();
            context.go("/home/3");
          } else {
            //no outfits picked
            CustomSnackBar.showErrorSnackBar(
                message: S.of(context).pick_outfits_error, context: context);
          }
        },
        context: context,
        isFullScreen: false,
        body: buildBody(context));
  }

  Map<String, String> encodeMap(Map<DateTime, List<Event>> map) {
    Map<String, String> newMap = {};
    List<String> eventList = [];
    map.forEach((key, value) {
      value.forEach((element) {
        eventList.add(json.encode(element));
      });
      newMap[key.toString()] = json.encode(eventList);
      eventList = [];
    });
    return newMap;
  }

  List<Widget> _buildListWidget(
      BuildContext context, List<Outfit?> outfitList) {
    List<Widget> widgetOutfitList = [];
    for (var element in outfitList) {
      widgetOutfitList.add(WardrobeItemCard(outfit: element, size: 50));
    }

    return widgetOutfitList;
  }

  Widget buildBody(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ListView(padding: const EdgeInsets.all(10), children: [
        ..._buildListWidget(
            context,
            Provider.of<CalendarManager>(context, listen: true)
                .getPickedOutfits),
      ]))
    ]);
  }
}
