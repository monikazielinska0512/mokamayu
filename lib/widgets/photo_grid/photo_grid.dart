import 'package:flutter/material.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:mokamayu/models/wardrobe_item.dart';
import 'package:mokamayu/widgets/photo_grid/photo_box.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/widgets/photo_grid/photo_box_outfit.dart';

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
    //print(itemList);
    if (outfitsList != null) {
      return FutureBuilder<List<Outfit>>(
        future: outfitsList,
        builder: (context, snapshot) {
          //print(snapshot);
          //print(snapshot.data);
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
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2,
                      mainAxisExtent: 250,
                    )
                  : const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // childAspectRatio: 2.0,
                      // crossAxisSpacing: 2,
                      // mainAxisSpacing: 1,
                      mainAxisExtent: 100,
                    ),
              itemBuilder: (BuildContext context, int index) {
                var itemInfo = snapshot.data![index];
                return PhotoCardOutfit(object: itemInfo);
              },
            ));
          }
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              ColorsConstants.primary,
            ),
          ));
        },
      );
    } else {
      //print('here');
      return FutureBuilder<List<WardrobeItem>>(
        future: itemList,
        builder: (context, snapshot) {
          //print(snapshot.data);
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
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2,
                      mainAxisExtent: 250,
                    )
                  : const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // childAspectRatio: 2.0,
                      // crossAxisSpacing: 2,
                      // mainAxisSpacing: 1,
                      mainAxisExtent: 100,
                    ),
              itemBuilder: (BuildContext context, int index) {
                var itemInfo = snapshot.data![index];
                //print(itemInfo);
                return PhotoCard(
                  object: itemInfo,
                  scrollVertically: scrollVertically,
                );
              },
            ));
          }
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              ColorsConstants.primary,
            ),
          ));
        },
      );
    }
  }
}
