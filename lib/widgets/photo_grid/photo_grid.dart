import 'package:flutter/material.dart';
import 'package:mokamayu/models/clothes.dart';
import 'package:mokamayu/widgets/photo_grid/photo_box.dart';
import 'package:mokamayu/constants/colors.dart';

class PhotoGrid extends StatelessWidget {
  final bool scrollVertically;
  Future<List<Clothes>>? clothesList;

  PhotoGrid({
    Key? key,
    this.clothesList,
    this.scrollVertically = true,
  }) : super(key: key);

  Axis getScrollDirection() =>
      scrollVertically ? Axis.vertical : Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Clothes>>(
      future: clothesList,
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
              var clothesInfo = snapshot.data![index];
              return PhotoCard(
                  object: clothesInfo, scrollVertically: scrollVertically);
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
