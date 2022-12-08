import 'package:flutter/material.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:mokamayu/models/wardrobe_item.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/widgets/photo/photo_box.dart';
import 'package:mokamayu/widgets/photo/photo_box_outfit.dart';

class PhotoGrid extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return outfitsList != null ? buildOutfitsGrid() : buildWardrobeItemsGrid();
  }

  Widget buildWardrobeItemsGrid() {
    return FutureBuilder<List<WardrobeItem>>(
      future: itemList,
      builder: (context, snapshot) {
        if (snapshot.hasData || snapshot.data != null) {
          return Center(
              child: GridView.builder(
            scrollDirection: getScrollDirection(),
            shrinkWrap: false,
            itemCount: snapshot.data!.length,
            gridDelegate: scrollVertically
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
              return PhotoBox(
                object: itemInfo,
                scrollVertically: scrollVertically,
              );
            },
          ));
        }
        return  Center(
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
      future: outfitsList,
      builder: (context, snapshot) {
        if (snapshot.hasData || snapshot.data != null) {
          return Center(
              child: GridView.builder(
            scrollDirection: getScrollDirection(),
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
