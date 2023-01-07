import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokamayu/screens/social/post_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../../services/managers/managers.dart';
import '../../widgets/fundamental/snackbar.dart';

class PostSummaryTile extends StatefulWidget {
  final Post post;

  const PostSummaryTile({Key? key, required this.post}) : super(key: key);

  @override
  State<PostSummaryTile> createState() => _PostSummaryTileState();
}

class _PostSummaryTileState extends State<PostSummaryTile> {
  final commentController = TextEditingController();
  late final Post post;

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
        future: Provider.of<ProfileManager>(context, listen: false)
            .getUserData(post.createdBy),
        builder: (context, snapshot) {
          UserData? postAuthor = snapshot.data;
          return GestureDetector(
            onTap: () => navigateToPostView(postAuthor),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 0,
              color: ColorsConstants.whiteAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(50),
                          child: Image.network(post.cover, fit: BoxFit.fill),
                        )),
                    const SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            postAuthor?.profileName ??
                                postAuthor?.username ??
                                "",
                            style: TextStyles.paragraphRegularSemiBold16()),
                        buildDatePosted(),
                        const SizedBox(height: 10),
                        buildLikeAndCommentCounters(),
                      ],
                    ),
                  ])),
            ),
          );
        });
  }

  void navigateToPostView(UserData? postAuthor) {
    if (postAuthor != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => PostScreen(
                  post: post, user: postAuthor, userList: const [])));
    } else {
      CustomSnackBar.showErrorSnackBar(
          message: 'Post author not found', context: context);
    }
  }

  Widget buildDatePosted() {
    String creationDate = DateFormat('dd/MM/yyyy HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(post.creationDate));
    return Text("Posted $creationDate",
        style: TextStyles.paragraphRegular12(ColorsConstants.grey));
  }

  Widget buildLikeAndCommentCounters() {
    return Row(children: [
      buildCounter(
          Icons.favorite, ColorsConstants.darkBrick, post.likes!.length),
      const SizedBox(width: 10),
      buildCounter(
          Icons.chat_bubble, ColorsConstants.sunflower, post.comments!.length),
    ]);
  }

  Widget buildCounter(IconData icon, Color color, int value) {
    return Row(children: [
      Icon(icon, color: color.withOpacity(0.6)),
      const SizedBox(width: 7),
      Text(value.toString(),
          style: TextStyles.paragraphRegular14(ColorsConstants.grey))
    ]);
  }
}
