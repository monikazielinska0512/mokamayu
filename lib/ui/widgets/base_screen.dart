import 'package:flutter/material.dart';

import 'navigation/navbar.dart';

abstract class BasePageScreen extends StatefulWidget {
  const BasePageScreen({Key? key}) : super(key: key);
}

abstract class BasePageScreenState<Page extends BasePageScreen>
    extends State<Page> {
  bool isAppBar = true;
  bool isNavBar = true;

  PreferredSizeWidget? appBar();

  Widget? navBar();

  void isAppBarVisible(bool isAppBar) {
    isAppBar = isAppBar;
  }

  void isNavBarVisible(bool isNavBar) {
    isNavBar = isNavBar;
  }
}

mixin BaseScreen<Page extends BasePageScreen> on BasePageScreenState<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isAppBar
            ? appBar()
            : PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Container(color: Colors.transparent),
              ),
        bottomNavigationBar: isNavBar ? navBar() : Container(),
        body: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            body: Center(
                child: SafeArea(
                    child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                          left: MediaQuery.of(context).size.width * 0.0533,
                          right: MediaQuery.of(context).size.width * 0.0533,
                          bottom: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: body())))));
  }

  Widget body();
}
