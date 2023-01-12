import 'package:flutter/material.dart';
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

  Color? setBackgroundColor() => Colors.transparent;

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
      title: S.of(context).profile,
      leftButton: getLeftButton(),
      rightButton: getRightButton(),
      backgroundColor: setBackgroundColor(),
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
            height: 0.79,
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildUserCard(context),
                    buildProfileGallery(context),
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
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                        padding: EdgeInsets.only(top:10, bottom: 10),
                        child: TabBar(
                          indicatorPadding: EdgeInsets.symmetric(vertical: 0),
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorsConstants.turquoise.withOpacity(0.3)),
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
