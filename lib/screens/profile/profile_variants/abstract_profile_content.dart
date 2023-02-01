import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../generated/l10n.dart';

abstract class AbstractProfileContent extends StatefulWidget {
  final String? uid;

  const AbstractProfileContent({Key? key, required this.uid}) : super(key: key);
}

abstract class AbstractProfileContentState
    extends State<AbstractProfileContent> {
  Future<UserData?>? userDataFuture;
  Future<List<WardrobeItem>>? itemList;
  Future<List<Outfit>>? outfitsList;
  UserData? userData;

  void loadData();

  Widget getLeftButton();

  Widget getRightButton();

  Widget buildButtons();

  Map<String, Widget>? getTabs();

  Widget buildCreateOutfitForFriendButton() => Container();

  double getHeight();

  String getTitle();

  EdgeInsetsGeometry getPadding();

  @override
  Widget build(BuildContext context) {
    userDataFuture = Provider.of<ProfileManager>(context, listen: false)
        .getUserData(widget.uid);

    if (widget.uid != null) {
      itemList = Provider.of<WardrobeManager>(context, listen: false)
          .readWardrobeItemsForUser(widget.uid!);
      outfitsList = Provider.of<OutfitManager>(context, listen: false)
          .readOutfitsForUser(widget.uid!);
    }

    loadData();

    return BasicScreen(
      title: getTitle(),
      leftButton: getLeftButton(),
      rightButton: getRightButton(),
      backgroundColor: Colors.white,
      context: context,
      isFullScreen: true,
      body: Stack(children: [
        const BackgroundImage(
            opacity: 0.4,
            imagePath: "assets/images/mountains.png",
            imageShift: 390),
        Positioned(
          bottom: 0,
          child: BackgroundCard(
            context: context,
            height: getHeight(),
            child: Padding(
                padding: getPadding(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: buildUserCard(context)),
                    !(userData?.privateProfile ?? true) ||
                            Provider.of<FriendsManager>(context, listen: false)
                                .isMyFriend(widget.uid)
                        ? buildProfileGallery(context)
                        : userData?.reference !=
                                AuthService().getCurrentUserID()
                            ? EmptyScreen(
                                context,
                                Text(S.of(context).private,
                                    style:
                                        TextStyles.paragraphRegularSemiBold14(
                                            Colors.grey)),
                                Colors.grey,
                                icon: Ionicons.lock_closed_outline)
                            : buildProfileGallery(context)
                  ],
                )),
          ),
        ),
        buildCreateOutfitForFriendButton(),
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
                width: MediaQuery.of(context).size.width * 0.95,
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: ColorsConstants.whiteAccent),
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              // Image border
                              child: SizedBox.fromSize(
                                size: const Size.square(85),
                                child: snapshot.data?.profilePicture != null
                                    ? ExtendedImage.network(
                                        snapshot.data!.profilePicture!,
                                        fit: BoxFit.fill,
                                        cacheWidth: 110 *
                                            window.devicePixelRatio.ceil(),
                                        cacheHeight: 110 *
                                            window.devicePixelRatio.ceil(),
                                        cache: true,
                                        enableMemoryCache: false,
                                        enableLoadState: true,
                                      )
                                    : Image.asset(Assets.avatarPlaceholder,
                                        fit: BoxFit.fill),
                              ),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              snapshot.data?.profileName ??
                                  snapshot.data?.username ??
                                  'Profile name',
                              style: TextStyles.h4()),
                          Text('@${snapshot.data?.username ?? 'username'}',
                              style: TextStyles.paragraphRegular16(
                                  ColorsConstants.grey)),
                          buildButtons(),
                        ],
                      ),
                    )
                  ],
                ),
              );
            })));
  }

  Widget buildProfileGallery(BuildContext context) {
    List<Tab>? tabs = getTabs()
        ?.keys
        .map((label) => Tab(child: Text(label, textAlign: TextAlign.center)))
        .toList();
    return tabs == null
        ? Container()
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
              child: DefaultTabController(
                length: tabs.length,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: TabBar(
                          indicatorPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  ColorsConstants.turquoise.withOpacity(0.3)),
                          labelStyle: TextStyles.paragraphRegularSemiBold14(),
                          labelColor: ColorsConstants.turquoise,
                          unselectedLabelColor: ColorsConstants.grey,
                          tabs: tabs,
                        )),
                    Expanded(
                      child: TabBarView(
                        children: getTabs()!
                            .values
                            .map((widget) => Padding(
                                padding: const EdgeInsets.all(1),
                                child: widget))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
