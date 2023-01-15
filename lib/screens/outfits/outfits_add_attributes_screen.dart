import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/screens/outfits/outfit_form.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';

import '../../models/calendar_event.dart';
import '../../services/storage.dart';

class OutfitsAddAttributesScreen extends StatefulWidget {
  OutfitsAddAttributesScreen({Key? key, required this.map, this.friendUid})
      : super(key: key) {
    isCreatingOutfitForFriend = friendUid != null;
  }

  Map<List<dynamic>, OutfitContainer> map = {};
  final String? friendUid;
  late final bool isCreatingOutfitForFriend;
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
  Future<List<WardrobeItem>>? futureItemListCopy;
  Future<List<WardrobeItem>>? itemList;

  @override
  Widget build(BuildContext context) {
    item = Provider.of<PhotoTapped>(context, listen: false).getObject;
    Provider.of<PhotoTapped>(context, listen: false).setMap(widget.map);
    widget.map = Provider.of<PhotoTapped>(context, listen: true).getMapDynamic;

    itemList = widget.isCreatingOutfitForFriend
        ? Provider.of<WardrobeManager>(context, listen: true)
            .getFriendWardrobeItemList
        : Provider.of<WardrobeManager>(context, listen: true)
            .getWardrobeItemList;

    futureItemListCopy = widget.isCreatingOutfitForFriend
        ? Provider.of<WardrobeManager>(context, listen: true)
            .readWardrobeItemsForUser(widget.friendUid!)
        : Provider.of<WardrobeManager>(context, listen: true)
            .getWardrobeItemListCopy;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          title: buildTitle(context),
          leading: IconButton(
            onPressed: () {
              if (item != null) {
                context.pop();
                Provider.of<OutfitManager>(context, listen: false)
                    .resetSingleTags();
                Provider.of<PhotoTapped>(context, listen: false).nullWholeMap();
                Provider.of<WardrobeManager>(context, listen: false)
                    .nullListItemCopy();
                Provider.of<WardrobeManager>(context, listen: false)
                    .setTypes([]);
              } else {
                context.pop();
              }
              Provider.of<OutfitManager>(context, listen: false)
                  .nullListItemCopy();
              Provider.of<OutfitManager>(context, listen: false)
                  .resetTagLists();
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

                  File imagePath;
                  if (item == null) {
                    final directory = await getApplicationDocumentsDirectory();
                    imagePath = await File(
                            '${directory.path}/image${const Uuid().v4()}.png')
                        .create();
                  } else {
                    final directory = await getApplicationDocumentsDirectory();
                    imagePath = await File(
                            '${directory.path}/image${item!.reference}.png')
                        .create();
                  }
                  Uint8List? capturedOutfit = widget.capturedOutfit;
                  await imagePath.writeAsBytes(capturedOutfit!);

                  // ignore: use_build_context_synchronously
                  String url = await StorageService()
                      .uploadFile(context, imagePath.path);

                  // ignore: use_build_context_synchronously
                  Provider.of<PhotoTapped>(context, listen: false)
                      .setScreenshot(url);
                  // ignore: use_build_context_synchronously
                  Provider.of<WardrobeManager>(context, listen: false)
                      .nullListItemCopy();
                  // ignore: use_build_context_synchronously
                  Provider.of<WardrobeManager>(context, listen: false)
                      .setTypes([]);
                  // ignore: use_build_context_synchronously
                  if (mounted) {
                    if (widget.isCreatingOutfitForFriend) {
                      context.pushNamed("outfit-summary-screen",
                          extra: widget.map,
                          queryParams: {'friendUid': widget.friendUid});
                    } else {
                      context.pushNamed("outfit-summary-screen",
                          extra: widget.map);
                    }
                  }
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

  Widget buildTitle(BuildContext context) {
    return item != null
        ? const Text("Edit outfit",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
        : widget.isCreatingOutfitForFriend
            ? FutureBuilder<UserData?>(
                future: Provider.of<ProfileManager>(context, listen: false)
                    .getUserData(widget.friendUid),
                builder: (context, snapshot) => Text(
                    "Create outfit for ${snapshot.data?.username}",
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)))
            : const Text("Create outfit",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
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
          MultiSelectChip(Tags.types,
              type: "type_main", chipsColor: ColorsConstants.darkPeach,
              onSelectionChanged: (selectedList) {
            selectedChips = selectedList.isEmpty ? Tags.types : selectedList;
          }),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: PhotoGrid(
              itemList: futureItemListCopy ?? itemList,
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
                    .resetSingleTags();
                Provider.of<OutfitManager>(context, listen: false)
                    .nullListItemCopy();
                Provider.of<OutfitManager>(context, listen: false)
                    .resetTagLists();

                List<Post> postList =
                    Provider.of<PostManager>(context, listen: false)
                        .getFinalCurrentPostList;

                postList.forEach((element) {
                  if (element.cover == item.cover) {
                    Provider.of<PostManager>(context, listen: false)
                        .removePost(element.reference);
                  }
                });

                //checking if outfit was in any event, if so, then delete event from calendar
                Map<DateTime, List<Event>> events =
                    Provider.of<CalendarManager>(context, listen: false)
                        .getEvents;

                List<Event> eventsToRemove = [];

                events.forEach((key, value) {
                  for (var element in value) {
                    if (element.outfit == item) {
                      eventsToRemove.add(element);
                    }
                  }
                });

                for (var element in eventsToRemove) {
                  Provider.of<CalendarManager>(context, listen: false)
                      .removeEvent(element);
                }

                events = Provider.of<CalendarManager>(context, listen: false)
                    .getEvents;

                Provider.of<CalendarManager>(context, listen: false)
                    .setSelectedEvents(events);
                Map<String, String> encodedEvents = encodeMap(events);

                Provider.of<AppStateManager>(context, listen: false)
                    .cacheEvents(encodedEvents);

                Future<List<Outfit>>? outfitsList =
                    Provider.of<OutfitManager>(context, listen: false)
                        .readOutfitsOnce();
                Provider.of<OutfitManager>(context, listen: false)
                    .setOutfits(outfitsList);
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
