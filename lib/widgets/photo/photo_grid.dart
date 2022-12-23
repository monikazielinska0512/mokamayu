import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/services/managers/outfit_manager.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../services/managers/wardrobe_manager.dart';
import '../modals/delete_wardrobe_item_modal.dart';

class PhotoGrid extends StatefulWidget {
  final bool scrollVertically;
  Future<List<WardrobeItem>>? itemList;
  Future<List<Outfit>>? outfitsList;

  PhotoGrid({
    Key? key,
    this.itemList,
    this.outfitsList,
    this.scrollVertically = true,
  }) : super(key: key);

  Axis getScrollDirection() =>
      scrollVertically ? Axis.vertical : Axis.horizontal;

  @override
  State<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  @override
  Widget build(BuildContext context) {
    return widget.outfitsList != null
        ? buildOutfitsGrid()
        : buildWardrobeItemsGrid();
  }

  Widget buildWardrobeItemsGrid() {
    return FutureBuilder<List<WardrobeItem>>(
      future: widget.itemList,
      builder: (context, snapshot) {
        if (snapshot.hasData || snapshot.data != null) {
          return Center(
              child: snapshot.data!.isEmpty
                  ? Text("You don't have any items in your wardrobe!",
                      style: TextStyles.paragraphRegularSemiBold14(Colors.grey))
                  : GridView.builder(
                      scrollDirection: widget.getScrollDirection(),
                      shrinkWrap: false,
                      itemCount: snapshot.data!.length,
                      gridDelegate: widget.scrollVertically
                          ? const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.0,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 1,
                              mainAxisExtent: 240,
                            )
                          : const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 100,
                            ),
                      itemBuilder: (BuildContext context, int index) {
                        var itemInfo = snapshot.data![index];
                        return widget.getScrollDirection() == Axis.vertical
                            ? DeleteBottomModal(
                                wardrobe: itemInfo,
                                actionFunction: () {
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .removeWardrobeItem(itemInfo.reference);
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .nullListItemCopy();
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .setTypes([]);
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .setSizes([]);
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .setStyles([]);
                                  widget.itemList =
                                      Provider.of<WardrobeManager>(context,
                                              listen: false)
                                          .readWardrobeItemOnce();
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .setWardrobeItemList(widget.itemList!);
                                  context.pop();
                                },
                              )
                            : PhotoBox(
                                object: itemInfo,
                                scrollVertically: widget.scrollVertically,
                              );
                      },
                    ));
        }
        return Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            ColorsConstants.darkBrick,
          ),
        ));
      },
    );
  }

  Widget buildOutfitsGrid() {
    return FutureBuilder<List<Outfit>>(
      future: widget.outfitsList,
      builder: (context, snapshot) {
        if (snapshot.hasData || snapshot.data != null) {
          return Center(
              child: snapshot.data!.isEmpty
                  ? Text("You haven't created any outfits yet!",
                      style: TextStyles.paragraphRegularSemiBold14(Colors.grey))
                  : GridView.builder(
                      scrollDirection: widget.getScrollDirection(),
                      shrinkWrap: false,
                      itemCount: snapshot.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 2,
                        mainAxisExtent: 180,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var itemInfo = snapshot.data![index];
                        return DeleteBottomModal(
                          outfit: itemInfo,
                          actionFunction: () {
                            Provider.of<OutfitManager>(context, listen: false)
                                .removeOutfit(itemInfo.reference);
                            Provider.of<OutfitManager>(context, listen: false)
                                .nullListItemCopy();
                            Provider.of<OutfitManager>(context, listen: false)
                                .setStyles([]);
                            Provider.of<OutfitManager>(context, listen: false)
                                .setSeasons([]);
                            widget.outfitsList = Provider.of<OutfitManager>(
                                    context,
                                    listen: false)
                                .readOutfitsOnce();
                            Provider.of<OutfitManager>(context, listen: false)
                                .setOutfits(widget.outfitsList!);
                            context.pop();
                          },
                        );
                      },
                    ));
        }
        return Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            ColorsConstants.darkBrick,
          ),
        ));
      },
    );
  }
}
