import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/colors.dart';
import '../../constants/text_styles.dart';

class CustomSnackBar {
  static showErrorSnackBar(
      {required BuildContext context, required String message}) {
    _showSnackBar(
        context: context,
        message: message,
        color: ColorsConstants.red,
        icon: Ionicons.sad_outline);
  }

  static showSuccessSnackBar(
      {required BuildContext context, required String message}) {
    _showSnackBar(
        context: context,
        message: message,
        color: ColorsConstants.green,
        icon: Ionicons.happy_outline);
  }

  static showWarningSnackBar(
      {required BuildContext context, required String message}) {
    _showSnackBar(
        context: context,
        message: message,
        color: ColorsConstants.sunflower,
        icon: Ionicons.warning_outline);
  }

  static _showSnackBar(
      {required BuildContext context,
      required String message,
      required Color color,
      required IconData? icon,
      int seconds = 2,
      SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: MediaQuery.of(context).size.width * 0.8,
        backgroundColor: color,
        behavior: snackBarBehavior,
        duration: Duration(seconds: seconds),
        content: Row(children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          SelectableText(
            message,
            style: TextStyles.paragraphRegular14(Colors.white),
          )
        ]),
      ),
    );
  }
}
