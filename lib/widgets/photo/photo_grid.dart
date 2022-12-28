import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/services/managers/outfit_manager.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/calendar_event.dart';
import '../../services/managers/app_state_manager.dart';
import '../../services/managers/calendar_manager.dart';
import '../../services/managers/wardrobe_manager.dart';

class PhotoGrid extends StatefulWidget {
  final bool scrollVertically;
  Future<List<WardrobeItem>>? itemList;
  Future<List<Outfit>>? outfitsList;
  String? type;

  PhotoGrid({
    Key? key,
    this.itemList,
    this.outfitsList,
    this.type,
    this.scrollVertically = true,
  }) : super(key: key);

  Axis getScrollDirection() =>
      scrollVertically ? Axis.vertical : Axis.horizontal;

  @override
  State<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  @override
  Widget build(BuildContext context) {
    return widget.outfitsList != null
        ? buildOutfitsGrid()
        : buildWardrobeItemsGrid();
  }

  Widget buildWardrobeItemsGrid() {
    return FutureBuilder<List<WardrobeItem>>(
      future: widget.itemList,
      builder: (context, snapshot) {
        if (snapshot.hasData || snapshot.data != null) {
          return Center(
              child: snapshot.data!.isEmpty
                  ? Text("You don't have any items in your wardrobe!",
                      style: TextStyles.paragraphRegularSemiBold14(Colors.grey))
                  : GridView.builder(
                      scrollDirection: widget.getScrollDirection(),
                      shrinkWrap: false,
                      itemCount: snapshot.data!.length,
                      gridDelegate: widget.scrollVertically
                          ? const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.0,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 1,
                              mainAxisExtent: 240,
                            )
                          : const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 100,
                            ),
                      itemBuilder: (BuildContext context, int index) {
                        var itemInfo = snapshot.data![index];
                        return widget.getScrollDirection() == Axis.vertical
                            ? DeleteBottomModal(
                                wardrobe: itemInfo,
                                actionFunction: () {
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .removeWardrobeItem(itemInfo.reference);
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .nullListItemCopy();
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .setTypes([]);
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .setSizes([]);
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .setStyles([]);
                                  widget.itemList =
                                      Provider.of<WardrobeManager>(context,
                                              listen: false)
                                          .readWardrobeItemOnce();
                                  Provider.of<WardrobeManager>(context,
                                          listen: false)
                                      .setWardrobeItemList(widget.itemList!);
                                  context.pop();
                                },
                              )
                            : PhotoBox(
                                object: itemInfo,
                                scrollVertically: widget.scrollVertically,
                              );
                      },
                    ));
        }
        return Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            ColorsConstants.darkBrick,
          ),
        ));
      },
    );
  }

  Widget buildOutfitsGrid() {
    return FutureBuilder<List<Outfit>>(
      future: widget.outfitsList,
      builder: (context, snapshot) {
        if (snapshot.hasData || snapshot.data != null) {
          return Center(
            child: snapshot.data!.isEmpty
                ? Text("You haven't created any outfits yet!",
                    style: TextStyles.paragraphRegularSemiBold14(Colors.grey))
                : GridView.builder(
                    scrollDirection: widget.getScrollDirection(),
                    shrinkWrap: false,
                    itemCount: snapshot.data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 2,
                      mainAxisExtent: 180,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      var itemInfo = snapshot.data![index];
                      return widget.type == null
                          ? DeleteBottomModal(
                              outfit: itemInfo,
                              actionFunction: () {
                                Provider.of<OutfitManager>(context,
                                        listen: false)
                                    .removeOutfit(itemInfo.reference);
                                Provider.of<OutfitManager>(context,
                                        listen: false)
                                    .nullListItemCopy();
                                Provider.of<OutfitManager>(context,
                                        listen: false)
                                    .setStyles([]);
                                Provider.of<OutfitManager>(context,
                                        listen: false)
                                    .setSeasons([]);
                                widget.outfitsList = Provider.of<OutfitManager>(
                                        context,
                                        listen: false)
                                    .readOutfitsOnce();

                                Provider.of<OutfitManager>(context,
                                        listen: false)
                                    .setOutfits(widget.outfitsList!);

                                context.pop();
                                //checking if outfit was in any event, if so, then delete event from calendar
                                Map<DateTime, List<Event>> events =
                                    Provider.of<CalendarManager>(context,
                                            listen: false)
                                        .getEvents;

                                List<Event> eventsToRemove = [];

                                events.forEach((key, value) {
                                  for (var element in value) {
                                    if (element.outfit == itemInfo) {
                                      eventsToRemove.add(element);
                                    }
                                  }
                                });

                                for (var element in eventsToRemove) {
                                  Provider.of<CalendarManager>(context,
                                          listen: false)
                                      .removeEvent(element);
                                }

                                events = Provider.of<CalendarManager>(context,
                                        listen: false)
                                    .getEvents;
                                Provider.of<CalendarManager>(context,
                                        listen: false)
                                    .setSelectedEvents(events);
                                Map<String, String> encodedEvents =
                                    encodeMap(events);

                                Provider.of<AppStateManager>(context,
                                        listen: false)
                                    .cacheEvents(encodedEvents);
                              },
                            )
                          : PhotoCardOutfit(
                              object: itemInfo, type: "pick_outfits");
                    },
                  ),
          );
        }
        return Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            ColorsConstants.darkBrick,
          ),
        ));
      },
    );
  }
}
