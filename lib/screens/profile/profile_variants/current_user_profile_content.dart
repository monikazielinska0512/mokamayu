import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../generated/l10n.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/screens/screens.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/constants/constants.dart';

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
  double getHeight() => 0.78;

  @override
  String getTitle() => S.of(context).my_profile;

  @override
  EdgeInsetsGeometry getPadding() =>
      const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10);

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
          padding: const EdgeInsets.only(left: 5),
          child: IconTextButton(
            onPressed: () => context.pushNamed('friends'),
            icon: Icons.person_outline_outlined,
            text: S.of(context).friends,
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
        S.of(context).outfits_by_friends: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: ColorsConstants.darkBrick.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)),
            child: PhotoGrid(outfitsList: getOutfitsCreatedByFriends())),
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
            return EmptyScreen(
                context,
                Text(S.of(context).no_posts,
                    style: TextStyles.paragraphRegular14(Colors.grey),
                    textAlign: TextAlign.center),
                ColorsConstants.darkMint);
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
