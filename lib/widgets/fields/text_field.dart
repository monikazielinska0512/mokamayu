// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

TextFormField CustomTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller, String? Function(String?)? onValidate) {
  return TextFormField(
    validator: onValidate,
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.grey,
    style: TextStyles.paragraphRegular14(Colors.grey),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: ColorsConstants.grey),
      labelText: text,
      labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: ColorsConstants.whiteAccent,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}
