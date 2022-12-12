import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/widgets/widgets.dart';

import '../../models/outfit_container.dart';
import '../../models/wardrobe_item.dart';

class CreateOutfitPage extends StatelessWidget {
  CreateOutfitPage({Key? key, this.itemList}) : super(key: key);
  Future<List<WardrobeItem>>? itemList;
  Map<List<dynamic>, OutfitContainer> map = {};

  // ScreenshotController screenshotController = ScreenshotController();
  // Uint8List? capturedOutfit;

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
        leading: IconButton(
          onPressed: () {
            context.go("/home/1");
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 35,
            ),
            onPressed: () {
              // screenshotController.capture().then((capturedImage) async {
              // capturedOutfit = capturedImage;
              // final directory = await getApplicationDocumentsDirectory();
              // final imagePath =
              //     await File('${directory.path}/image.png').create();
              // await imagePath.writeAsBytes(capturedOutfit!);
              // String url =
              //     await StorageService().uploadFile(context, imagePath.path);

              // Provider.of<PhotoTapped>(context, listen: false)
              //     .setScreenshot(url);
              // GoRouter.of(context)
              //     .goNamed("outfit-summary-screen", extra: map);
              GoRouter.of(context)
                  .goNamed("outfit-add-attributes-screen", extra: map);
              // }).catchError((onError) {
              //   print(onError);
              // });
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
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, deviceHeight(context) * 0.14, 0, 0),
                  // child: Screenshot(
                  //     controller: screenshotController,
                  child: DragTargetContainer(map: map)
                  // ),
                  ),
            )
          ]),
          //TODO categories for wardrobe
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
