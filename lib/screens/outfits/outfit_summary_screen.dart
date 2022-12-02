import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/screens/screens.dart';
import 'package:mokamayu/services/managers/outfit_manager.dart';
import 'package:mokamayu/widgets/drag_target_container.dart';
import 'package:provider/provider.dart';

import '../../models/outfit.dart';
import '../../models/wardrobe_item.dart';
import '../../services/authentication/auth.dart';
import '../../services/managers/managers.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/photo_grid/photo.dart';

class OutfitSummaryScreen extends StatelessWidget {
  OutfitSummaryScreen({super.key, this.map});
  Map<List<dynamic>, ContainerList>? map = {};
  late String capturedOutfit;
  late List<WardrobeItem> itemList;
  List<String> _elements = [];

  @override
  Widget build(BuildContext context) {
    itemList = Provider.of<WardrobeManager>(context, listen: false)
        .getfinalWardrobeItemList;
    capturedOutfit =
        Provider.of<PhotoTapped>(context, listen: false).getScreenshot;
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
              _elements.add(entry.key[1]);
              return WardrobeItemCard(
                  object: itemList
                      .firstWhere((item) => item.reference == entry.key[1]));
            }).toList(),
          )),
          ButtonDarker(context, "Save", () async {
            Outfit data = Outfit(
                elements: _elements,
                cover: capturedOutfit,
                createdBy: AuthService().getCurrentUserID());
            Provider.of<OutfitManager>(context, listen: false)
                .addOutfitToFirestore(data);
            Provider.of<PhotoTapped>(context, listen: false).nullMap(_elements);
            _elements = [];
            // setState(() {});
            context.go("/home/1");
            // context.go("/home");
            // GoRouter.of(context).go('/home/1');
          })
        ]));
  }
}
