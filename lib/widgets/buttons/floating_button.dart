import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  Function()? onPressed;
  Icon icon;
  Color backgroundColor;
  EdgeInsetsGeometry padding;
  AlignmentGeometry alignment;

  FloatingButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      required this.backgroundColor,
      required this.padding,
      required this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: alignment,
        child: Padding(
            padding: padding,
            child: FloatingActionButton(
              heroTag: null,
              elevation: 3,
              onPressed: onPressed,
              backgroundColor: backgroundColor,
              child: icon,
            )));
  }
}
