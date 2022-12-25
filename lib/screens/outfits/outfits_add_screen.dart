import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/widgets/widgets.dart';

import '../../constants/colors.dart';
import '../../constants/tags.dart';
import '../../models/outfit_container.dart';
import '../../models/wardrobe_item.dart';
import '../../services/managers/outfit_manager.dart';
import '../../services/managers/photo_tapped_manager.dart';
import '../../services/managers/wardrobe_manager.dart';

class CreateOutfitPage extends StatelessWidget {
  CreateOutfitPage({Key? key, this.itemList}) : super(key: key);
  Future<List<WardrobeItem>>? itemList;
  Map<List<dynamic>, OutfitContainer> map = {};
  List<String> selectedChips = Tags.types;
  Future<List<WardrobeItem>>? futureItemListCopy;

  @override
  Widget build(BuildContext context) {
    map = Provider.of<PhotoTapped>(context, listen: true).getMapDynamic;
    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;

    futureItemListCopy = Provider.of<WardrobeManager>(context, listen: true)
        .getWardrobeItemListCopy;
    itemList =
        Provider.of<WardrobeManager>(context, listen: true).getWardrobeItemList;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Create outfit",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () {
            Provider.of<PhotoTapped>(context, listen: false).setMap({});
            Provider.of<PhotoTapped>(context, listen: false).nullWholeMap();
            Provider.of<OutfitManager>(context, listen: false).setSeason("");
            Provider.of<OutfitManager>(context, listen: false).setStyle("");
            Provider.of<WardrobeManager>(context, listen: false)
                .nullListItemCopy();
            Provider.of<WardrobeManager>(context, listen: false).setTypes([]);
            context.go("/home/1");
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 35,
            ),
            onPressed: () {
              Provider.of<PhotoTapped>(context, listen: false).setObject(null);
              Provider.of<WardrobeManager>(context, listen: false)
                  .nullListItemCopy();
              Provider.of<WardrobeManager>(context, listen: false).setTypes([]);
              GoRouter.of(context)
                  .goNamed("outfit-add-attributes-screen", extra: map);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Stack(children: <Widget>[
            const BackgroundImage(
              imagePath: "assets/images/upside_down_background.png",
              imageShift: -50,
            ),
            Positioned(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, deviceHeight(context) * 0.14, 0, 0),
                  child: DragTargetContainer(map: map)
                  // ),
                  ),
            )
          ]),
          MultiSelectChip(Tags.types,
              type: "type_main", chipsColor: ColorsConstants.darkPeach,
              onSelectionChanged: (selectedList) {
            selectedChips = selectedList.isEmpty ? Tags.types : selectedList;
          }),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: PhotoGrid(
              itemList: futureItemListCopy ?? itemList,
              scrollVertically: false,
            ),
          )
        ],
      ),
      //),
    );
  }
}
