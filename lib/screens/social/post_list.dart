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

class PostList extends StatefulWidget {
   
  final List<UserData> userList;

  const PostList({
    Key? key,
    required this.userList,
  }) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late List<Post> postList;
  late List<TextEditingController> myController;



  @override
  Widget build(BuildContext context) {
    postList = Provider.of<PostManager>(context, listen: true).finalPostList;
    myController =
        List.generate(postList.length, (_) => TextEditingController());
    return postList.isNotEmpty ? buildFeed(context) : buildEmpty();
    return buildEmpty();
  }

  Widget buildFeed(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
                color: ColorsConstants.whiteAccent,
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.square(50),
                          child: widget.userList
                                      .singleWhere((element) =>
                                          element.uid ==
                                          postList[index].createdBy)
                                      .profilePicture !=
                                  null
                              ? Image.network(
                                  widget.userList
                                      .singleWhere((element) =>
                                          element.uid ==
                                          postList[index].createdBy)
                                      .profilePicture!,
                                  fit: BoxFit.fill)
                              : Image.asset(Assets.avatarPlaceholder,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          postList[index].createdFor ==
                                  postList[index].createdBy
                              ? GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                      "profile",
                                      queryParams: {
                                        'uid': postList[index].createdBy,
                                      },
                                    );
                                  },
                                  child: Text(
                                      widget.userList
                                                  .singleWhere((element) =>
                                                      element.uid ==
                                                      postList[index]
                                                          .createdBy)
                                                  .profileName !=
                                              null
                                          ? widget.userList
                                              .singleWhere((element) =>
                                                  element.uid ==
                                                  postList[index]
                                                      .createdBy)
                                              .profileName!
                                          : widget.userList
                                              .singleWhere((element) =>
                                                  element.uid ==
                                                  postList[index]
                                                      .createdBy)
                                              .username,
                                      style: TextStyles
                                          .paragraphRegularSemiBold16()),
                                )
                              : Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        context.pushNamed(
                                          "profile",
                                          queryParams: {
                                            'uid': postList[index].createdBy,
                                          },
                                        );
                                      },
                                      child: Text(
                                          widget.userList
                                                      .singleWhere((element) =>
                                                          element.uid ==
                                                          postList[index]
                                                              .createdBy)
                                                      .profileName !=
                                                  null
                                              ? widget.userList
                                                  .singleWhere((element) =>
                                                      element.uid ==
                                                      postList[index]
                                                          .createdBy)
                                                  .profileName!
                                              : widget.userList
                                                  .singleWhere((element) =>
                                                      element.uid ==
                                                      postList[index]
                                                          .createdBy)
                                                  .username,
                                          style: TextStyles
                                              .paragraphRegularSemiBold16()),
                                    ),
                                    Text(" for ",
                                        style: TextStyles.paragraphRegular16()),
                                    GestureDetector(
                                      onTap: () {
                                        context.pushNamed(
                                          "profile",
                                          queryParams: {
                                            'uid': postList[index].createdFor,
                                          },
                                        );
                                      },
                                      child: Text(
                                          widget.userList
                                                      .singleWhere((element) =>
                                                          element.uid ==
                                                          postList[index]
                                                              .createdFor)
                                                      .profileName !=
                                                  null
                                              ? widget.userList
                                                  .singleWhere((element) =>
                                                      element.uid ==
                                                      postList[index]
                                                          .createdFor)
                                                  .profileName!
                                              : widget.userList
                                                  .singleWhere((element) =>
                                                      element.uid ==
                                                      postList[index]
                                                          .createdFor)
                                                  .username,
                                          style: TextStyles
                                              .paragraphRegularSemiBold16()),
                                    ),
                                  ],
                                ),
                          Text(
                              "Posted ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(postList[index].creationDate))}",
                              style: TextStyles.paragraphRegular14(
                                  ColorsConstants.grey)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(postList[index].likes!.length.toString(),
                              style: TextStyles.paragraphRegular14(
                                  ColorsConstants.grey)),
                          postList[index].likes!
                                  .contains(AuthService().getCurrentUserID())
                              ? IconButton(
                                  onPressed: () {
                                    postList[index].likes!.remove(
                                        AuthService().getCurrentUserID());
                                    Provider.of<PostManager>(context,
                                            listen: false)
                                        .likePost(
                                            postList[index].reference!,
                                            postList[index].createdFor,
                                            postList[index].likes!);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: ColorsConstants.darkBrick,
                                  ))
                              : IconButton(
                                  onPressed: () {
                                    postList[index].likes!
                                        .add(AuthService().getCurrentUserID());
                                    Provider.of<PostManager>(context,
                                            listen: false)
                                        .likePost(
                                            postList[index].reference!,
                                            postList[index].createdFor,
                                            postList[index].likes!);
                                    setState(() {});
                                    if (AuthService().getCurrentUserID() !=
                                        postList[index].createdBy) {
                                      CustomNotification notif =
                                          CustomNotification(
                                              sentFrom: AuthService()
                                                  .getCurrentUserID(),
                                              type: NotificationType
                                                  .LIKE
                                                  .toString(),
                                              creationDate: DateTime.now()
                                                  .millisecondsSinceEpoch);
                                      Provider.of<NotificationsManager>(context,
                                              listen: false)
                                          .addNotificationToFirestore(notif,
                                              postList[index].createdBy);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.favorite_border,
                                    color: ColorsConstants.darkBrick,
                                  ))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  ExtendedImage.network(
                    postList[index].cover,
                    fit: BoxFit.fill,
                    cache: true,
                    enableMemoryCache: false,
                    enableLoadState: true,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  TextField(
                    controller: myController[index],
                    onSubmitted: (String comment) {
                      print("add comment");
                      postList[index].comments!.add({
                        "author": AuthService().getCurrentUserID(),
                        "content": comment
                      });
                      Provider.of<PostManager>(context, listen: false)
                          .commentPost(
                              postList[index].reference!,
                              postList[index].createdFor,
                              postList[index].comments!);
                      myController[index].clear();
                      setState(() {});
                      if (AuthService().getCurrentUserID() !=
                          postList[index].createdBy) {
                        CustomNotification notif = CustomNotification(
                            sentFrom: AuthService().getCurrentUserID(),
                            type: NotificationType.COMMENT.toString(),
                            creationDate:
                                DateTime.now().millisecondsSinceEpoch);
                        Provider.of<NotificationsManager>(context,
                                listen: false)
                            .addNotificationToFirestore(
                                notif, postList[index].createdBy);
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Comment post",
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
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => PostScreen(
                                    post: postList[index],
                                    user: widget.userList.singleWhere(
                                        (element) =>
                                            element.uid ==
                                            postList[index].createdBy),
                                    userList: widget.userList,
                                  )));
                    },
                    child: Text(
                      " View comments",
                      style: TextStyles.paragraphRegular12(
                          ColorsConstants.darkBrick),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: postList.length);
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
}
