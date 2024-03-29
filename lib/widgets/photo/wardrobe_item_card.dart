import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../services/managers/managers.dart';
import '../fields/search_text_field.dart';

// ignore: must_be_immutable
class WardrobeItemCard extends StatelessWidget {
  final TextEditingController _eventNameController = TextEditingController();
  WardrobeItemCard(
      {Key? key,
      this.wardrobeItem,
      this.outfit,
      this.calendarPage = false,
      required this.size,
      this.event})
      : super(key: key);
  final WardrobeItem? wardrobeItem;
  final Outfit? outfit;
  bool? calendarPage;
  String? photoUrl = "";
  String? name = "";
  double size = 50;
  Event? event;
  Map<List<dynamic>, OutfitContainer>? getMap = {};

  @override
  Widget build(BuildContext context) {
    if (wardrobeItem != null) {
      photoUrl = wardrobeItem!.photoURL;
      name = wardrobeItem!.name;
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
        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Column(children: [
          Row(
            children: [
              buildPhoto(),
              wardrobeItem != null
                  ? buildEditCard(context)
                  : buildAddCard(context),
            ],
          ),
          wardrobeItem == null
              ? calendarPage != true
                  ? TextField(
                      controller: _eventNameController,
                      decoration: SearchBarStyle(
                        "Event name",
                        fontSize: 14,
                        icon: const Icon(Icons.star,
                            color: ColorsConstants.darkBrick),
                        suffixIcon: IconButton(
                          icon: const Icon(Ionicons.add,
                              color: ColorsConstants.darkBrick),
                          onPressed: () {
                            Provider.of<CalendarManager>(context, listen: false)
                                .addEventNames(
                                    outfit!, _eventNameController.text);
                          },
                        ),
                      ),
                    )
                  : event != null && event!.name != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Text(event!.name!,
                              style: TextStyles.paragraphRegularSemiBold16(
                                  Colors.grey)))
                      : const SizedBox.shrink()
              : const SizedBox.shrink()
        ]),
      ),
    );
  }

  Widget buildAddCard(BuildContext context) {
    return Row(children: [
      const SizedBox(
        width: 80,
      ),
      Column(children: [
        TextButton(
            child: Text(
              S.of(context).see_details,
              style: const TextStyle(
                  color: ColorsConstants.darkBrick,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            onPressed: () => {
                  Provider.of<PhotoTapped>(context, listen: false)
                      .setObject(outfit),
                  outfit!.map!.forEach((key, value) {
                    Map<String, dynamic> contList = json.decode(value);
                    OutfitContainer list = OutfitContainer(
                        height: contList["height"],
                        rotation: contList["rotation"],
                        scale: contList["scale"],
                        width: contList["width"],
                        xPosition: contList["xPosition"],
                        yPosition: contList["yPosition"]);
                    getMap!.addAll({json.decode(key): list});
                  }),
                  GoRouter.of(context)
                      .pushNamed("outfit-add-attributes-screen", extra: getMap)
                }),
        event != null
            ? const SizedBox(
                height: 10,
              )
            : const SizedBox.shrink(),
        GestureDetector(
            onTap: () {
              //remove selected outfit
              if (event == null) {
                Provider.of<CalendarManager>(context, listen: false)
                    .selectOutfit(outfit, true);
                Provider.of<CalendarManager>(context, listen: false)
                    .removeOutfit(outfit);
              } else {
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
              }
            },
            child: Image.asset(
              "assets/images/trash.png",
              fit: BoxFit.fitWidth,
              height: 35,
            )),
      ])
    ]);
  }

  buildEditCard(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  name!,
                  style: TextStyles.paragraphRegularSemiBold18(),
                  textAlign: TextAlign.right,
                ),
                TextButton(
                    child: Text(
                      S.of(context).see_details,
                      style: TextStyles.paragraphRegularSemiBold14(
                          ColorsConstants.darkBrick),
                      textAlign: TextAlign.right,
                    ),
                    onPressed: () => {
                          Provider.of<WardrobeManager>(context, listen: false)
                              .blockEdit(true),
                          context.pushNamed('wardrobe-item',
                              extra: wardrobeItem)
                        }),
              ],
            )));
  }

  Widget buildPhoto() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox.fromSize(
          size: Size.fromRadius(size),
          child: wardrobeItem != null
              ? Image.network(photoUrl!, fit: BoxFit.fill)
              : Image.network(outfit!.cover, fit: BoxFit.fill)),
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
