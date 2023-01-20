import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../models/models.dart';
import '../../services/services.dart';

class SummarizeOutfitsScreen extends StatelessWidget {
  const SummarizeOutfitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
        title: S.of(context).summary,
        leftButton: BackArrowButton(context),
        rightButton: AddButton(context, () {
          DateTime day =
              Provider.of<CalendarManager>(context, listen: false).getDay;
          Map<DateTime, List<Event>> events =
              Provider.of<CalendarManager>(context, listen: false).getEvents;
          List<Outfit?> outfitList =
              Provider.of<CalendarManager>(context, listen: false)
                  .getPickedOutfits;

          if (outfitList.isNotEmpty) {
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
        }),
        context: context,
        isFullScreen: false,
        body: buildBody(context));
  }

  Map<String, String> encodeMap(Map<DateTime, List<Event>> map) {
    Map<String, String> newMap = {};
    List<String> eventList = [];
    map.forEach((key, value) {
      for (var element in value) {
        eventList.add(json.encode(element));
      }
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
