import 'package:flutter/material.dart';


//ignore: must_be_immutable
class BackgroundCard extends StatelessWidget {
  Widget child;
  BuildContext context;
  double? height;
  double? width;

  BackgroundCard({
    required this.child,
    required this.context,
    this.height,
    this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * (height ?? 1.0),
        width: MediaQuery.of(context).size.width * (width ?? 1.0),
        child: Card(
                margin: EdgeInsets.zero,
                elevation: 10,
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40)),
                ),
                child: child));
  }
}
