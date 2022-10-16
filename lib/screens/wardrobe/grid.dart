import 'package:flutter/material.dart';
import '../../models/wardrobe/photo_item.dart';

GridView photoGridView(List<PhotoItem> items) {
  return GridView.builder(
    itemCount: items.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10,
    ),
    itemBuilder: (BuildContext context, int index) {
      return
        Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child: SizedBox.expand(
            child: FittedBox(
              alignment: Alignment.center,
              child: Image.network(items[index].image),
              fit: BoxFit.fill,
            ),
          ),
        );

      //   Container(
      //   width: MediaQuery.of(context).size.width,
      //   alignment: Alignment.topLeft,
      //   child: FittedBox(
      //     fit: BoxFit.fill,
      //     child: ClipRect(
      //       child: Align(
      //         widthFactor: 0.3,
      //         heightFactor: 0.5,
      //         child: Image.network(
      //             items[index].image),
      //       ),
      //     ),
      //   ),
      // );





      //   ClipRect(
      //   child: Align(
      //     alignment: Alignment.topCenter,
      //     heightFactor: 0.5,
      //     child:
      //
      //     Image.network(items[index].image),
      //   ),
      // );

      //   ClipRRect(
      //   borderRadius: const BorderRadius.all(Radius.circular(5)),
      //   child: Container(
      //     width: MediaQuery.of(context).size.width,
      //     height: 100,
      //     constraints: BoxConstraints.tight(const Size(200, 200)),
      //     color: Colors.blueGrey,
      //     child: Image.network(items[index].image),
      //   )
      // );
    },
  );
}
