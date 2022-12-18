import 'package:flutter/material.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:mokamayu/models/wardrobe_item.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/widgets/photo/photo_box.dart';
import 'package:mokamayu/widgets/photo/photo_box_outfit.dart';
import 'package:provider/provider.dart';
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
              child:
              snapshot.data!.isEmpty ? const Text("Brak rzeczy w szafie") :
              GridView.builder(
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
              borderRadius: BorderRadius.circular(60.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                color: Colors.amber,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Usuń ${item.name}]'),
                      ElevatedButton(
                        child: Text('Usuń ${item.name}'),
                        onPressed: () {
                          Provider.of<WardrobeManager>(context, listen: false)
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
                        },
                      ),
                    ],
                  ),
                ),
              );
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
