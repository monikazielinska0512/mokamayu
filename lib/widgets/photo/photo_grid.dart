import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/widgets/widgets.dart';

import '../../services/managers/wardrobe_manager.dart';

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
                  ? const Text("Brak rzeczy w szafie")
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
                        return showDeleteModal(itemInfo);
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

  Widget showDeleteModal(WardrobeItem item) {
    return GestureDetector(
        onLongPress: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            barrierColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    GestureDetector(
                        onTap: () => context.pop(),
                        child: Stack(children: const [
                          BackgroundImage(
                              imagePath: "assets/images/full_background.png",
                              imageShift: 0,
                              opacity: 0.5),
                        ])),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      height: MediaQuery.of(context).size.height * 0.30,
                      // color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 25, left: 30),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 25,
                                        color: Colors.grey,
                                      )),
                                )),
                            Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(children: [
                                  Text('Do you want delete this item',
                                      textAlign: TextAlign.center,
                                      style: TextStyles.paragraphRegular20(
                                          ColorsConstants.grey)),
                                  Text('${item.name}?',
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyles.paragraphRegularSemiBold20(
                                              ColorsConstants.grey))
                                ])),
                            ButtonDarker(context, "Delete", () {
                              Provider.of<WardrobeManager>(context,
                                      listen: false)
                                  .removeWardrobeItem(item.reference);
                              setState(() {
                                widget.itemList = Provider.of<WardrobeManager>(
                                        context,
                                        listen: false)
                                    .readWardrobeItemOnce();
                                Future.delayed(Duration.zero).then((value) {
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .setWardrobeItemList(widget.itemList!);
                                });
                              });
                            }, shouldExpand: false, height: 0.062, width: 0.25),
                          ],
                        ),
                      ),
                    )
                  ]);
            },
          );
        },
        child: PhotoBox(
          object: item,
          scrollVertically: widget.scrollVertically,
        ));
  }

  Widget buildOutfitsGrid() {
    return FutureBuilder<List<Outfit>>(
      future: widget.outfitsList,
      builder: (context, snapshot) {
        if (snapshot.hasData || snapshot.data != null) {
          return Center(
              child: GridView.builder(
            scrollDirection: widget.getScrollDirection(),
            shrinkWrap: false,
            itemCount: snapshot.data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 2,
              mainAxisExtent: 180,
            ),
            itemBuilder: (BuildContext context, int index) {
              var itemInfo = snapshot.data![index];
              return PhotoCardOutfit(object: itemInfo);
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
