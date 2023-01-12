import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:provider/provider.dart';

class PhotoCardOutfit extends StatelessWidget {
  PhotoCardOutfit({Key? key, this.object, this.type}) : super(key: key);
  final Outfit? object;
  String? type;
  bool? selected = false;
  Map<Outfit?, bool> outfitsMap = {};
  List<Outfit?> pickedOutfits = [];

  @override
  Widget build(BuildContext context) {
    if (type != null) {
      outfitsMap =
          Provider.of<CalendarManager>(context, listen: true).getOutfitsMap;
      selected = outfitsMap[object];
      selected ??= false;
      // print(selected);
    }

    String? photoUrl = object!.cover;
    Map<String, String>? map = object!.map;
    return GestureDetector(
      onTap: () {
        type == null ? tapOutfit(context, map) : tapOutfitCalendar(context);
      },
      child: Card(
        elevation: 0,
        shadowColor: selected == false
            ? ColorsConstants.white
            : ColorsConstants.darkBrick,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15), // Image border
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(80), // Image radius
                  child: Image.network(photoUrl),
                ),
              )),
        ]),
      ),
    );
  }

  void tapOutfit(BuildContext context, Map<String, String>? map) {
    Map<List<dynamic>, OutfitContainer>? getMap = {};
    map!.forEach((key, value) {
      Map<String, dynamic> contList = json.decode(value);
      OutfitContainer list = OutfitContainer(
          height: contList["height"],
          rotation: contList["rotation"],
          scale: contList["scale"],
          width: contList["width"],
          xPosition: contList["xPosition"],
          yPosition: contList["yPosition"]);
      getMap.addAll({json.decode(key): list});
    });
    Provider.of<PhotoTapped>(context, listen: false).setObject(object);
    Provider.of<OutfitManager>(context, listen: false)
        .setSeason(object!.season);
    Provider.of<OutfitManager>(context, listen: false).setStyle(object!.style);
    getMap.forEach((key, value) {
      Provider.of<PhotoTapped>(context, listen: false).addIds(key[1]);
    });

    if (isOutfitMine(context)) {
      context.pushNamed("outfit-add-attributes-screen", extra: getMap);
    } else {
      Provider.of<PhotoTapped>(context, listen: false)
          .setScreenshot(object?.cover ?? "");
      context.pushNamed("outfit-summary-screen",
          extra: getMap, queryParams: {'friendUid': object?.owner});
    }
  }

  bool isOutfitMine(BuildContext context) =>
      Provider.of<OutfitManager>(context, listen: false)
          .getFinalOutfitList
          .contains(object);

  void tapOutfitCalendar(BuildContext context) {
    if (selected == false) {
      Provider.of<CalendarManager>(context, listen: false)
          .selectOutfit(object, selected);
      Provider.of<CalendarManager>(context, listen: false).addOutfit(object);
      selected = true;
    } else {
      Provider.of<CalendarManager>(context, listen: false)
          .selectOutfit(object, selected);
      Provider.of<CalendarManager>(context, listen: false).removeOutfit(object);
      selected = false;
    }
  }
}
