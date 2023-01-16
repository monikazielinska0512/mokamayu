import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:mokamayu/widgets/fields/search_text_field.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../widgets/buttons/predefined_buttons.dart';

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
    futureItemListCopy = Provider
        .of<WardrobeManager>(context, listen: true)
        .getWardrobeItemListCopy;
    futureItemList =
        Provider
            .of<WardrobeManager>(context, listen: true)
            .getWardrobeItemList;
    return BasicScreen(
        title: S.of(context).wardrobe,
        leftButton: DotsButton(context),
        backgroundColor: Colors.transparent,
        rightButton: NotificationsButton(context),
        context: context,
        body: Stack(children: [
          Column(
            children: [
              Wrap(spacing: 10, runSpacing: 10, children: [
                buildSearchBarAndFilters(),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(spacing: 10, children: [
                      MultiSelectChip(Tags.getLanguagesTypes(context),
                          chipsColor: ColorsConstants.darkPeach,
                          onSelectionChanged: (selectedList) {
                            selectedChips =
                            selectedList.isEmpty ? Tags.types : selectedList;
                          }, type: "type_main")
                    ])),
              ]),
              const SizedBox(height: 10),
              Expanded(
                  child: 
                  Container( 
                    padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: ColorsConstants.mint.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                      child: PhotoGrid(
                      itemList: futureItemListCopy ?? futureItemList))),
            ],
          ),
          buildFloatingButton(),
        ]));
  }

  Widget buildSearchBarAndFilters() {
    return SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.076,
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SizedBox(
        width: MediaQuery.of(context).size.width * 0.73,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.1,
        child: SearchTextField(
            readOnly: true,
            onTap: () =>

        context.pushNamed("wardrobe-item-search-screen",
        extra: futureItemList)
  ,
    )),
    const SizedBox(width: 10),
    FilterModal(
    width: 0.15,
    height: 0.1,
    onApplyWardrobe: (selectedList) =>
    {futureItemListCopy = selectedList})
    ]
    )
    );
  }

  Widget buildFloatingButton() {
    return FloatingButton(
        onPressed: () {
          context.pushNamed('pick-photo');
        },
        icon: const Icon(Icons.add),
        backgroundColor: ColorsConstants.darkBrick,
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
        alignment: Alignment.bottomRight);
  }
}