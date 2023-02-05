import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../services/authentication/auth.dart';
import '../../services/managers/managers.dart';
import '../../utils/string_extensions.dart';

//ignore: must_be_immutable
class PostScreen extends StatefulWidget {
  Post post;
  UserData user;
  List<UserData> userList;

  PostScreen({
    Key? key,
    required this.post,
    required this.user,
    required this.userList,
  }) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  @override
  Widget build(BuildContext context) {
    if (widget.userList.isEmpty) {
      widget.userList =
          Provider.of<UserListManager>(context, listen: false).getUserList;
    }
    return BasicScreen(
        context: context,
        title: "",
        rightButton: null,
        leftButton: BackArrowButton(context),
        resizeToAvoidBottomInset: true,
        isFullScreen: true,
        body: Stack(children: [
          const BackgroundImage(
            imagePath: "assets/images/full_background.png",
            imageShift: 200,
            opacity: 0.5,
          ),
          Positioned(
            bottom: 0,
            child: BackgroundCard(
              context: context,
              height: 0.87,
              child: Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.only(top: 30, right: 25, left: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildHeader(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: ColorsConstants.whiteAccent,
                                    borderRadius: BorderRadius.circular(12)),
                                child: buildPost())
                          ]),
                      widget.post.createdFor != widget.post.createdBy
                          ? buildDate()
                          : Container(),
                      buildCommentList(),
                      buildCommentField()
                    ],
                  )),
            ),
          ),
        ]));
  }

  Widget buildHeader() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildUserAvatar(),
            const Padding(padding: EdgeInsets.only(left: 10)),
            buildName()
          ]),
      buildLikeButton()
    ]);
  }

  Widget buildName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.post.createdFor == widget.post.createdBy
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [buildPostingUser(), buildDate()])
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildPostingUser(),
                  Row(children: [
                    Text("Stworzono przez ",
                        style: TextStyles.paragraphRegular12(Colors.grey),
                        textAlign: TextAlign.start),
                    buildCreator(),
                  ])
                ],
              ),
      ],
    );
  }

  Widget buildUserAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5), // Image border
      child: SizedBox.fromSize(
        size: const Size.square(50),
        child: widget.userList
                    .singleWhere(
                        (element) => element.uid == widget.post.createdFor)
                    .profilePicture !=
                null
            ? Image.network(
                widget.userList
                    .singleWhere(
                        (element) => element.uid == widget.post.createdFor)
                    .profilePicture!,
                fit: BoxFit.fill)
            : Image.asset(Assets.avatarPlaceholder,
                width: MediaQuery.of(context).size.width * 0.7),
      ),
    );
  }

  Widget buildCreator() {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          "profile",
          queryParams: {
            'uid': widget.post.createdBy,
          },
        );
      },
      child: Text(
          widget.userList
                      .singleWhere(
                          (element) => element.uid == widget.post.createdBy)
                      .profileName !=
                  null
              ? widget.userList
                  .singleWhere(
                      (element) => element.uid == widget.post.createdBy)
                  .profileName!
              : widget.userList
                  .singleWhere(
                      (element) => element.uid == widget.post.createdBy)
                  .username,
          style: TextStyles.paragraphRegular14(ColorsConstants.darkBrick)),
    );
  }

  Widget buildPostingUser() {
    return GestureDetector(
        onTap: () {
          context.pushNamed(
            "profile",
            queryParams: {
              'uid': widget.post.createdFor,
            },
          );
        },
        child: Text(
            widget.userList
                        .singleWhere(
                            (element) => element.uid == widget.post.createdFor)
                        .profileName !=
                    null
                ? widget.userList
                    .singleWhere(
                        (element) => element.uid == widget.post.createdFor)
                    .profileName!
                    .capitalize()
                : widget.userList
                    .singleWhere(
                        (element) => element.uid == widget.post.createdFor)
                    .username
                    .capitalize(),
            style: TextStyles.paragraphRegularSemiBold16()));
  }

  Widget buildDate() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5, top: 10),
        child: Text(
            "Posted ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.post.creationDate))}",
            style: TextStyles.paragraphRegular12(ColorsConstants.grey)));
  }

  Widget buildLikeButton() {
    return Row(
      children: [
        Text(widget.post.likes!.length.toString(),
            style: TextStyles.paragraphRegular14(ColorsConstants.grey)),
        widget.post.likes!.contains(AuthService().getCurrentUserID())
            ? IconButton(
                onPressed: () {
                  widget.post.likes!.remove(AuthService().getCurrentUserID());
                  Provider.of<PostManager>(context, listen: false).likePost(
                      widget.post.reference!,
                      widget.post.createdFor,
                      widget.post.likes!);
                  setState(() {});
                },
                icon: const Icon(
                  Icons.favorite,
                  color: ColorsConstants.darkBrick,
                ))
            : IconButton(
                onPressed: () {
                  widget.post.likes!.add(AuthService().getCurrentUserID());
                  Provider.of<PostManager>(context, listen: false).likePost(
                      widget.post.reference!,
                      widget.post.createdFor,
                      widget.post.likes!);
                  setState(() {});
                  if (AuthService().getCurrentUserID() !=
                      widget.post.createdBy) {
                    CustomNotification notif = CustomNotification(
                        sentFrom: AuthService().getCurrentUserID(),
                        type: NotificationType.COMMENT.toString(),
                        creationDate: DateTime.now().millisecondsSinceEpoch);
                    Provider.of<NotificationsManager>(context, listen: false)
                        .addNotificationToFirestore(
                            notif, widget.post.createdBy);
                  }
                },
                icon: const Icon(
                  Icons.favorite_border,
                  color: ColorsConstants.darkBrick,
                ))
      ],
    );
  }

  Widget buildPost() {
    return Image.network(widget.post.cover, fit: BoxFit.fill);
  }

  Widget buildCommentList() {
    return widget.post.comments!.isNotEmpty
        ? Expanded(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: widget.userList
                                              .singleWhere((element) =>
                                                  element.uid ==
                                                  widget.post.comments![index]
                                                      ['author']!)
                                              .profilePicture !=
                                          null
                                      ? Image.network(
                                          widget.userList
                                              .singleWhere((element) =>
                                                  element.uid ==
                                                  widget.post.comments![index]
                                                      ['author']!)
                                              .profilePicture!,
                                          height: 25)
                                      : Image.asset(Assets.avatarPlaceholder,
                                          height: 20),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          widget.userList
                                                      .singleWhere((element) =>
                                                          element.uid ==
                                                          widget.post.comments![
                                                              index]['author']!)
                                                      .profileName !=
                                                  null
                                              ? widget.userList
                                                  .singleWhere((element) =>
                                                      element.uid ==
                                                      widget.post.comments![index]
                                                          ['author']!)
                                                  .profileName!
                                              : widget.userList
                                                  .singleWhere((element) =>
                                                      element.uid ==
                                                      widget.post.comments![index]
                                                          ['author']!)
                                                  .username,
                                          style:
                                              TextStyles.paragraphRegularSemiBold14()),
                                      Text(
                                        widget.post.comments![index]
                                            ['content']!,
                                        style: TextStyles.paragraphRegular14(),
                                      )
                                    ]),
                              ]),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemCount: widget.post.comments!.length)))
        : EmptyScreen(
            context,
            Text("Ten post nie ma komentarzy",
                style: TextStyles.paragraphRegular12(Colors.grey)),
            ColorsConstants.grey);

  }

  Widget buildCommentField() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15, top: 10),
        child: TextField(
          controller: widget.post.textController,
          decoration: InputDecoration(
            hintText: S.of(context).comment,
            filled: true,
            fillColor: ColorsConstants.whiteAccent,
            suffixIcon: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded,
                  color: ColorsConstants.darkBrick),
              onPressed: () {
                if (widget.post.textController!.text != "") {
                  widget.post.comments!.add({
                    "author": AuthService().getCurrentUserID(),
                    "content": widget.post.textController!.text
                  });
                  Provider.of<PostManager>(context, listen: false).commentPost(
                      widget.post.reference!,
                      widget.post.createdFor,
                      widget.post.comments!);
                  widget.post.textController!.clear();
                  setState(() {});
                }

                if (AuthService().getCurrentUserID() != widget.post.createdBy) {
                  CustomNotification notif = CustomNotification(
                      sentFrom: AuthService().getCurrentUserID(),
                      type: NotificationType.COMMENT.toString(),
                      creationDate: DateTime.now().millisecondsSinceEpoch);
                  Provider.of<NotificationsManager>(context, listen: false)
                      .addNotificationToFirestore(notif, widget.post.createdBy);
                }
                CustomSnackBar.showSuccessSnackBar(
                    context: context, message: "Dodano komentarz"
                );
              },
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
        ));
  }
}
