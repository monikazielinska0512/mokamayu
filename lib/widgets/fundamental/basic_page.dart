import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/text_styles.dart';
import '../buttons/icon_button.dart';
import '../navigation/drawer.dart';

class BasicScreen extends StatelessWidget {
  BuildContext context;
  Widget body;
  Color? backgroundColor;
  String type;
  bool? isAppBarVisible;
  bool? isNavBarVisible = true;
  bool? isLeftButtonVisible = true;
  bool? isRightButtonVisible = true;
  String? leftButtonType = "back";
  String? rightButtonType = "bell";
  bool? isFullScreen;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  BasicScreen({
    Key? key,
    required this.context,
    required this.body,
    required this.type,
    this.isFullScreen = false,
    this.isAppBarVisible = true,
    this.isLeftButtonVisible = true,
    this.isRightButtonVisible = true,
    this.isNavBarVisible = true,
    this.leftButtonType = "back",
    this.rightButtonType = "bell",
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        drawer: drawer(context),
        appBar: isAppBarVisible!
            ? AppBar(
                title: buildPageTitle(),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                elevation: 0,
                actions: [buildRightIconButton()],
                leading: (leftButtonType == "back")
                    ? buildLeftBackButton()
                    : (leftButtonType == "dots")
                        ? buildDotsButton()
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

  Widget buildDotsButton() {
    return IconButton(
      onPressed: () => _key.currentState!.openDrawer(),
      icon: const Icon(Icons.more_vert),
    );
  }

  Widget buildLeftBackButton() {
    return IconButton(
      onPressed: () {
        switch (type) {
          case "add_photo":
            context.go("/home/0");
            break;
          case "wardrobe_item_form":
            context.go("/pick-photo");
            break;
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
    }
    return const Text("");
  }

  Widget buildRightIconButton() {
    switch (rightButtonType) {
      case "bell":
        return CustomIconButton(
            onPressed: () {},
            icon: Icons.notifications,
            backgroundColor: Colors.transparent,
            iconColor: Colors.grey);
      case "go_forward":
        return CustomIconButton(onPressed: () {}, icon: Icons.arrow_forward);
      case "search":
        return CustomIconButton(onPressed: () {}, icon: Icons.search);
      case "bin":
        return CustomIconButton(onPressed: () {}, icon: Icons.delete);
    }
    return Container();
  }
}
