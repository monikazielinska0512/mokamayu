import 'package:flutter/material.dart';

import '../../models/wardrobe/photo_item.dart';

GridView photoGridView(List<PhotoItem> items) {
  return GridView.builder(
    itemCount: items.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 5.0,
      mainAxisSpacing: 5.0,
    ),
    itemBuilder: (BuildContext context, int index) {
      return Image.network(items[index].image);
    },
  );
}