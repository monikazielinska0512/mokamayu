import 'package:flutter/material.dart';
import 'package:mokamayu/widgets/drag_target_container.dart';
import 'package:provider/provider.dart';

import '../../models/wardrobe_item.dart';
import '../../services/managers/managers.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/photo_grid/photo.dart';

class OutfitSummaryScreen extends StatelessWidget {
  OutfitSummaryScreen({super.key, this.map});
  Map<List<dynamic>, ContainerList>? map = {};
  late List<WardrobeItem> itemList;

  @override
  Widget build(BuildContext context) {
    itemList = Provider.of<WardrobeManager>(context, listen: false)
        .getfinalWardrobeItemList;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          title: const Text("Outfit Summary",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        body: Column(children: [
          Expanded(
              child: ListView(
            padding: const EdgeInsets.all(8),
            children: map!.entries.map((entry) {
              return WardrobeItemCard(
                  object: itemList
                      .firstWhere((item) => item.reference == entry.key[1]));
            }).toList(),
          )),
          ButtonDarker(context, "Save", () {
            //TODO save outfit
          })
        ]));
  }
}
