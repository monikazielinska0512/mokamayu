import 'package:flutter/material.dart';
import 'package:mokamayu/widgets/drag_target_container.dart';
import 'package:provider/provider.dart';

import '../../models/wardrobe_item.dart';
import '../../services/managers/managers.dart';
import '../../widgets/photo_grid/photo_box.dart';

class OutfitSummaryScreen extends StatelessWidget {
  OutfitSummaryScreen({super.key, this.map});
  Map<List<dynamic>, ContainerList>? map = {};
  late List<WardrobeItem> itemList;

  @override
  Widget build(BuildContext context) {
    itemList = Provider.of<WardrobeManager>(context, listen: false)
        .getfinalWardrobeItemList;
    print(itemList);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text("Outfit Summary",
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: map!.entries.map((entry) {
            return Container(
                child: PhotoCard(
                    object: itemList
                        .firstWhere((item) => item.reference == entry.key[1]),
                    scrollVertically: true));
          }).toList(),
        ));
  }
}
