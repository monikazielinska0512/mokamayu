import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/services/photo_tapped.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/widgets/widgets.dart';

class CreateOutfitPage extends StatelessWidget {
  CreateOutfitPage({Key? key, this.clothesList}) : super(key: key);
  Future<List<Clothes>>? clothesList;
  Map<String, ContainerList> map = {};

  @override
  Widget build(BuildContext context) {
    map = Provider.of<PhotoTapped>(context, listen: true).getMap;
    return Scaffold(
      appBar: customAppBar(context, "Create a look"),
      body: Column(
        children: <Widget>[
          DragTargetContainer(map: map),
          //categories for wardrobe
          //TODO
          //photos from wardrobe (button add if no photos) - scroll horizontally
          SizedBox(
            width: double.infinity,
            height: 300,
            child: PhotoGrid(
              clothesList: clothesList,
              scrollVertically: false,
            ),
          )
        ],
      ),
      //),
    );
  }
}
