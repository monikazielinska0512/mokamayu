import 'package:flutter/material.dart';
import 'package:mokamayu/screens/social/post_list.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/models/models.dart';

import '../../widgets/buttons/predefined_buttons.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}



class _SocialScreenState extends State<SocialScreen> {
  List<Post> postList = [];
  List<Post> friendsPostList = [];
  List<UserData> userList = [];
  late UserData currentUser;

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {

    if (mounted) {
      setState(() {
// Your state change code goes here
      });
    }
    if(Provider.of<ProfileManager>(context, listen: false).currentCustomUser != null){
      currentUser = Provider.of<ProfileManager>(context, listen: false).currentCustomUser!;
    }
    else {
      Provider.of<ProfileManager>(context, listen: false).getCurrentUserData().then((value) => currentUser = value!)
          .whenComplete(() => null);
    }
    Provider.of<UserListManager>(context, listen: false)
        .readUserOnce()
        .then((List<UserData> temp) {
      setState(() => userList = temp);
    });
    Provider.of<PostManager>(context, listen: false)
        .readFriendsPostsOnce(currentUser);


    return BasicScreen(
      title: "Społeczność",
      leftButton: DotsButton(context),
      rightButton: SearchNotificationButton(context),
      context: context,
      backgroundColor: Colors.transparent,
      isFullScreen: false,
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: PostList(userList: userList)),
        ],
      ),
    );
  }
}
