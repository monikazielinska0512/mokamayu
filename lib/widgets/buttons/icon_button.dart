import 'package:flutter/material.dart';
import 'package:mokamayu/constants/colors.dart';

class CustomIconButton extends StatelessWidget {
  Function()? onPressed;
  IconData? icon;
  double? width;
  double? height;
  Color? backgroundColor;

  CustomIconButton(
      {Key? key, required this.onPressed, this.icon, this.width, this.height = double.maxFinite, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? ColorsConstants.primary,
            elevation: 0,
          ),
          child: Icon(icon),
        ));
  }
}
