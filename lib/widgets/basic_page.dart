import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BasicScreen extends StatelessWidget {
  BuildContext context;
  Widget child;
  Color? backgroundColor;
  String type;

  BasicScreen({
    Key? key,
    required this.type,
    required this.context,
    required this.child,
    this.backgroundColor,
  }) : super(key: key);

  bool ifShow() => type == "wardrobe_home" ? false : true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: backgroundColor,
        appBar: ifShow()
            ? AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    switch (type) {
                      case "add_photo":
                        context.go("/home/0");
                        break;
                      //case ...
                    }
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ))
            : null,
        body: Center(
            child: SafeArea(
                child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                      left: MediaQuery.of(context).size.width * 0.0533,
                      right: MediaQuery.of(context).size.width * 0.0533,
                      bottom: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: child))));
  }
}
