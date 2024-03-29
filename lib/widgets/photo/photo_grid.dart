import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';

//ignore: must_be_immutable
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
                  ? Container(
                      decoration: BoxDecoration(
                          color: ColorsConstants.peachy.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            const Icon(
                              Ionicons.sad_outline,
                              size: 25,
                              color: Colors.grey,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(30),
                                child: Text(S.of(context).empty_wardrobe,
                                    textAlign: TextAlign.center,
                                    style: TextStyles.paragraphRegular14(
                                        Colors.grey)))
                          ])))
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
                            ? itemInfo.createdBy ==
                                    AuthService().getCurrentUserID()
                                ? DeleteBottomModal(
                                    wardrobe: itemInfo,
                                    actionFunction: () {
                                      Provider.of<WardrobeManager>(context,
                                              listen: false)
                                          .removeWardrobeItem(
                                              itemInfo.reference);
                                      Provider.of<WardrobeManager>(context,
                                              listen: false)
                                          .resetBeforeCreatingNewOutfit();
                                      widget.itemList =
                                          Provider.of<WardrobeManager>(context,
                                                  listen: false)
                                              .readWardrobeItemOnce();
                                      Provider.of<WardrobeManager>(context,
                                              listen: false)
                                          .setWardrobeItemList(
                                              widget.itemList!);
                                      context.pop();
                                      CustomSnackBar.showErrorSnackBar(
                                          context: context,
                                          message: S.of(context).deleted_item);
                                    },
                                  )
                                : PhotoBox(
                                    object: itemInfo,
                                    scrollVertically: widget.scrollVertically,
                                  )
                            : PhotoBox(
                                object: itemInfo,
                                scrollVertically: widget.scrollVertically,
                              );
                      },
                    ));
        }
        return const Center(
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
                ? Container(
                    decoration: BoxDecoration(
                        color: ColorsConstants.peachy.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          const Icon(
                            Ionicons.sad_outline,
                            size: 25,
                            color: Colors.grey,
                          ),
                          Padding(
                              padding: const EdgeInsets.all(30),
                              child: Text(S.of(context).empty_outfits,
                                  textAlign: TextAlign.center,
                                  style: TextStyles.paragraphRegular14(
                                      Colors.grey)))
                        ])))
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
                          ? itemInfo.createdBy ==
                                      AuthService().getCurrentUserID() ||
                                  itemInfo.owner ==
                                      AuthService().getCurrentUserID()
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
                                        .resetTagLists();
                                    widget.outfitsList =
                                        Provider.of<OutfitManager>(context,
                                                listen: false)
                                            .readOutfitsOnce();

                                    Provider.of<OutfitManager>(context,
                                            listen: false)
                                        .setOutfits(widget.outfitsList!);

                                    context.pop();
                                    CustomSnackBar.showErrorSnackBar(
                                        context: context,
                                        message: S.of(context).deleted_outfit);

                                    List<Post> postList =
                                        Provider.of<PostManager>(context,
                                                listen: false)
                                            .getFinalCurrentPostList;

                                    for (var element in postList) {
                                      if (element.cover == itemInfo.cover) {
                                        Provider.of<PostManager>(context,
                                                listen: false)
                                            .removePost(element.reference);
                                        Provider.of<PostManager>(context,
                                                listen: false)
                                            .getCurrentUserPosts();
                                        List<Post> postList =
                                            Provider.of<PostManager>(context,
                                                    listen: false)
                                                .getFinalCurrentPostList;
                                        Provider.of<PostManager>(context,
                                                listen: false)
                                            .setFinalCurrentUserPostList(
                                                postList);

                                        late UserData currentUser;

                                        Provider.of<ProfileManager>(context,
                                                listen: false)
                                            .getCurrentUserData()
                                            .then((UserData? temp) {
                                          setState(() => currentUser = temp!);
                                          Provider.of<PostManager>(context,
                                                  listen: false)
                                              .readFriendsPostsOnce(
                                                  currentUser);
                                        });
                                        List<Post> finalPostList =
                                            Provider.of<PostManager>(context,
                                                    listen: false)
                                                .getFinalPostList;
                                        Provider.of<PostManager>(context,
                                                listen: false)
                                            .setFinalPostList(finalPostList);
                                      }
                                    }

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

                                    events = Provider.of<CalendarManager>(
                                            context,
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
                              : PhotoCardOutfit(object: itemInfo)
                          : PhotoCardOutfit(
                              object: itemInfo, type: "pick_outfits");
                    },
                  ),
          );
        }
        return const Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            ColorsConstants.darkBrick,
          ),
        ));
      },
    );
  }
}
