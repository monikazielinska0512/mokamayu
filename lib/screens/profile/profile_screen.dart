import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/screens/screens.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import 'friend_invite_dialog.dart';

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
  Future<List<Post>>? futureUserPosts;
  UserData? userData;
  UserData? friendData;
  Future<UserData?>? currentUser;
  late final bool displaysCurrentUserProfile;

  @override
  void initState() {
    displaysCurrentUserProfile = AuthService().getCurrentUserID() == widget.uid;
    futureUserPosts =
        Provider.of<PostManager>(context, listen: false).getCurrentUserPosts();
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

    if (displaysCurrentUserProfile) {
      futureUserPosts = Provider.of<PostManager>(context, listen: false)
          .getFutureCurrentUserPostList;
    } else {
      futureUserPosts = Provider.of<PostManager>(context, listen: false)
          .getUserPosts(widget.uid!);
    }

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
          onPressed: () => context.pushNamed('friends'),
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
              showDialog(
                  context: context,
                  useSafeArea: false,
                  builder: (BuildContext context) {
                    return FriendDialogBox(friend: friendData!);
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
                      child: buildPosts()),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
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
                return PostSummaryTile(post: postsList.data![index]);
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
}
