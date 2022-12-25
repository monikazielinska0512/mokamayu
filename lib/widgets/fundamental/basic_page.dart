import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/text_styles.dart';
import '../buttons/icon_button.dart';

class BasicScreen extends StatelessWidget {
  BuildContext context;
  Widget body;
  Color? backgroundColor;
  String type;
  bool? isAppBarVisible;
  bool? isNavBarVisible = true;
  bool? isLeftButtonVisible = true;
  bool isRightButtonVisible = true;
  String? leftButtonType = "back";
  String? rightButtonType = "bell";
  bool? isFullScreen;
  bool? isEdit;
  Color? color;
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
    this.isLeftButtonVisible = true,
    this.isRightButtonVisible = true,
    this.onPressed,
    this.isNavBarVisible = true,
    this.leftButtonType = "back",
    this.rightButtonType = "bell",
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: isAppBarVisible!
            ? AppBar(
                title: buildPageTitle(),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                foregroundColor: color,
                elevation: 0,
                actions: [
                  if (isRightButtonVisible) ...[buildRightIconButton()]
                ],
                leading: (leftButtonType == "back")
                    ? buildLeftBackButton()
                    : (leftButtonType == "dots")
                        ? buildDotsButton(context)
                        : null)
            : null,
        body: Center(
            child: isFullScreen!
                ? SafeArea(bottom: false, top: false, child: body)
                : SafeArea(
                    bottom: false,
                    child: Padding(
                        padding: const EdgeInsets.all(16), child: body))));
  }

  Widget buildDotsButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      icon: const Icon(Icons.more_vert),
    );
  }

  Widget buildLeftBackButton() {
    return IconButton(
      onPressed: () {
        switch (type) {
          case "Add photo":
            context.go("/home/0");
            break;
          case "Wardrobe Item Form":
            isEdit! ? context.go("/home/0") : context.go("/pick-photo");
            break;
          case "Pick outfits":
            context.go("/home/3");
            break;
          default:
            context.pop();
          //case ...
        }
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  Widget buildPageTitle() {
    switch (type) {
      case "wardrobe":
        return Text("Your Wardrobe", style: TextStyles.appTitle(Colors.black));
      case "outfits":
        return Text("Outfits", style: TextStyles.appTitle(Colors.black));
    }
    return Text(type, style: TextStyles.appTitle(Colors.black));
  }

  Widget buildRightIconButton() {
    switch (rightButtonType) {
      case "bell":
        return CustomIconButton(
            onPressed: () => context.push('/notifications'),
            icon: Icons.notifications,
            backgroundColor: Colors.transparent,
            iconColor: Colors.grey);
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
    }
    return Container();
  }
}
