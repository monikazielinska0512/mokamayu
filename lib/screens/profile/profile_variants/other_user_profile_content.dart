import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/screens/screens.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/buttons/predefined_buttons.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../generated/l10n.dart';

class OtherUserProfileContent extends AbstractProfileContent {
  const OtherUserProfileContent({Key? key, required String? uid})
      : super(key: key, uid: uid);

  @override
  AbstractProfileContentState createState() => _OtherUserProfileContentState();
}



class _OtherUserProfileContentState extends AbstractProfileContentState {
  UserData? friendData;

  @override
  Color? setBackgroundColor() => Colors.transparent;

  @override
  void loadData() {
    Provider.of<ProfileManager>(context, listen: true)
        .getUserData(widget.uid)
        .then((UserData? temp) {
      setState(() => friendData = temp);
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<WardrobeManager>(context, listen: false)
          .setFriendWardrobeItemList(itemList!);
    });
  }

  @override
  Widget getLeftButton() => BackArrowButton(context);

  @override
  Widget getRightButton() => NotificationsButton(context);

  @override
  Widget buildButtons() => friendData != null
      ? friendshipButton()
      : IconTextButton(
          onPressed: () => print('nie ma danych :c'),
          icon: Icons.person_outline_outlined,
          text: "No data",
          backgroundColor: ColorsConstants.mint,
        );

  Widget friendshipButton() {
    switch (Provider.of<ProfileManager>(context, listen: true)
        .getFriendshipStatus(friendData!.uid)) {
      case "FriendshipState.FRIENDS":
        {
          return IconTextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  useSafeArea: false,
                  builder: (BuildContext context) {
                    return FriendDialogBox(friend: friendData!, isResponse: false,);
                  });
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
                    return FriendDialogBox(friend: friendData!, isResponse: true,);
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

  @override
  Map<String, Widget>? getTabs() {
    bool eligibleToSeeProfile = !(userData?.privateProfile ?? true) ||
        Provider.of<FriendsManager>(context, listen: false)
            .isMyFriend(widget.uid);
    return eligibleToSeeProfile
        ? {
            S.of(context).wardrobe: PhotoGrid(itemList: itemList),
            S.of(context).outfits: PhotoGrid(outfitsList: outfitsList),
          }
        : null;
  }

  @override
  Widget buildCreateOutfitForFriendButton() {
    return Provider.of<FriendsManager>(context, listen: false)
            .isMyFriend(widget.uid)
        ? FloatingButton(
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
            alignment: Alignment.bottomRight)
        : Container();
  }

}
