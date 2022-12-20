import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/screens/outfits/outfit_form.dart';
import 'package:mokamayu/services/managers/outfit_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/tags.dart';
import '../../models/outfit.dart';
import '../../models/outfit_container.dart';
import '../../services/managers/app_state_manager.dart';
import '../../services/managers/wardrobe_manager.dart';
import '../../services/storage.dart';
import '../../widgets/chips/multi_select_chips.dart';
import '../../widgets/drag_target_container.dart';
import '../../widgets/fundamental/background_image.dart';
import '../../widgets/photo/photo_grid.dart';
import '../../services/managers/photo_tapped_manager.dart';

class OutfitsAddAttributesScreen extends StatefulWidget {
  OutfitsAddAttributesScreen({Key? key, required this.map}) : super(key: key);
  Map<List<dynamic>, OutfitContainer> map = {};
  Uint8List? capturedOutfit;

  @override
  State<OutfitsAddAttributesScreen> createState() =>
      _OutfitsAddAttributesScreenState();
}

class _OutfitsAddAttributesScreenState
    extends State<OutfitsAddAttributesScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  List<String> selectedChips = Tags.types;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Outfit? item;
  int index = 0;
  bool decision = false;

  @override
  Widget build(BuildContext context) {
    item = Provider.of<PhotoTapped>(context, listen: false).getObject;
    index = Provider.of<OutfitManager>(context, listen: false).getIndex;
    decision = Provider.of<OutfitManager>(context, listen: true).getIndexSet;
    Provider.of<PhotoTapped>(context, listen: false).setMap(widget.map);
    widget.map = Provider.of<PhotoTapped>(context, listen: true).getMapDynamic;

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
                screenshotController.capture().then((capturedImage) async {
                  setState(() {
                    widget.capturedOutfit = capturedImage;
                  });
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var indexList = prefs.getStringList('indexList');
                  if (indexList != null && indexList.isEmpty == false) {
                    // ignore: use_build_context_synchronously
                    Provider.of<OutfitManager>(context, listen: false)
                        .setOutfitIndexesList(
                            indexList.map((i) => int.parse(i)).toList());
                  }
                  File imagePath;
                  if (item == null) {
                    // ignore: use_build_context_synchronously
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
                    final directory = await getApplicationDocumentsDirectory();
                    imagePath =
                        await File('${directory.path}/image${item!.index}.png')
                            .create();
                  }
                  var capturedOutfit = widget.capturedOutfit;
                  await imagePath.writeAsBytes(capturedOutfit!);

                  // ignore: use_build_context_synchronously
                  String url = await StorageService()
                      .uploadFile(context, imagePath.path);

                  // ignore: use_build_context_synchronously
                  Provider.of<PhotoTapped>(context, listen: false)
                      .setScreenshot(url);
                  // ignore: use_build_context_synchronously
                  GoRouter.of(context)
                      .goNamed("outfit-summary-screen", extra: widget.map);
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
            ? bodyEdit(screenshotController, formKey, item!, context)
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
            const BackgroundImage(
              imagePath: "assets/images/upside_down_background.png",
              imageShift: -50,
            ),
            Positioned(
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(0, deviceHeight(context) * 0.14, 0, 0),
                child: Screenshot(
                    controller: screenshotController,
                    child: DragTargetContainer(map: widget.map)),
              ),
            )
          ]),
          MultiSelectChip(Tags.types, onSelectionChanged: (selectedList) {
            selectedChips = selectedList.isEmpty ? Tags.types : selectedList;
          }),
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
                Provider.of<AppStateManager>(context, listen: false)
                    .cacheIndexList(
                        Provider.of<OutfitManager>(context, listen: false)
                            .getIndexList);
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
          const BackgroundImage(
            imagePath: "assets/images/upside_down_background.png",
            imageShift: -50,
          ),
          Positioned(
            child: Padding(
              padding:
                  EdgeInsets.fromLTRB(0, deviceHeight(context) * 0.14, 0, 0),
              child: Screenshot(
                  controller: screenshotController,
                  child: DragTargetContainer(map: widget.map)),
            ),
          )
        ]),
        OutfitForm(formKey: formKey, item: item),
      ],
    );
  }
}
