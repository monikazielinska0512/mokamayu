import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/screens/outfits/outfit_form.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../models/outfit_container.dart';
import '../../services/managers/wardrobe_manager.dart';
import '../../services/storage.dart';
import '../../widgets/background_card.dart';
import '../../widgets/drag_target_container.dart';
import '../../widgets/photo_grid/photo_tapped.dart';

class OutfitsAddAttributesScreen extends StatefulWidget {
  OutfitsAddAttributesScreen({super.key, required this.map});
  Map<List<dynamic>, OutfitContainer> map = {};

  @override
  State<OutfitsAddAttributesScreen> createState() =>
      _OutfitsAddAttributesScreenState();
}

class _OutfitsAddAttributesScreenState
    extends State<OutfitsAddAttributesScreen> {
  // late String capturedOutfit;
  @override
  Widget build(BuildContext context) {
    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double deviceWidth(BuildContext context) =>
        MediaQuery.of(context).size.width;
    // capturedOutfit =
    //     Provider.of<PhotoTapped>(context, listen: false).getScreenshot;
    ScreenshotController screenshotController = ScreenshotController();
    Uint8List? capturedOutfit;
    final _formKey = GlobalKey<FormState>();
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
            context.goNamed("create-outfit-page",
                extra: Provider.of<WardrobeManager>(context, listen: false)
                    .getWardrobeItemList);
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
              screenshotController.capture().then((capturedImage) async {
                capturedOutfit = capturedImage;
                final directory = await getApplicationDocumentsDirectory();
                final imagePath =
                    await File('${directory.path}/image.png').create();
                await imagePath.writeAsBytes(capturedOutfit!);
                String url =
                    await StorageService().uploadFile(context, imagePath.path);

                Provider.of<PhotoTapped>(context, listen: false)
                    .setScreenshot(url);
                print(widget.map);
                _formKey.currentState!.save();
                GoRouter.of(context)
                    .goNamed("outfit-summary-screen", extra: widget.map);
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
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(0, deviceHeight(context) * 0.14, 0, 0),
                child: Screenshot(
                    controller: screenshotController,
                    child: DragTargetContainer(map: widget.map)),
              ),
            )
          ]),
          OutfitForm(formKey: _formKey),
        ],
      ),
    );
  }
}
