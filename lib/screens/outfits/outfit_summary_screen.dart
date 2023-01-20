import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/widgets/buttons/predefined_buttons.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/widgets/widgets.dart';
import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import '../../services/services.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/fundamental/snackbar.dart';
import '../../widgets/photo/photo.dart';

class OutfitSummaryScreen extends StatelessWidget {
  OutfitSummaryScreen({super.key, this.map, this.friendUid}) {
    isCreatingOutfitForFriend = friendUid != null;
  }

  Map<List<dynamic>, OutfitContainer>? map = {};
  final String? friendUid;
  late final bool isCreatingOutfitForFriend;
  late String capturedOutfit;
  List<WardrobeItem>? itemList;
  List<String> _elements = [];
  late String _style;
  late String _season;
  Future<List<Outfit>>? outfitsList;
  Future<List<Post>>? postList;

  @override
  Widget build(BuildContext context) {
    itemList = isCreatingOutfitForFriend
        ? Provider
        .of<WardrobeManager>(context, listen: true)
        .getFinalFriendWardrobeItemList
        : Provider
        .of<WardrobeManager>(context, listen: true)
        .getFinalWardrobeItemList;

    capturedOutfit =
        Provider
            .of<PhotoTapped>(context, listen: false)
            .getScreenshot;
    _season = Provider
        .of<OutfitManager>(context, listen: false)
        .getSeason!;
    _style = Provider
        .of<OutfitManager>(context, listen: false)
        .getStyle!;
    Outfit? item = Provider
        .of<PhotoTapped>(context, listen: false)
        .getObject;
    return BasicScreen(
        title: "Summary",
        context: context,
        body: Column(children: [
          buildList(context),
          buildTags(),
          item != null ? EditButton(context, item) : SaveButton(context)
        ]),
        leftButton: BackArrowButton(context),
        rightButton: null);
  }

  Widget buildList(BuildContext context) {
    return Expanded(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: map!.entries.map((entry) {
            for (var element in itemList!) {
              if (element.reference == entry.key[1]) {
                _elements.add(entry.key[1]);
              }
            }
            return WardrobeItemCard(
                size: MediaQuery
                    .of(context)
                    .size
                    .width * 0.1,
                wardrobeItem: itemList!.firstWhere(
                        (item) => item.reference == entry.key[1],
                    orElse: () =>
                        WardrobeItem(
                            name: "Photo deleted :(",
                            type: "",
                            size: "",
                            photoURL: "Photo deleted",
                            styles: [],
                            created: DateTime.now())));
          }).toList(),
        ));
  }

  Widget buildTags() {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tags",
                style: TextStyles.paragraphRegularSemiBold18(),
              ))),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
        child: Align(
            alignment: Alignment.centerLeft,
            child: ChoiceChip(
              label: Text(_season, style: TextStyles.paragraphRegularSemiBold14(
                  ColorsConstants.white)),
              selected: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              selectedColor: ColorsConstants.darkMint,
            )),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ChoiceChip(
              label: Text(_style,
                  style: TextStyles.paragraphRegularSemiBold14(
                      ColorsConstants.white)),
              selected: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              selectedColor: ColorsConstants.sunflower,
            ),
          ))
    ]);
  }

  Widget EditButton(BuildContext context, Outfit item) {
    return isCreatingOutfitForFriend
        ? Container()
        : ButtonDarker(context, "Edit", () async {
      Map<String, String> mapToFirestore = {};
      map!.forEach((key, value) {
        mapToFirestore.addAll({json.encode(key): jsonEncode(value)});
      });
      Provider.of<OutfitManager>(context, listen: false).updateOutfit(
          item.reference ?? "",
          _style,
          _season,
          capturedOutfit,
          _elements,
          mapToFirestore);
      Provider.of<OutfitManager>(context, listen: false)
          .resetSingleTags();
      Provider.of<PhotoTapped>(context, listen: false).nullMap(_elements);
      Provider.of<PhotoTapped>(context, listen: false).setObject(null);

      outfitsList = Provider.of<OutfitManager>(context, listen: false)
          .readOutfitsOnce();
      Provider.of<OutfitManager>(context, listen: false)
          .setOutfits(outfitsList!);

      context.go("/home/1");
    });
  }

  Widget SaveButton(BuildContext context) {
    String currentUserUid = AuthService().getCurrentUserID();
    return ButtonDarker(context, "Save", () async {
      if (_elements.length > 0) {
        Map<String, String> mapToFirestore = {};
        map!.forEach((key, value) {
          mapToFirestore.addAll({json.encode(key): jsonEncode(value)});
        });
        Outfit data = Outfit(
            owner: friendUid ?? currentUserUid,
            elements: _elements,
            cover: capturedOutfit,
            style: _style,
            season: _season,
            map: mapToFirestore,
            createdBy: currentUserUid);
        Provider.of<OutfitManager>(context, listen: false)
            .addOutfitToFirestore(data, friendUid ?? currentUserUid);

        if (!isCreatingOutfitForFriend) {
          outfitsList = Provider.of<OutfitManager>(context, listen: false)
              .readOutfitsOnce();
          Provider.of<OutfitManager>(context, listen: false)
              .setOutfits(outfitsList!);
          Provider.of<OutfitManager>(context, listen: false).resetSingleTags();
          Provider.of<PhotoTapped>(context, listen: false).nullMap(_elements);
          Provider.of<PhotoTapped>(context, listen: false).setObject(null);
        }

        _elements = [];

        Post postData = Post(
          createdBy: currentUserUid,
          createdFor: friendUid ?? currentUserUid,
          cover: capturedOutfit,
          creationDate: DateTime.now().millisecondsSinceEpoch,
          likes: [],
          comments: [],
        );

        CustomNotification notif = CustomNotification(
            sentFrom: currentUserUid,
            type: NotificationType.NEW_OUTFIT.toString(),
            creationDate: DateTime.now().millisecondsSinceEpoch);

        isCreatingOutfitForFriend
            ? {
                Provider.of<PostManager>(context, listen: false)
                    .addPostToFirestore(postData, friendUid!),
                Provider.of<NotificationsManager>(context, listen: false)
                    .addNotificationToFirestore(notif, friendUid!)
              }
            : Provider.of<PostManager>(context, listen: false)
                .addPostToFirestore(postData, currentUserUid);

        Provider.of<PostManager>(context, listen: false).getCurrentUserPosts();

        if (isCreatingOutfitForFriend) {
          context.go("/home/2");
        } else {
          context.go("/home/1");
        }
      } else {
        CustomSnackBar.showErrorSnackBar(
            message: S.of(context).pick_clothes_error, context: context);
      }
    });
  }
}

