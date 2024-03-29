import 'package:flutter/material.dart';
import '../../constants/text_styles.dart';

//ignore: must_be_immutable
class BasicScreen extends StatelessWidget {
  BuildContext context;
  Widget body;
  Color? backgroundColor;
  String title;
  bool? isAppBarVisible;
  bool? isNavBarVisible = true;
  bool? isFullScreen;
  bool? isEdit;
  bool? resizeToAvoidBottomInset;
  Color? color;
  Widget? leftButton;
  Widget? rightButton;
  List<Widget>? buttons;
  void Function()? onPressed;

  BasicScreen(
      {Key? key,
      required this.context,
      required this.body,
      this.title = "",
      this.isEdit = false,
      this.color = Colors.black,
      this.isFullScreen = false,
      this.isAppBarVisible = true,
      this.onPressed,
      this.resizeToAvoidBottomInset = false,
      this.isNavBarVisible = true,
      this.backgroundColor = Colors.white,
      this.buttons,
      required this.leftButton,
      required this.rightButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBodyBehindAppBar: true,
        appBar: isAppBarVisible!
            ? AppBar(
                title: Text(title, style: TextStyles.appTitle(Colors.black)),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                foregroundColor: color,
                elevation: 0,
                actions: [rightButton ?? Container()],
                leading: leftButton ?? Container())
            : null,
        body: Center(
            child: isFullScreen!
                ? SafeArea(bottom: false, top: false, child: body)
                : SafeArea(
                    bottom: false,
                    child: Padding(
                        padding: const EdgeInsets.all(16), child: body))),
        persistentFooterButtons: buttons);
  }
}
