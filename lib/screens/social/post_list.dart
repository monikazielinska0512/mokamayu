import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/screens/screens.dart';
import 'package:mokamayu/services/authentication/auth.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../services/managers/managers.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class PostList extends StatefulWidget {
  final List<Post> postList;
  final List<UserData> userList;

  const PostList({
    Key? key,
    required this.postList,
    required this.userList,
  }) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late List<TextEditingController> myController;

  @override
  void initState() {
    myController =
        List.generate(widget.postList.length, (_) => TextEditingController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.postList.isNotEmpty ? buildFeed(context) : buildEmpty();
  }

  Widget buildFeed(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
                color: ColorsConstants.whiteAccent,
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader(index),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  buildPostBody(index),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  widget.postList[index].createdFor !=
                          widget.postList[index].createdBy
                      ? buildDate(index)
                      : Container(),
                  buildCommentField(index),
                  buildViewCommentButton(index)
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            Container(height: 20),
        itemCount: widget.postList.length);
  }

  Widget buildHeader(int index) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildUserAvatar(index),
            const Padding(padding: EdgeInsets.only(left: 10)),
            buildName(index)
          ]),
      buildLikeButton(index)
    ]);
  }

  Widget buildCommentField(int index) {
    return TextField(
      controller: myController[index],
      onSubmitted: (String comment) {
        print("add comment");
        widget.postList[index].comments!.add(
            {"author": AuthService().getCurrentUserID(), "content": comment});
        Provider.of<PostManager>(context, listen: false).commentPost(
            widget.postList[index].reference!,
            widget.postList[index].createdFor,
            widget.postList[index].comments!);
        myController[index].clear();
        setState(() {});
        if (AuthService().getCurrentUserID() !=
            widget.postList[index].createdBy) {
          CustomNotification notif = CustomNotification(
              sentFrom: AuthService().getCurrentUserID(),
              type: NotificationType.COMMENT.toString(),
              creationDate: DateTime.now().millisecondsSinceEpoch);
          Provider.of<NotificationsManager>(context, listen: false)
              .addNotificationToFirestore(
                  notif, widget.postList[index].createdBy);
        }
      },
      decoration: const InputDecoration(
        hintText: "Skomentuj",
        filled: true,
        fillColor: Colors.white,
        suffixIcon: Icon(
          Icons.arrow_forward_ios_rounded,
          color: ColorsConstants.darkBrick,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
      ),
    );
  }

  Widget buildViewCommentButton(int index) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PostScreen(
                      post: widget.postList[index],
                      user: widget.userList.singleWhere((element) =>
                          element.uid == widget.postList[index].createdBy),
                      userList: widget.userList,
                    )));
      },
      child: Text(
        "Zobacz wszystkie komentarze",
        style: TextStyles.paragraphRegularSemiBold12(ColorsConstants.darkBrick),
      ),
    );
  }

  Widget buildPostBody(int index) {
    return ExtendedImage.network(
      widget.postList[index].cover,
      fit: BoxFit.fill,
      cache: true,
      enableMemoryCache: false,
      enableLoadState: true,
    );
  }

  Widget buildName(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.postList[index].createdFor == widget.postList[index].createdBy
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [buildPostingUser(index), buildDate(index)])
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildPostingUser(index),
                  Row(children: [
                    Text("Stworzono przez ",
                        style: TextStyles.paragraphRegular12(Colors.grey),
                        textAlign: TextAlign.start),
                    buildCreatedByUser(index),
                  ])
                ],
              ),
      ],
    );
  }

  Widget buildPostingUser(int index) {
    return GestureDetector(
        onTap: () {
          context.pushNamed(
            "profile",
            queryParams: {
              'uid': widget.postList[index].createdFor,
            },
          );
        },
        child: Text(
            widget.userList
                        .singleWhere((element) =>
                            element.uid == widget.postList[index].createdFor)
                        .profileName !=
                    null
                ? widget.userList
                    .singleWhere((element) =>
                        element.uid == widget.postList[index].createdFor)
                    .profileName!
                    .capitalize()
                : widget.userList
                    .singleWhere((element) =>
                        element.uid == widget.postList[index].createdFor)
                    .username
                    .capitalize(),
            style: TextStyles.paragraphRegularSemiBold16()));
  }

  Widget buildCreatedByUser(int index) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          "profile",
          queryParams: {
            'uid': widget.postList[index].createdBy,
          },
        );
      },
      child: Text(
          widget.userList
                      .singleWhere((element) =>
                          element.uid == widget.postList[index].createdBy)
                      .profileName !=
                  null
              ? widget.userList
                  .singleWhere((element) =>
                      element.uid == widget.postList[index].createdBy)
                  .profileName!
              : widget.userList
                  .singleWhere((element) =>
                      element.uid == widget.postList[index].createdBy)
                  .username,
          style: TextStyles.paragraphRegular14(ColorsConstants.darkBrick)),
    );
  }

  Widget buildDate(int index) {
    return
      Padding(padding: EdgeInsets.only(bottom: 10), child:
      Text(
        "Opublikowano ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.postList[index].creationDate))}",
        style: TextStyles.paragraphRegular12(ColorsConstants.grey)));
  }

  Widget buildUserAvatar(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5), // Image border
      child: SizedBox.fromSize(
        size: const Size.square(50),
        child: widget.userList
                    .singleWhere((element) =>
                        element.uid == widget.postList[index].createdFor)
                    .profilePicture !=
                null
            ? Image.network(
                widget.userList
                    .singleWhere((element) =>
                        element.uid == widget.postList[index].createdFor)
                    .profilePicture!,
                fit: BoxFit.fill)
            : Image.asset(Assets.avatarPlaceholder,
                width: MediaQuery.of(context).size.width * 0.7),
      ),
    );
  }

  Widget buildEmpty() {
    return Container(
        decoration: BoxDecoration(
            color: ColorsConstants.mint.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  child: Text(S.of(context).empty_feed,
                      textAlign: TextAlign.center,
                      style: TextStyles.paragraphRegular14(Colors.grey)))
            ])));
  }

  Widget buildLikeButton(int index) {
    return Row(
      children: [
        Text(widget.postList[index].likes!.length.toString(),
            style: TextStyles.paragraphRegular14(ColorsConstants.grey)),
        widget.postList[index].likes!.contains(AuthService().getCurrentUserID())
            ? IconButton(
                onPressed: () {
                  widget.postList[index].likes!
                      .remove(AuthService().getCurrentUserID());
                  Provider.of<PostManager>(context, listen: false).likePost(
                      widget.postList[index].reference!,
                      widget.postList[index].createdFor,
                      widget.postList[index].likes!);
                  setState(() {});
                },
                icon: const Icon(
                  Icons.favorite,
                  color: ColorsConstants.darkBrick,
                ))
            : IconButton(
                onPressed: () {
                  widget.postList[index].likes!
                      .add(AuthService().getCurrentUserID());
                  Provider.of<PostManager>(context, listen: false).likePost(
                      widget.postList[index].reference!,
                      widget.postList[index].createdFor,
                      widget.postList[index].likes!);
                  setState(() {});
                  if (AuthService().getCurrentUserID() !=
                      widget.postList[index].createdBy) {
                    CustomNotification notif = CustomNotification(
                        sentFrom: AuthService().getCurrentUserID(),
                        type: NotificationType.LIKE.toString(),
                        creationDate: DateTime.now().millisecondsSinceEpoch);
                    Provider.of<NotificationsManager>(context, listen: false)
                        .addNotificationToFirestore(
                            notif, widget.postList[index].createdBy);
                  }
                },
                icon: const Icon(
                  Icons.favorite_border,
                  color: ColorsConstants.darkBrick,
                ))
      ],
    );
  }
}
