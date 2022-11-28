import 'package:flutter/material.dart';
import 'package:mokamayu/widgets/photo_grid/photo_tapped.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/widgets/widgets.dart';

import '../../constants/constants.dart';

class CreateOutfitPage extends StatelessWidget {
  CreateOutfitPage({Key? key, this.clothesList}) : super(key: key);
  Future<List<Clothes>>? clothesList;
  Map<String, ContainerList> map = {};

  @override
  Widget build(BuildContext context) {
    map = Provider.of<PhotoTapped>(context, listen: true).getMap;
    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double deviceWidth(BuildContext context) =>
        MediaQuery.of(context).size.width;
    return Scaffold(
      //appBar: customAppBar(context, "Create a look"),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("Create outfit",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 35,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Stack(children: <Widget>[
            Positioned(
                child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                "assets/images/backgroundWaves.png",
              ),
            )),
            Positioned(
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(0, deviceHeight(context) * 0.14, 0, 0),
                child: DragTargetContainer(map: map),
              ),
            )
          ]),

          //categories for wardrobe
          //TODO
          //photos from wardrobe (button add if no photos) - scroll horizontally
          SizedBox(
            height: 100,
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
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
