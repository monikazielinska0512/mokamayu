import 'package:flutter/material.dart';
import 'package:mokamayu/constants/colors.dart';

//ignore: must_be_immutable
class CustomIconButton extends StatelessWidget {
  Function()? onPressed;
  IconData? icon;
  double width;
  double height;
  Color? backgroundColor;
  Color? iconColor;

  CustomIconButton(
      {Key? key,
      required this.onPressed,
      this.icon,
      this.iconColor,
      this.width = 0.2,
      this.height = 0.06,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * width,
        height: MediaQuery.of(context).size.height * height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? ColorsConstants.darkBrick,
            elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          ),
          child: Center(child: Icon(icon, color: iconColor, size: 30)),
        ));
  }
}
