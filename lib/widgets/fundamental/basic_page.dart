import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import '../../constants/text_styles.dart';
import '../../generated/l10n.dart';
import '../buttons/icon_button.dart';

class BasicScreen extends StatelessWidget {
  BuildContext context;
  Widget body;
  Color? backgroundColor;
  String type;
  bool? isAppBarVisible;
  bool? isNavBarVisible = true;
  bool isRightButtonVisible = true;
  String? leftButtonType = "back";
  String? rightButtonType = "bell";
  bool? isFullScreen;
  bool? isEdit;
  Color? color;
  Widget? leftButton;
  Widget? rightButton;
  void Function()? onPressed;

  BasicScreen({
    Key? key,
    required this.context,
    required this.body,
    required this.type,
    this.isEdit = false,
    this.color = Colors.black,
    this.isFullScreen = false,
    this.isAppBarVisible = true,
    this.isRightButtonVisible = true,
    this.onPressed,
    this.isNavBarVisible = true,
    this.rightButtonType = "bell",
    this.backgroundColor = Colors.white,
    this.leftButton,
    this.rightButton
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: isAppBarVisible!
            ? AppBar(
                title: buildPageTitle(),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                foregroundColor: color,
                elevation: 0,
                actions: [
                  // rightButton ?? Container()
                  isRightButtonVisible
                          ? buildRightIconButton()
                          : Container()
                ],
                leading:
                    leftButton ?? Container()
        )
            : null,
        body: Center(
            child: isFullScreen!
                ? SafeArea(bottom: false, top: false, child: body)
                : SafeArea(
                    bottom: false,
                    child: Padding(
                        padding: const EdgeInsets.all(16), child: body))));
  }

  Widget buildPageTitle() {
    switch (type) {
      case "friend-requests":
        return Text(S.of(context).friends_request,
            style: TextStyles.appTitle(Colors.black));
      case "wardrobe":
        return Text(S.of(context).wardrobe_page_title,
            style: TextStyles.appTitle(Colors.black));
      case "outfits":
        return Text(S.of(context).outfits,
            style: TextStyles.appTitle(Colors.black));
      case "friends":
        return Text(S.of(context).friends,
            style: TextStyles.appTitle(Colors.black));
      case "add_photo":
        return Text("", style: TextStyles.appTitle(Colors.black));
      case "outfit-create":
        return Text(S.of(context).create,
            style: TextStyles.appTitle(Colors.black));
      case "Wardrobe Item Form":
        return Text("", style: TextStyles.appTitle(Colors.black));
      case "wardrobe-item-search":
        return Text("", style: TextStyles.appTitle(Colors.black));
      case "social":
        return Text(S.of(context).social,
            style: TextStyles.appTitle(Colors.black));
    }
    return Text(type, style: TextStyles.appTitle(Colors.black));
  }

  Widget buildRightIconButton() {
    switch (rightButtonType) {
      case "bell":
        return CustomIconButton(
            onPressed: () => context.push('/notifications'),
            icon: Ionicons.notifications_outline,
            backgroundColor: Colors.transparent,
            iconColor: Colors.black);
      case "go_forward":
        return IconButton(
          color: Colors.black,
          onPressed: onPressed,
          icon: const Icon(
            Icons.arrow_forward_ios,
          ),
        );
      case "add":
        return IconButton(
          color: Colors.black,
          iconSize: 30,
          onPressed: onPressed,
          icon: const Icon(
            Icons.add,
          ),
        );
      case "search":
        return CustomIconButton(onPressed: () {}, icon: Icons.search);
      case "bin":
        return CustomIconButton(onPressed: () {}, icon: Icons.delete);
      case "search-notif":
        switch (type) {
          case "social":
            return Row(children: [
              CustomIconButton(
                  onPressed: () => context.push('/find-users'),
                  icon: Icons.search,
                  backgroundColor: Colors.transparent,
                  iconColor: Colors.grey),
              CustomIconButton(
                  onPressed: () => context.push('/notifications'),
                  icon: Icons.notifications,
                  backgroundColor: Colors.transparent,
                  iconColor: Colors.grey)
            ]);
        }
    }
    return Container();
  }
}
