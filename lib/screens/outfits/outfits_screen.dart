import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/constants/constants.dart';
import 'create_outfit_dialog.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({Key? key}) : super(key: key);

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  Future<List<Outfit>>? outfitsList;
  Future<List<Outfit>>? outfitsListCopy;
  Future<List<WardrobeItem>>? itemList;
  List<String> selectedChips = OutfitTags.styles;

  @override
  void initState() {
    //reading wardrobeItems here, so they're properly loaded in wardrobe screen
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
    outfitsListCopy =
        Provider.of<OutfitManager>(context, listen: true).getOutfitListCopy;
    return BasicScreen(
        type: "outfits",
        leftButtonType: "dots",
        context: context,
        body: Stack(children: [
          Column(
            children: [
              Wrap(spacing: 20, runSpacing: 20, children: [
                buildSearchBarAndFilters(),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(spacing: 10, children: [
                      MultiSelectChip(OutfitTags.styles,
                          chipsColor: ColorsConstants.darkPeach,
                          onSelectionChanged: (selectedList) {
                        selectedChips = selectedList.isEmpty
                            ? OutfitTags.styles
                            : selectedList;
                      }, type: "style_main")
                    ])),
              ]),
              Expanded(
                  child:
                      PhotoGrid(outfitsList: outfitsListCopy ?? outfitsList)),
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
          const Spacer(),
          // Expanded(
          //     child: SearchBar(title: "Search", hintTitle: "Name of item")),
          // SizedBox(width: MediaQuery.of(context).size.width * 0.045),
          FilterModal(
              onApplyOutfits: (selectedList) =>
                  {outfitsListCopy = selectedList})
        ]));
  }

  Widget buildFloatingButton() {
    return FloatingButton(
        onPressed: () {
          showDialog(
              context: context,
              useSafeArea: false,
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
