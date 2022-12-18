import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/screens/outfits/outfit_form.dart';
import 'package:mokamayu/services/managers/outfit_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../models/outfit.dart';
import '../../models/outfit_container.dart';
import '../../services/managers/wardrobe_manager.dart';
import '../../services/storage.dart';
import '../../widgets/drag_target_container.dart';
import '../../widgets/photo_grid/photo_grid.dart';
import '../../widgets/photo_grid/photo_tapped.dart';

class OutfitsAddAttributesScreen extends StatelessWidget {
  OutfitsAddAttributesScreen({Key? key, required this.map}) : super(key: key);
  Map<List<dynamic>, OutfitContainer> map = {};

  @override
  Widget build(BuildContext context) {
    ScreenshotController screenshotController = ScreenshotController();
    Uint8List? capturedOutfit;
    final formKey = GlobalKey<FormState>();
    Outfit? item = Provider.of<PhotoTapped>(context, listen: false).getObject;
    int index = Provider.of<OutfitManager>(context, listen: false).getIndex;
    bool decision =
        Provider.of<OutfitManager>(context, listen: true).getIndexSet;
    Provider.of<PhotoTapped>(context, listen: false).setMap(map);
    map = Provider.of<PhotoTapped>(context, listen: true).getMapDynamic;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          title: item != null
              ? const Text("Edit outfit",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
              : const Text("Create outfit",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: () {
              if (item != null) {
                context.go("/home/1");
                Provider.of<OutfitManager>(context, listen: false)
                    .setSeason("");
                Provider.of<OutfitManager>(context, listen: false).setStyle("");
                Provider.of<PhotoTapped>(context, listen: false)
                    .setImagePath("");
                Provider.of<PhotoTapped>(context, listen: false).setMap({});
                Provider.of<PhotoTapped>(context, listen: false).nullWholeMap();
                Provider.of<OutfitManager>(context, listen: false)
                    .indexIsSet(false);
              } else {
                Provider.of<OutfitManager>(context, listen: false)
                    .indexIsSet(false);
                context.goNamed("create-outfit-page",
                    extra: Provider.of<WardrobeManager>(context, listen: false)
                        .getWardrobeItemList);
              }
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add,
                size: 35,
              ),
              onPressed: () {
                formKey.currentState!.save();
                screenshotController.capture().then((capturedImage) async {
                  File imagePath;
                  if (item == null) {
                    index = Provider.of<OutfitManager>(context, listen: false)
                        .getMaxOutfitIndexes;
                    decision == false
                        ? index == 0
                            ? index = 1
                            : index = index + 1
                        : index = index;
                    final directory = await getApplicationDocumentsDirectory();
                    imagePath = await File('${directory.path}/image$index.png')
                        .create();
                    // ignore: use_build_context_synchronously
                    Provider.of<PhotoTapped>(context, listen: false)
                        .setImagePath('${directory.path}/image$index.png');
                    if (decision == false) {
                      // ignore: use_build_context_synchronously
                      Provider.of<OutfitManager>(context, listen: false)
                          .addToIndexes(index);
                      // ignore: use_build_context_synchronously
                      Provider.of<OutfitManager>(context, listen: false)
                          .setIndex(index);
                      // ignore: use_build_context_synchronously
                      Provider.of<OutfitManager>(context, listen: false)
                          .indexIsSet(true);
                    }
                  } else {
                    imagePath = await File(item.imagePath).create();
                  }
                  capturedOutfit = capturedImage;
                  await imagePath.writeAsBytes(capturedOutfit!);
                  // ignore: use_build_context_synchronously
                  String url = await StorageService()
                      .uploadFile(context, imagePath.path);

                  // ignore: use_build_context_synchronously
                  Provider.of<PhotoTapped>(context, listen: false)
                      .setScreenshot(url);
                  // ignore: use_build_context_synchronously
                  GoRouter.of(context)
                      .goNamed("outfit-summary-screen", extra: map);
                }).catchError((onError) {
                  if (kDebugMode) {
                    print(onError);
                  }
                });
              },
            )
          ],
        ),
        body: item != null
            ? bodyEdit(screenshotController, formKey, item, context)
            : bodyAdd(screenshotController, formKey, item, context));
  }

  Widget bodyEdit(ScreenshotController screenshotController,
      GlobalKey<FormState> formKey, Outfit item, BuildContext context) {
    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double deviceWidth(BuildContext context) =>
        MediaQuery.of(context).size.width;
    return SizedBox(
        width: deviceWidth(context),
        height: deviceHeight(context),
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
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
                padding:
                    EdgeInsets.fromLTRB(0, deviceHeight(context) * 0.14, 0, 0),
                child: Screenshot(
                    controller: screenshotController,
                    child: DragTargetContainer(map: map)),
              ),
            )
          ]),
          const SizedBox(
            height: 50, //place for wardrobe categories
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: PhotoGrid(
              itemList: Provider.of<WardrobeManager>(context, listen: false)
                  .getWardrobeItemList,
              scrollVertically: false,
            ),
          ),
          OutfitForm(formKey: formKey, item: item),
          GestureDetector(
              onTap: () {
                //Outfit removed
                Provider.of<OutfitManager>(context, listen: false)
                    .removeOutfit(item.reference);
                context.go("/home/1");
                Provider.of<OutfitManager>(context, listen: false)
                    .setSeason("");
                Provider.of<OutfitManager>(context, listen: false).setStyle("");
                Provider.of<OutfitManager>(context, listen: false)
                    .removeFromIndexes(item.index);
                Provider.of<OutfitManager>(context, listen: false)
                    .indexIsSet(false);
              },
              child: Image.asset(
                "assets/images/trash.png",
                fit: BoxFit.fitWidth,
                height: 40,
              )),
          const SizedBox(
            height: 50,
          )
        ])));
  }

  Widget bodyAdd(ScreenshotController screenshotController,
      GlobalKey<FormState> formKey, Outfit? item, BuildContext context) {
    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    return Column(
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
              padding:
                  EdgeInsets.fromLTRB(0, deviceHeight(context) * 0.14, 0, 0),
              child: Screenshot(
                  controller: screenshotController,
                  child: DragTargetContainer(map: map)),
            ),
          )
        ]),
        OutfitForm(formKey: formKey, item: item),
      ],
    );
  }
}
