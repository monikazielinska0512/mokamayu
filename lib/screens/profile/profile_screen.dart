import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import '../social/post_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<UserData?>? userDataFuture;
  Future<List<WardrobeItem>>? itemList;
  Future<List<Outfit>>? outfitsList;
  UserData? userData;
  UserData? friendData;
  Future<UserData?>? currentUser;
  late final bool displaysCurrentUserProfile;

  @override
  void initState() {
    displaysCurrentUserProfile = AuthService().getCurrentUserID() == widget.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userDataFuture = Provider.of<ProfileManager>(context, listen: false)
        .getUserData(widget.uid);
    Provider.of<ProfileManager>(context, listen: true)
        .getUserData(widget.uid)
        .then((UserData? temp) {
      setState(() => friendData = temp);
    });
    currentUser = Provider.of<ProfileManager>(context, listen: false)
        .getCurrentUserData();

    if (widget.uid != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
            itemList = Provider.of<WardrobeManager>(context, listen: false)
                .readWardrobeItemsForUser(widget.uid!);
            outfitsList = Provider.of<OutfitManager>(context, listen: false)
                .readOutfitsForUser(widget.uid!);
          }));
    }

    return BasicScreen(
      type: "profile",
      leftButtonType: displaysCurrentUserProfile ? "dots" : "back",
      context: context,
      isFullScreen: true,
      body: Stack(children: [
        const BackgroundImage(
            imagePath: "assets/images/mountains.png", imageShift: 160),
        Positioned(
          bottom: 0,
          child: BackgroundCard(
            context: context,
            height: 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildUserCard(context),
                buildProfileGallery(context),
              ],
            ),
          ),
        ),
        if (!displaysCurrentUserProfile) ...[buildFloatingButton()],
      ]),
    );
  }

  Widget buildUserCard(BuildContext context) {
    return Consumer<ProfileManager>(
        builder: (context, manager, _) => (FutureBuilder<UserData?>(
            future: userDataFuture,
            builder: (context, snapshot) {
              userData = snapshot.data;
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(25, 20, 5, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Image border
                      child: SizedBox.fromSize(
                        size: const Size.square(110),
                        child: snapshot.data?.profilePicture != null
                            ? Image.network(snapshot.data!.profilePicture!,
                                fit: BoxFit.fill)
                            : Image.asset(Assets.avatarPlaceholder,
                                fit: BoxFit.fill),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 235,
                      padding: const EdgeInsets.fromLTRB(15, 15, 5, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                              snapshot.data?.profileName ??
                                  snapshot.data?.username ??
                                  'Profile name',
                              style: TextStyles.h5()),
                          Text('@${snapshot.data?.username ?? 'username'}',
                              style: TextStyles.paragraphRegular16(
                                  ColorsConstants.grey)),
                          buildButtons(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })));
  }

  Widget buildButtons() {
    if (displaysCurrentUserProfile) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        IconTextButton(
          onPressed: () => context.push('/edit-profile'),
          icon: Icons.edit_outlined,
          text: "Edit",
          backgroundColor: ColorsConstants.peachy,
        ),
        IconTextButton(
          onPressed: () => context.goNamed('friends'),
          icon: Icons.person_outline_outlined,
          text: "Friends",
          backgroundColor: ColorsConstants.mint,
        ),
      ]);
    } else {
      return friendData != null
          ? friendshipButton()
          : IconTextButton(
              onPressed: () => print('nie ma danych :c'),
              icon: Icons.person_outline_outlined,
              text: "Nope",
              backgroundColor: ColorsConstants.mint,
            );
    }
  }

  Widget friendshipButton() {
    switch (Provider.of<ProfileManager>(context, listen: true)
        .getFriendshipStatus(friendData!.uid)) {
      case "FriendshipState.FRIENDS":
        {
          return IconTextButton(
            onPressed: () {
              print("Remove");
              Provider.of<ProfileManager>(context, listen: false)
                  .removeFriend(friendData!);
            },
            icon: Icons.check,
            text: "Friends",
            backgroundColor: ColorsConstants.mint,
          );
        }
      case "FriendshipState.INVITE_PENDING":
        {
          return IconTextButton(
            onPressed: () {
              print("cancel");
              Provider.of<ProfileManager>(context, listen: false)
                  .cancelFriendInvite(friendData!);
            },
            icon: Icons.outgoing_mail,
            text: "Sent",
            backgroundColor: ColorsConstants.mint,
          );
        }
      case "FriendshipState.RECEIVED_INVITE":
        {
          return IconTextButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext buildContext) {
                    return SafeArea(
                      child: Wrap(children: [
                        buildOption(
                            buildContext,
                            const Icon(Icons.check_circle_outline_rounded),
                            "Accept invite",
                            friendData!),
                        buildOption(
                            buildContext,
                            const Icon(Icons.highlight_remove_rounded),
                            "Reject invite",
                            friendData!),
                      ]),
                    );
                  });
            },
            icon: Icons.mark_email_unread,
            text: "Respond",
            backgroundColor: ColorsConstants.mint,
          );
        }
      default:
        {
          return IconTextButton(
            onPressed: () {
              print("send");
              Provider.of<ProfileManager>(context, listen: false)
                  .sendFriendInvite(friendData!);
            },
            icon: Icons.person_outline_outlined,
            text: "Add friend",
            backgroundColor: ColorsConstants.mint,
          );
        }
    }
  }

  Widget buildProfileGallery(BuildContext context) {
    List<Tab> tabs = <Tab>[
      Tab(text: S.of(context).wardrobe),
      Tab(text: S.of(context).outfits),
      Tab(text: S.of(context).posts),
    ];
    Future<List<Post>> userPosts =
        Provider.of<PostManager>(context, listen: false)
            .getUserPosts(widget.uid!);
    return Expanded(
      child: DefaultTabController(
        length: tabs.length,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TabBar(
                indicatorColor: ColorsConstants.darkBrick,
                labelStyle: TextStyles.paragraphRegular16(),
                labelColor: ColorsConstants.darkBrick,
                unselectedLabelColor: ColorsConstants.grey,
                tabs: tabs,
              ),
              Expanded(
                child: TabBarView(children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: PhotoGrid(itemList: itemList)),
                  Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: PhotoGrid(outfitsList: outfitsList)),
                  Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: FutureBuilder<List<Post>>(
                        future: userPosts,
                        builder: (context, snapshot) {
                          return buildPosts(snapshot.data!);
                        },
                      ))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TODO: move it to a separate widget
  Widget buildPosts(List<Post> postsList) {
    final commentController = TextEditingController();
    return ListView.separated(
      itemCount: postsList.length,
      separatorBuilder: (context, _) => const SizedBox(height: 20),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
              color: ColorsConstants.whiteAccent,
              borderRadius: BorderRadius.circular(20)),
          child: FutureBuilder<UserData?>(
            future: Provider.of<ProfileManager>(context, listen: false)
                .getUserData(postsList[index].createdBy),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.square(50),
                          child: postAuthor?.profilePicture != null
                              ? Image.network(postAuthor!.profilePicture!,
                                  fit: BoxFit.fill)
                              : Image.asset(Assets.avatarPlaceholder,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              postAuthor?.profileName ??
                                  postAuthor?.username ??
                                  "Post author",
                              style: TextStyles.paragraphRegularSemiBold16()),
                          Text(
                              "Posted ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(postsList[index].creationDate))}",
                              style: TextStyles.paragraphRegular14(
                                  ColorsConstants.grey)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(postsList[index].likes!.length.toString(),
                              style: TextStyles.paragraphRegular14(
                                  ColorsConstants.grey)),
                          postAuthor?.uid != AuthService().getCurrentUserID()
                              ? postsList[index].likes!.contains(
                                      AuthService().getCurrentUserID())
                                  ? IconButton(
                                      onPressed: () {
                                        postsList[index].likes!.remove(
                                            AuthService().getCurrentUserID());
                                        Provider.of<PostManager>(context,
                                                listen: false)
                                            .likePost(
                                                postsList[index].reference!,
                                                postsList[index].createdBy,
                                                postsList[index].likes!);
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.favorite,
                                          color: ColorsConstants.darkBrick))
                                  : IconButton(
                                      onPressed: () {
                                        postsList[index].likes!.add(
                                            AuthService().getCurrentUserID());
                                        Provider.of<PostManager>(context,
                                                listen: false)
                                            .likePost(
                                                postsList[index].reference!,
                                                postsList[index].createdBy,
                                                postsList[index].likes!);
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.favorite_border,
                                          color: ColorsConstants.darkBrick))
                              : const Icon(Icons.favorite_border,
                                  color: ColorsConstants.darkBrick),
                        ],
                      ),
                    ],
                  ),
                  Image.network(postsList[index].cover, fit: BoxFit.fill),
                  TextField(
                    controller: commentController,
                    onSubmitted: (String comment) {
                      print("add comment");
                      postsList[index].comments!.add({
                        "author": AuthService().getCurrentUserID(),
                        "content": comment
                      });
                      Provider.of<PostManager>(context, listen: false)
                          .commentPost(
                              postsList[index].reference!,
                              postsList[index].createdBy,
                              postsList[index].comments!);
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
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => PostScreen(
                                  post: postsList[index],
                                  user: postAuthor!,
                                  userList: const [])));
                    },
                    child: Text(" View all comments",
                        style: TextStyles.paragraphRegular12(
                            ColorsConstants.darkBrick)),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget buildFloatingButton() {
    return FloatingButton(
        onPressed: () {
          Provider.of<PhotoTapped>(context, listen: false).nullWholeMap();
          Provider.of<WardrobeManager>(context, listen: false)
              .resetBeforeCreatingNewOutfit();
          context.pushNamed("create-outfit-page",
              extra: itemList!, queryParams: {'friendUid': widget.uid});
        },
        icon: const Icon(Ionicons.body),
        backgroundColor: ColorsConstants.darkBrick,
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
        alignment: Alignment.bottomRight);
  }

  Widget buildOption(
      BuildContext context, Icon icon, String title, UserData friend) {
    return ListTile(
        leading: icon,
        title: Text(title),
        onTap: () {
          if (title == "Reject invite") {
            print("reject");
            Provider.of<ProfileManager>(context, listen: false)
                .rejectFriendInvite(friend);
          } else {
            //accept
            print("accept");
            Provider.of<ProfileManager>(context, listen: false)
                .acceptFriendInvite(friend);
          }
          Navigator.of(context).pop();
        });
  }
}
