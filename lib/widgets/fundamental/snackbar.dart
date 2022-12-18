import 'package:flutter/material.dart';
import 'package:mokamayu/constants/colors.dart';
import '../../constants/text_styles.dart';

class CustomSnackBar {
  static showErrorSnackBar(
      {required BuildContext context, required String message}) {
    _showSnackBar(
        context: context, message: message, color: ColorsConstants.red);
  }

  static showSuccessSnackBar(
      {required BuildContext context, required String message}) {
    _showSnackBar(
        context: context, message: message, color: ColorsConstants.green);
  }

  static showWarningSnackBar(
      {required BuildContext context, required String message}) {
    _showSnackBar(
        context: context, message: message, color: ColorsConstants.sunflower);
  }

  static _showSnackBar(
      {required BuildContext context,
      required String message,
      required Color color,
      int seconds = 2,
      SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: MediaQuery.of(context).size.width * 0.8,
        backgroundColor: ColorsConstants.green,
        behavior: snackBarBehavior,
        duration: Duration(seconds: seconds),
        content: SelectableText(
          message,
          style: TextStyles.paragraphRegular14(Colors.white),
        ),
      ),
    );
  }
}
