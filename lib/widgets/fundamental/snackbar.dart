import 'package:flutter/material.dart';
import 'package:mokamayu/constants/colors.dart';
import '../../constants/text_styles.dart';

class CustomSnackBar {
  static showErrorSnackBar(BuildContext context, String message) {
    _showSnackBar(
        context: context, message: message, color: ColorsConstants.red);
  }

  static showSuccessSnackBar(BuildContext context, String message) {
    _showSnackBar(
        context: context, message: message, color: ColorsConstants.green);
  }

  static showWarningSnackBar(BuildContext context, String message) {
    _showSnackBar(
        context: context, message: message, color: ColorsConstants.sunflower);
  }

  static _showSnackBar(
      {required BuildContext context,
      required String message,
      required Color color,
      int milliseconds = 10000,
      SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: MediaQuery.of(context).size.width * 0.8,
        backgroundColor: ColorsConstants.green,
        margin: const EdgeInsets.only(bottom: 30.0),
        behavior: snackBarBehavior,
        duration: Duration(milliseconds: milliseconds),
        content: SelectableText(
          message,
          style: TextStyles.paragraphRegularSemiBold14(Colors.white),
        ),
      ),
    );
  }
}
