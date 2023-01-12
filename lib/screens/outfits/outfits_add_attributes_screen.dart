import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
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

    return BasicScreen(
        isFullScreen: true,
        title: item != null
            ? "Edit"
            : "Create outfit${widget.friendUid != null ? " for ..." : ""}",
        context: context,
        body: item != null
            ? bodyEdit(screenshotController, formKey, item!, context)
            : bodyAdd(screenshotController, formKey, item, context),
        leftButton: buildBackButton(),
        rightButton: item != null ? buildEditButtons() : buildAddSaveButton());
  }

  Widget bodyEdit(ScreenshotController screenshotController,
      GlobalKey<FormState> formKey, Outfit item, BuildContext context) {
    return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
      Stack(children: const [
        BackgroundImage(
          imagePath: "assets/images/upside_down_background.png",
          imageShift: 150,
        ),
      ]),
      BackgroundCard(
          context: context,
          height: 0.88,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
              child: Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: SizedBox(
                      height: double.maxFinite,
                      child: Column(
                        children: [buildCanvas(), buildProfileGallery(context)],
                      )))))
    ]);
  }

  Widget bodyAdd(ScreenshotController screenshotController,
      GlobalKey<FormState> formKey, Outfit? item, BuildContext context) {
    return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
      Stack(children: const [
        BackgroundImage(
          imagePath: "assets/images/upside_down_background.png",
          imageShift: 150,
        ),
      ]),
      BackgroundCard(
        context: context,
        height: 0.87,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
            child: Align(
                alignment: AlignmentDirectional.topCenter,
                child: SizedBox(
                    height: double.maxFinite,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              decoration: BoxDecoration(
                                color: ColorsConstants.whiteAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Screenshot(
                                      controller: screenshotController,
                                      child: DragTargetContainer(
                                          map: widget.map)))),
                          Expanded(
                              child: SizedBox(
                                  child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: OutfitForm(
                                          formKey: formKey, item: item)))),
                        ])))),
      )
    ]);
  }

  Widget buildAddSaveButton() {
    return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: IconButton(
          icon: item != null
              ? const Icon(
                  Ionicons.arrow_forward,
                  size: 35,
                )
              : const Icon(
                  Ionicons.add,
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
                imagePath =
                    await File('${directory.path}/image${item!.reference}.png')
                        .create();
              }
              Uint8List? capturedOutfit = widget.capturedOutfit;
              await imagePath.writeAsBytes(capturedOutfit!);

              // ignore: use_build_context_synchronously
              String url = await StorageService().uploadFile(context, imagePath.path);

              // ignore: use_build_context_synchronously
              Provider.of<PhotoTapped>(context, listen: false)
                  .setScreenshot(url);
              // ignore: use_build_context_synchronously
              Provider.of<WardrobeManager>(context, listen: false)
                  .nullListItemCopy();
              // ignore: use_build_context_synchronously
              Provider.of<WardrobeManager>(context, listen: false).setTypes([]);
              // ignore: use_build_context_synchronously
              if (mounted) {
                if (widget.isCreatingOutfitForFriend) {
                  context.pushNamed("outfit-summary-screen",
                      extra: widget.map,
                      queryParams: {'friendUid': widget.friendUid});
                } else {
                  context.pushNamed("outfit-summary-screen", extra: widget.map);
                }
              }
            }).catchError((onError) {
              if (kDebugMode) {
                print(onError);
              }
            });
          },
        ));
  }

  Widget buildRemoveButton() {
    return IconButton(
        icon: const Icon(
          Ionicons.trash_outline,
          size: 30,
        ),
        onPressed: () {
          //Outfit removed
          Provider.of<OutfitManager>(context, listen: false)
              .removeOutfit(item?.reference);
          context.go("/home/1");
          Provider.of<OutfitManager>(context, listen: false).resetSingleTags();
          Provider.of<OutfitManager>(context, listen: false).nullListItemCopy();
          Provider.of<OutfitManager>(context, listen: false).resetTagLists();

          //checking if outfit was in any event, if so, then delete event from calendar
          Map<DateTime, List<Event>> events =
              Provider.of<CalendarManager>(context, listen: false).getEvents;

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

          events =
              Provider.of<CalendarManager>(context, listen: false).getEvents;

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
        });
  }

  Widget buildBackButton() {
    return IconButton(
      onPressed: () {
        if (item != null) {
          context.pop();
          Provider.of<OutfitManager>(context, listen: false).resetSingleTags();
          Provider.of<PhotoTapped>(context, listen: false).nullWholeMap();
          Provider.of<WardrobeManager>(context, listen: false)
              .nullListItemCopy();
          Provider.of<WardrobeManager>(context, listen: false).setTypes([]);
        } else {
          context.pop();
        }
        Provider.of<OutfitManager>(context, listen: false).nullListItemCopy();
        Provider.of<OutfitManager>(context, listen: false).resetTagLists();
      },
      icon: const Icon(Ionicons.chevron_back, size: 35),
    );
  }

  Map<String, Widget>? getTabs() =>
      {"Photos": buildEditPhoto(), "Attributes": buildFormEdit()};

  Widget buildProfileGallery(BuildContext context) {
    List<Tab>? tabs = getTabs()
        ?.keys
        .map((label) => Tab(
            child: Text(label,
                style: TextStyles.paragraphRegularSemiBold14(),
                textAlign: TextAlign.center)))
        .toList();
    return tabs == null
        ? Container()
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
              child: DefaultTabController(
                length: tabs.length,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TabBar(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorsConstants.peachy.withOpacity(0.3)),
                      indicatorColor: ColorsConstants.darkBrick,
                      labelStyle: TextStyles.paragraphRegular16(),
                      labelColor: ColorsConstants.darkBrick,
                      unselectedLabelColor: ColorsConstants.grey,
                      tabs: tabs,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: getTabs()!
                            .values
                            .map((widget) => Padding(
                                padding: const EdgeInsets.all(5),
                                child: widget))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget buildEditPhoto() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MultiSelectChip(Tags.getLanguagesTypes(context),
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
        ]);
  }

  Widget buildCanvas() {
    return Screenshot(
        controller: screenshotController,
        child: Container(
            decoration: BoxDecoration(
              color: ColorsConstants.whiteAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: DragTargetContainer(map: widget.map))));
  }

  Widget buildFormEdit() {
    return OutfitForm(formKey: formKey, item: item);
  }

  Widget buildEditButtons() {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [buildRemoveButton(), buildAddSaveButton()]));
  }
}
