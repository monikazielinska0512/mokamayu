import 'package:flutter/material.dart';

class BasicScreen extends StatelessWidget {
  BuildContext context;
  Widget child;
  Color? backgroundColor;

  BasicScreen({
    Key? key,
    required this.context,
    required this.child,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: backgroundColor,
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
