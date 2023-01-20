import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/screens/screens.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/buttons/predefined_buttons.dart';

class CurrentUserProfileContent extends AbstractProfileContent {
  const CurrentUserProfileContent({Key? key, required String? uid})
      : super(key: key, uid: uid);

  @override
  AbstractProfileContentState createState() =>
      _CurrentUserProfileContentState();
}

class _CurrentUserProfileContentState extends AbstractProfileContentState {
  Future<List<Post>>? futureUserPosts;

  @override
  void initState() {
    futureUserPosts =
        Provider.of<PostManager>(context, listen: false).getCurrentUserPosts();
    super.initState();
  }

  @override
  void loadData() {
    futureUserPosts = Provider.of<PostManager>(context, listen: false)
        .getFinalCurrentUserPostList;
  }

  @override
  Widget getLeftButton() => DotsButton(context);

  @override
  Widget getRightButton() => NotificationsButton(context);

  @override
  Color? setBackgroundColor() => Colors.transparent;

  @override
  Widget buildButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      IconTextButton(
        onPressed: () => context.push('/edit-profile'),
        icon: Icons.edit_outlined,
        text: S.of(context).edit,
        backgroundColor: ColorsConstants.peachy,
      ),
      Padding(
          padding: EdgeInsets.only(left: 5),
          child: IconTextButton(
            onPressed: () => context.pushNamed('friends'),
            icon: Icons.person_outline_outlined,
            text: "Friends",
            backgroundColor: ColorsConstants.mint,
          )),
    ]);
  }

  Future<List<Outfit>> getOutfitsCreatedByMe() async {
    List<Outfit> allOutfits =
        Provider.of<OutfitManager>(context, listen: false).getFinalOutfitList;
    return allOutfits
        .where((outfit) => outfit.createdBy == widget.uid)
        .toList();
  }

  Future<List<Outfit>> getOutfitsCreatedByFriends() async {
    List<Outfit> allOutfits =
        Provider.of<OutfitManager>(context, listen: false).getFinalOutfitList;
    return allOutfits
        .where((outfit) => outfit.createdBy != widget.uid)
        .toList();
  }

  @override
  Map<String, Widget>? getTabs() => {
        S.of(context).outfits_by_me: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: ColorsConstants.peachy.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15)),
            child: PhotoGrid(outfitsList: getOutfitsCreatedByMe())),
        S.of(context).outfits_by_friends:
            PhotoGrid(outfitsList: getOutfitsCreatedByFriends()),
        S.of(context).posts: buildPosts(),
      };

  Widget buildPosts() {
    return FutureBuilder<List<Post>>(
      future: futureUserPosts,
      builder: (context, postsList) {
        if (postsList.hasData) {
          if (postsList.data == null || postsList.data!.isNotEmpty) {
            return ListView.separated(
              itemCount: postsList.data!.length,
              separatorBuilder: (context, _) => const SizedBox(height: 3),
              itemBuilder: (BuildContext context, int index) {
                return PostCardSmall(post: postsList.data![index]);
              },
            );
          } else {
            return Center(
              child: Text("There are no posts to display.",
                  style: TextStyles.paragraphRegularSemiBold14(Colors.grey),
                  textAlign: TextAlign.center),
            );
          }
        }
        return const Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(ColorsConstants.darkBrick),
        ));
      },
    );
  }
}
