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

  @override
  Widget build(BuildContext context) {
    String? photoUrl = object.cover;
    Map<String, String>? map = object.map;
    return GestureDetector(
      onTap: () {
        Map<List<dynamic>, ContainerList>? getMap = {};
        map!.forEach((key, value) {
          Map<String, dynamic> contList = json.decode(value);
          ContainerList list = ContainerList(
              height: contList["height"],
              rotation: contList["rotation"],
              scale: contList["scale"],
              width: contList["width"],
              xPosition: contList["xPosition"],
              yPosition: contList["yPosition"]);
          getMap.addAll({json.decode(key): list});
        });
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
