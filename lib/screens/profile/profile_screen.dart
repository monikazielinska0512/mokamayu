import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:mokamayu/services/managers/outfit_manager.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import '../../widgets/fundamental/background_card.dart';
import '../../widgets/photo/photo_grid.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<UserData?>? userData;
  Future<List<WardrobeItem>>? itemList;
  Future<List<Outfit>>? outfitsList;

  @override
  void initState() {
    print('PROFILE');
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<ProfileManager>(context, listen: false)
        .getUserData(widget.user);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          itemList = Provider.of<WardrobeManager>(context, listen: false)
              .getWardrobeItemList;
          outfitsList =
              Provider.of<OutfitManager>(context, listen: false).getOutfitList;
        }));
    return BasicScreen(
      type: "",
      leftButtonType: "dots",
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
                buildUserCard(context, widget.user),
                buildProfileGallery(context),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildUserCard(BuildContext context, User? user) {
    return Consumer<ProfileManager>(
        builder: (context, manager, _) => (FutureBuilder<UserData?>(
            future: userData,
            builder: (context, snapshot) {
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
                      width: 237,
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
    if (AuthService().getCurrentUserID() == widget.user?.uid) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        IconTextButton(
          onPressed: () {
            context.push('/edit-profile');
          },
          icon: Icons.edit_outlined,
          text: "Edit",
          backgroundColor: ColorsConstants.peachy,
        ),
        IconTextButton(
          onPressed: () => print('friends list'),
          icon: Icons.person_outline_outlined,
          text: "Friends",
          backgroundColor: ColorsConstants.mint,
        ),
      ]);
    } else {
      return IconTextButton(
        onPressed: () => print('friends list'),
        icon: Icons.person_outline_outlined,
        text: "Add friend",
        backgroundColor: ColorsConstants.mint,
      );
    }
  }

  Widget buildProfileGallery(BuildContext context) {
    List<Tab> tabs = <Tab>[
      Tab(text: S.of(context).wardrobe),
      Tab(text: S.of(context).outfits),
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
                      child: PhotoGrid(outfitsList: outfitsList))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
