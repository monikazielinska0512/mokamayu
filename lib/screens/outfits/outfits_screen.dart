import 'dart:async';
import 'package:flutter/material.dart';
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
    Future.delayed(Duration.zero).then((value) {
      Provider.of<WardrobeManager>(context, listen: false)
          .setWardrobeItemList(itemList!);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    outfitsList =
        Provider.of<OutfitManager>(context, listen: true).getOutfitList;
    return BasicScreen(
        type: "outfits",
        leftButtonType: "dots",
        context: context,
        body: Stack(children: [
          Column(
            children: [
              Wrap(spacing: 20, runSpacing: 20, children: [
                buildSearchBarAndFilters(),
                MultiSelectChipsFormField(
                    chipsList: OutfitTags.styles, isScroll: true),
              ]),
              Expanded(child: PhotoGrid(outfitsList: outfitsList)),
            ],
          ),
          buildFloatingButton(),
        ]));
  }

  Widget buildSearchBarAndFilters() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.075,
        child: Row(children: [
          Expanded(
              child: SearchBar(title: "Search", hintTitle: "Name of item")),
          SizedBox(width: MediaQuery.of(context).size.width * 0.045),
          CustomIconButton(
              onPressed: () {},
              width: MediaQuery.of(context).size.width * 0.15,
              icon: Icons.filter_list)
        ]));
  }

  Widget buildFloatingButton() {
    return FloatingButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(itemList: itemList);
              });
        },
        icon: const Icon(Icons.add),
        backgroundColor: ColorsConstants.darkBrick,
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
        alignment: Alignment.bottomRight);
  }
}
