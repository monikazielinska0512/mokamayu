import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/constants/constants.dart';
import '../../services/managers/outfit_manager.dart';
import 'create_outfit_dialog.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({Key? key}) : super(key: key);

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  Future<List<Outfit>>? outfitsList;
  Future<List<WardrobeItem>>? itemList;

  @override
  void initState() {
    outfitsList =
        Provider.of<OutfitManager>(context, listen: false).readOutfitsOnce();
    Provider.of<OutfitManager>(context, listen: false).setOutfits(outfitsList!);
    itemList = Provider.of<WardrobeManager>(context, listen: false)
        .readWardrobeItemOnce();
    Provider.of<WardrobeManager>(context, listen: false)
        .setWardrobeItem(itemList!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                child: PhotoGrid(outfitsList: outfitsList)))
      ]),
      FloatingButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBox.outfitsDialog(context, itemList);
                });
          },
          icon: const Icon(Icons.add),
          backgroundColor: ColorsConstants.primary,
          padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
          alignment: Alignment.bottomRight)
    ]));
  }
}
