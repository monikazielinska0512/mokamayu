import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:mokamayu/widgets/photo_grid/photo_tapped.dart';
import 'package:provider/provider.dart';

import '../drag_target_container.dart';

class PhotoCardOutfit extends StatelessWidget {
  final Outfit object;

  PhotoCardOutfit({Key? key, required this.object}) : super(key: key);
  // Map<List<dynamic>, ContainerList>? getMap = {};

  @override
  Widget build(BuildContext context) {
    String? photoUrl = object.cover;
    Map<String, String>? map = object.map;
    print(map);

    // map = map!.replaceFirst(RegExp(r'{'), '');
    // map = map!.replaceFirst(RegExp(r'}'), '');
    // map = map.substring(1);
    // map = '"' + map! + '"';

    // print(getMap);
    // var iter = 0;
    // map!.split(', [').forEach((element) {
    // iter != 0 ? element = '[' + element : element;
    // iter++;
    // getMap!.addAll({
    //   json.decode(element.split(': ')[0]).cast<dynamic>().toList():
    //       element.split(': ')[1] as ContainerList
    // });
    //   print(List.from(element.split(': ')));
    //   print(element.split(': ')[1]);
    //   print('here');
    // });
    // print(getMap);

    // getMap!.addAll(element as Map<List<dynamic>, ContainerList>));
    // print(list);
    return GestureDetector(
      onTap: () {
        Map<List<dynamic>, ContainerList>? getMap = {};
        map!.forEach((key, value) {
          // key.toString();
          // value.toString();
          Map<String, dynamic> contList = json.decode(value);
          // print(contList);
          ContainerList list = ContainerList(
              height: contList["height"],
              rotation: contList["rotation"],
              scale: contList["scale"],
              width: contList["width"],
              xPosition: contList["xPosition"],
              yPosition: contList["yPosition"]);
          getMap.addAll({json.decode(key): list});
        });

        // print(getMap);
        GoRouter.of(context)
            .goNamed("outfit-add-attributes-screen", extra: getMap);
      },
      child: Card(
        elevation: 2,
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
}
