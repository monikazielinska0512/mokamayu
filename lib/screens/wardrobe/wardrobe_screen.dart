import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/screens/wardrobe/wardrobe_item_search.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/constants/constants.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({Key? key}) : super(key: key);

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  Future<List<WardrobeItem>>? futureItemList;
  Future<List<WardrobeItem>>? futureItemListCopy;
  List<String> selectedTypes = Tags.types;
  List<String> selectedSizes = Tags.sizes;
  List<String> selectedStyles = Tags.styles;
  List<String> selectedChips = Tags.types;

  Future<List<Outfit>>? outfitsList;

  @override
  void initState() {
    //reading outfits here, so they're properly loaded in outfits screen
    outfitsList =
        Provider.of<OutfitManager>(context, listen: false).readOutfitsOnce();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<OutfitManager>(context, listen: false)
          .setOutfits(outfitsList!);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    futureItemListCopy = Provider.of<WardrobeManager>(context, listen: true)
        .getWardrobeItemListCopy;
    futureItemList =
        Provider.of<WardrobeManager>(context, listen: true).getWardrobeItemList;
    return BasicScreen(
        type: "wardrobe",
        leftButtonType: "dots",
        context: context,
        body: Stack(children: [
          Column(
            children: [
              Wrap(spacing: 10, runSpacing: 10, children: [
                buildSearchBarAndFilters(),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(spacing: 10, children: [
                      MultiSelectChip(Tags.types,
                          chipsColor: ColorsConstants.darkPeach,
                          onSelectionChanged: (selectedList) {
                        selectedChips =
                            selectedList.isEmpty ? Tags.types : selectedList;
                      }, type: "type_main")
                    ])),
              ]),
              Expanded(
                  child: PhotoGrid(
                      itemList: futureItemListCopy ?? futureItemList)),
            ],
          ),
          buildFloatingButton(),
        ]));
  }

  Widget buildSearchBarAndFilters() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.075,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: WardrobeItemSearch(title: "name")),
          const SizedBox(width: 10),
          FilterModal(
              onApplyWardrobe: (selectedList) =>
                  {futureItemListCopy = selectedList})
        ]));
  }

  Widget buildFloatingButton() {
    return FloatingButton(
        onPressed: () {
          context.goNamed('pick-photo');
        },
        icon: const Icon(Icons.add),
        backgroundColor: ColorsConstants.darkBrick,
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
        alignment: Alignment.bottomRight);
  }
}
