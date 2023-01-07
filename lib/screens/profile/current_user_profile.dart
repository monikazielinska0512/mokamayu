import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/screens/screens.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../generated/l10n.dart';

class CurrentUserProfile extends ProfileScreen {
  const CurrentUserProfile({Key? key, uid}) : super(key: key, uid: uid);

  @override
  ProfileScreenState createState() => _CurrentUserProfileState();
}

class _CurrentUserProfileState extends ProfileScreenState {
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
        .getFutureCurrentUserPostList;
  }

  @override
  String getLeftButtonType() => "dots";

  @override
  Widget buildButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      IconTextButton(
        onPressed: () => context.push('/edit-profile'),
        icon: Icons.edit_outlined,
        text: "Edit",
        backgroundColor: ColorsConstants.peachy,
      ),
      IconTextButton(
        onPressed: () => context.pushNamed('friends'),
        icon: Icons.person_outline_outlined,
        text: "Friends",
        backgroundColor: ColorsConstants.mint,
      ),
    ]);
  }

  @override
  Map<String, Widget> getTabs() {
    return {
      S.of(context).wardrobe: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: PhotoGrid(itemList: itemList)),
      S.of(context).outfits: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: PhotoGrid(outfitsList: outfitsList)),
      S.of(context).posts: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: buildPosts()),
    };
  }

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
