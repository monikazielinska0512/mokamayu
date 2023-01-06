import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/models.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../services/services.dart';
import '../../widgets/buttons/buttons.dart';
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
        ? Provider.of<WardrobeManager>(context, listen: true)
            .getFriendFinalWardrobeItemList
        : Provider.of<WardrobeManager>(context, listen: true)
            .getFinalWardrobeItemList;

    capturedOutfit =
        Provider.of<PhotoTapped>(context, listen: false).getScreenshot;
    _season = Provider.of<OutfitManager>(context, listen: false).getSeason!;
    _style = Provider.of<OutfitManager>(context, listen: false).getStyle!;
    Outfit? item = Provider.of<PhotoTapped>(context, listen: false).getObject;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Provider.of<OutfitManager>(context, listen: false)
                  .setSeason(_season);
              Provider.of<OutfitManager>(context, listen: false)
                  .setStyle(_style);
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text("Outfit Summary",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        body: Column(children: [
          Expanded(
              child: ListView(
            padding: const EdgeInsets.all(8),
            children: map!.entries.map((entry) {
              itemList!.forEach((element) {
                if (element.reference == entry.key[1]) {
                  _elements.add(entry.key[1]);
                }
              });
              return WardrobeItemCard(
                  size: 50,
                  wardrobItem: itemList!.firstWhere(
                      (item) => item.reference == entry.key[1],
                      orElse: () => WardrobeItem(
                          name: "Photo deleted :(",
                          type: "",
                          size: "",
                          photoURL: "Photo deleted",
                          styles: [],
                          created: DateTime.now())));
            }).toList(),
          )),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tags",
                    style: TextStyles.paragraphRegularSemiBold18(),
                  ))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ChoiceChip(
                label: Text(_season),
                selected: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                backgroundColor: ColorsConstants.darkMint,
                selectedColor: ColorsConstants.darkMint.withOpacity(0.2),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ChoiceChip(
                  label: Text(_style),
                  selected: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  backgroundColor: ColorsConstants.sunflower,
                  selectedColor: ColorsConstants.sunflower.withOpacity(0.2),
                ),
              )),
          item != null ? EditButton(context, item) : SaveButton(context)
        ]));
  }

  Widget EditButton(BuildContext context, Outfit item) {
    return ButtonDarker(context, "Edit", () async {
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
      Provider.of<OutfitManager>(context, listen: false).resetSingleTags();
      Provider.of<PhotoTapped>(context, listen: false).nullMap(_elements);
      Provider.of<PhotoTapped>(context, listen: false).setObject(null);
      context.go("/home/1");
    });
  }

  Widget SaveButton(BuildContext context) {
    String currentUserUid = AuthService().getCurrentUserID();
    return ButtonDarker(context, "Save", () async {
      Map<String, String> mapToFirestore = {};
      map!.forEach((key, value) {
        mapToFirestore.addAll({json.encode(key): jsonEncode(value)});
      });
      Outfit data = Outfit(
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
        cover: capturedOutfit,
        creationDate: DateTime.now().millisecondsSinceEpoch,
        likes: [],
        comments: [],
      );
      String postOwnerUid =
          isCreatingOutfitForFriend ? friendUid! : currentUserUid;
      Provider.of<PostManager>(context, listen: false)
          .addPostToFirestore(postData, postOwnerUid);
      postList =
          Provider.of<PostManager>(context, listen: false).readPostsOnce();
      Provider.of<PostManager>(context, listen: false).getCurrentUserPosts();
      Provider.of<PostManager>(context, listen: false).setPosts(postList!);

      if (isCreatingOutfitForFriend) {
        context.go("/home/2");
      } else {
        context.go("/home/1");
      }
    });
  }
}
