import 'package:flutter/material.dart';

class BasicPage extends StatelessWidget {
  BuildContext context;
  Widget child;
  Color? backgroundColor;

  BasicPage({
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
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  left: MediaQuery.of(context).size.width * 0.0533,
                  right: MediaQuery.of(context).size.width * 0.0533,
                ),
                child: child)));
  }
}