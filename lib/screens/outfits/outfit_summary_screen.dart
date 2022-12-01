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
  OutfitSummaryScreen({super.key, this.map, this.capturedOutfit});
  Map<List<dynamic>, ContainerList>? map = {};

  String? capturedOutfit; //ZAMIENIC NA UINT8LIST
  late List<WardrobeItem> itemList;

  @override
  Widget build(BuildContext context) {
    itemList = Provider.of<WardrobeManager>(context, listen: false)
        .getfinalWardrobeItemList;

    // final List<int> codeUnits = capturedOutfit!.codeUnits;
    // final Uint8List unit8List = Uint8List.fromList(codeUnits);
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
          // Image.memory(capturedOutfit).toString(),
          ButtonDarker(context, "Save", () async {
            //TODO save outfit
            List<String> elements = [];
            itemList.forEach((element) {
              elements.add(element.id!);
            });

            Outfit data = Outfit(
              elements: elements,
              //cover: Image.memory(capturedOutfit!).toString(),
              //createdBy: AuthService().getCurrentUserID()
            );
            Provider.of<OutfitManager>(context, listen: false)
                .addOutfitToFirestore(data);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => HomeScreen(currentTab: 1)));

            //add routing to outfits page
            GoRouter.of(context).go('/home/1');
          })
        ]));
  }
}
