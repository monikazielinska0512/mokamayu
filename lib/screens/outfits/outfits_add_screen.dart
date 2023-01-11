import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../models/models.dart';
import '../../services/managers/managers.dart';


//ignore: must_be_immutable
class CreateOutfitPage extends StatelessWidget {
  CreateOutfitPage({Key? key, this.itemList, this.friendUid})
      : super(key: key) {
    isCreatingOutfitForFriend = friendUid != null;
  }

  Future<List<WardrobeItem>>? itemList;
  String? friendUid;
  late final bool isCreatingOutfitForFriend;
  Map<List<dynamic>, OutfitContainer> map = {};
  List<String> selectedChips = Tags.types;
  Future<List<WardrobeItem>>? futureItemListCopy;

  @override
  Widget build(BuildContext context) {
    map = Provider.of<PhotoTapped>(context, listen: true).getMapDynamic;
    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;

    itemList = isCreatingOutfitForFriend
        ? Provider.of<WardrobeManager>(context, listen: true)
            .getFriendWardrobeItemList
        : Provider.of<WardrobeManager>(context, listen: true)
            .getWardrobeItemList;

    futureItemListCopy = isCreatingOutfitForFriend
        ? Provider.of<WardrobeManager>(context, listen: true)
            .getFriendWardrobeItemListCopy
        : Provider.of<WardrobeManager>(context, listen: true)
            .getWardrobeItemListCopy;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("Create outfit${friendUid != null ? " for ..." : ""}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () {
            Provider.of<PhotoTapped>(context, listen: false).nullWholeMap();
            Provider.of<OutfitManager>(context, listen: false)
                .resetSingleTags();
            Provider.of<WardrobeManager>(context, listen: false)
                .nullListItemCopy();
            Provider.of<WardrobeManager>(context, listen: false).setTypes([]);
            context.pop();
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
              if (isCreatingOutfitForFriend) {
                context.pushNamed("outfit-add-attributes-screen",
                    extra: map, queryParams: {'friendUid': friendUid});
              } else {
                context.pushNamed("outfit-add-attributes-screen", extra: map);
              }
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
          buildFilters(context),
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

  Widget buildFilters(BuildContext context) {
    return MultiSelectChip(
      Tags.getLanguagesTypes(context),
      type: "type_main",
      chipsColor: ColorsConstants.darkPeach,
      usingFriendsWardrobe: isCreatingOutfitForFriend,
      onSelectionChanged: (selectedList) {
        selectedChips = selectedList.isEmpty ? Tags.types : selectedList;
      },
    );
  }
}
