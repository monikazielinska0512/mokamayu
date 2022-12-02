import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/screens/outfits/outfit_summary_screen.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:screenshot/screenshot.dart';

import '../../models/wardrobe_item.dart';

class CreateOutfitPage extends StatelessWidget {
  CreateOutfitPage({Key? key, this.itemList}) : super(key: key);
  Future<List<WardrobeItem>>? itemList;
  Map<List<dynamic>, ContainerList> map = {};

  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? capturedOutfit;

  @override
  Widget build(BuildContext context) {
    map = Provider.of<PhotoTapped>(context, listen: true).getMap;

    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double deviceWidth(BuildContext context) =>
        MediaQuery.of(context).size.width;
    return Scaffold(
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
            onPressed: () {
              screenshotController.capture().then((capturedImage) async {
                capturedOutfit = capturedImage;
                print(map);
                print(capturedOutfit);
                Provider.of<PhotoTapped>(context, listen: false)
                    .setScreenshot(capturedOutfit as Uint8List);
                GoRouter.of(context)
                    .pushNamed("outfit-summary-screen", extra: map);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => OutfitSummaryScreen(
                //           map: map, capturedOutfit: capturedOutfit),
                //     ));
              }).catchError((onError) {
                print(onError);
              });
            },
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
                fit: BoxFit.fitWidth,
              ),
            )),
            Positioned(
                child: Screenshot(
              controller: screenshotController,
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(0, deviceHeight(context) * 0.14, 0, 0),
                child: DragTargetContainer(map: map),
              ),
            ))
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
              itemList: itemList,
              scrollVertically: false,
            ),
          )
        ],
      ),
      //),
    );
  }
}
