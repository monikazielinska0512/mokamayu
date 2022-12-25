import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:provider/provider.dart';

import '../../models/calendar_event.dart';
import '../../services/managers/app_state_manager.dart';
import '../../services/managers/calendar_manager.dart';

class WardrobeItemCard extends StatelessWidget {
  WardrobeItemCard(
      {Key? key, this.wardrobItem, this.outfit, required this.size, this.event})
      : super(key: key);
  final WardrobeItem? wardrobItem;
  final Outfit? outfit;
  String? photoUrl = "";
  String? name = "";
  double size = 50;
  Event? event;
  @override
  Widget build(BuildContext context) {
    if (wardrobItem != null) {
      photoUrl = wardrobItem!.photoURL;
      name = wardrobItem!.name;
    }

    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
      color: ColorsConstants.whiteAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: (outfit != null && outfit?.cover == "")
            ? Row(children: [
                const Text("Outfit deleted :("),
                const SizedBox(width: 10),
                GestureDetector(
                    onTap: () {
                      //delete outfit from calendar event
                      Provider.of<CalendarManager>(context, listen: false)
                          .removeEvent(event!);
                      Map<DateTime, List<Event>> events =
                          Provider.of<CalendarManager>(context, listen: false)
                              .getEvents;
                      Provider.of<CalendarManager>(context, listen: false)
                          .setSelectedEvents(events);
                      Map<String, String> encodedEvents = encodeMap(events);
                      Provider.of<AppStateManager>(context, listen: false)
                          .cacheEvents(encodedEvents);
                    },
                    child: Image.asset(
                      "assets/images/trash.png",
                      fit: BoxFit.fitWidth,
                      height: 40,
                    ))
              ])
            : Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox.fromSize(
                        size: Size.fromRadius(size),
                        child: wardrobItem != null
                            ? Image.network(photoUrl!, fit: BoxFit.fill)
                            : Image.network(outfit!.cover, fit: BoxFit.fill)),
                  ),
                  wardrobItem != null
                      ? const SizedBox(
                          width: 30,
                        )
                      : const SizedBox(
                          width: 20,
                        ),
                  wardrobItem != null
                      ? Column(
                          children: [
                            Text(
                              name!,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextButton(
                                child: Text(
                                  "See details",
                                  style: TextStyle(
                                      color: ColorsConstants.darkBrick,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                                onPressed: () => {
                                      //TODO see details
                                    }),
                          ],
                        )
                      : Column(children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              child: Text(
                                "See details",
                                style: TextStyle(
                                    color: ColorsConstants.darkBrick,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                              onPressed: () => {
                                    //TODO see details
                                  }),
                          GestureDetector(
                              onTap: () {
                                //remove selected outfit
                                if (event == null) {
                                  Provider.of<CalendarManager>(context,
                                          listen: false)
                                      .selectOutfit(outfit, true);
                                  Provider.of<CalendarManager>(context,
                                          listen: false)
                                      .removeOutfit(outfit);
                                } else {
                                  //delete outfit from calendar event
                                  Provider.of<CalendarManager>(context,
                                          listen: false)
                                      .removeEvent(event!);
                                  Map<DateTime, List<Event>> events =
                                      Provider.of<CalendarManager>(context,
                                              listen: false)
                                          .getEvents;
                                  Provider.of<CalendarManager>(context,
                                          listen: false)
                                      .setSelectedEvents(events);
                                  Map<String, String> encodedEvents =
                                      encodeMap(events);

                                  Provider.of<AppStateManager>(context,
                                          listen: false)
                                      .cacheEvents(encodedEvents);
                                }
                              },
                              child: Image.asset(
                                "assets/images/trash.png",
                                fit: BoxFit.fitWidth,
                                height: 40,
                              ))
                        ]),
                ],
              ),
      ),
    );
  }
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
