import 'package:flutter/material.dart';
import 'package:mokamayu/screens/social/post_list.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/models/models.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  List<Post> postList = [];
  List<Post> friendsPostList = [];
  List<UserData> userList = [];

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    Provider.of<PostManager>(context, listen: true)
        .readPostsOnce()
        .then((List<Post> temp) {
      setState(() => postList = temp);
    });
    Provider.of<UserListManager>(context, listen: false)
        .readUserOnce()
        .then((List<UserData> temp) {
      setState(() => userList = temp);
    });
    UserData currentUser = userList.singleWhere(
        (element) => element.uid == AuthService().getCurrentUserID());
    var friendList = Provider.of<FriendsManager>(context, listen: false)
        .readFriendsIdsOnce(currentUser);
    friendList.add(currentUser.uid);
    friendsPostList = Provider.of<PostManager>(context, listen: false)
        .readFeedPostsOnce(friendList, postList);

    return BasicScreen(
      type: "social",
      leftButtonType: "dots",
      rightButtonType: "search-notif",
      context: context,
      backgroundColor: Colors.transparent,
      isFullScreen: true,
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: PostList(postList: friendsPostList, userList: userList)),
        ],
      ),
    );
  }
}
