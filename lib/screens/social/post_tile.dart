import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokamayu/screens/social/post_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../../services/authentication/auth.dart';
import '../../services/managers/managers.dart';
import '../../widgets/fundamental/snackbar.dart';

class PostTile extends StatefulWidget {
  final Post post;

  const PostTile({Key? key, required this.post}) : super(key: key);

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  final commentController = TextEditingController();
  late final Post post;

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
          color: ColorsConstants.whiteAccent,
          borderRadius: BorderRadius.circular(20)),
      child: FutureBuilder<UserData?>(
        future: Provider.of<ProfileManager>(context, listen: false)
            .getUserData(post.createdBy),
        builder: (context, snapshot) {
          UserData? postAuthor = snapshot.data;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildAuthorProfilePicture(postAuthor),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          postAuthor?.profileName ?? postAuthor?.username ?? "",
                          style: TextStyles.paragraphRegularSemiBold16()),
                      Text("Posted ${getDatePosted()}",
                          style: TextStyles.paragraphRegular14(
                              ColorsConstants.grey)),
                    ],
                  ),
                  buildLikesCounter(postAuthor),
                ],
              ),
              Image.network(post.cover, fit: BoxFit.fill),
              buildCommentsSection(),
              buildSeeAllCommentsSection(postAuthor),
            ],
          );
        },
      ),
    );
  }

  Widget buildAuthorProfilePicture(UserData? postAuthor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5), // Image border
      child: SizedBox.fromSize(
        size: const Size.square(50),
        child: postAuthor?.profilePicture != null
            ? Image.network(postAuthor!.profilePicture!, fit: BoxFit.fill)
            : Image.asset(Assets.avatarPlaceholder,
                width: MediaQuery.of(context).size.width * 0.7),
      ),
    );
  }

  String getDatePosted() {
    return DateFormat('dd/MM/yyyy HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(post.creationDate));
  }

  Widget buildLikesCounter(UserData? postAuthor) {
    String currentUserUid = AuthService().getCurrentUserID();
    return Row(
      children: [
        Text(post.likes!.length.toString(),
            style: TextStyles.paragraphRegular14(ColorsConstants.grey)),
        postAuthor?.uid != currentUserUid
            ? post.likes!.contains(currentUserUid)
                ? IconButton(
                    onPressed: () {
                      post.likes!.remove(currentUserUid);
                      Provider.of<PostManager>(context, listen: false).likePost(
                          post.reference!, post.createdBy, post.likes!);
                      setState(() {});
                    },
                    icon: const Icon(Icons.favorite,
                        color: ColorsConstants.darkBrick))
                : IconButton(
                    onPressed: () {
                      post.likes!.add(currentUserUid);
                      Provider.of<PostManager>(context, listen: false).likePost(
                          post.reference!, post.createdBy, post.likes!);
                      setState(() {});
                    },
                    icon: const Icon(Icons.favorite_border,
                        color: ColorsConstants.darkBrick))
            : const Icon(Icons.favorite_border,
                color: ColorsConstants.darkBrick),
      ],
    );
  }

  Widget buildCommentsSection() {
    return TextField(
      controller: commentController,
      onSubmitted: (String comment) {
        post.comments!.add(
            {"author": AuthService().getCurrentUserID(), "content": comment});
        Provider.of<PostManager>(context, listen: false)
            .commentPost(post.reference!, post.createdBy, post.comments!);
        commentController.clear();
        setState(() {});
      },
      decoration: const InputDecoration(
        hintText: "Comment post",
        filled: true,
        fillColor: Colors.white,
        suffixIcon: Icon(Icons.arrow_forward_ios_rounded,
            color: ColorsConstants.darkBrick),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
    );
  }

  Widget buildSeeAllCommentsSection(UserData? postAuthor) {
    return TextButton(
      onPressed: () {
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
      },
      child: Text("View all comments",
          style: TextStyles.paragraphRegular12(ColorsConstants.darkBrick)),
    );
  }
}
