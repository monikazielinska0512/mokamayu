import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class IconTextButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const IconTextButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      this.text,
      this.backgroundColor,
      this.textColor,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.fromLTRB(1, 1, 1, 1),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20.0,
        ),
        label: Text(
          text ?? '',
          style: TextStyles.paragraphRegularSemiBold14(textColor),
        ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all<Color>(
                backgroundColor ?? ColorsConstants.brick),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
      ),
    );
  }
}
