import 'package:flutter/material.dart';
import 'package:mokamayu/generated/l10n.dart';

TextFormField reusableTextField(
    String text,
    IconData icon,
    bool isPasswordType,
    TextEditingController controller,
    String confirmPasswordController,
    BuildContext context,
    bool isEmailType) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) return S.of(context).please_enter_test;

      if (confirmPasswordController != '' && value != confirmPasswordController)
        return S.of(context).passwords_dont_match;

      if (isEmailType &&
          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(controller.text)) return S.of(context).bad_email;

      if (isPasswordType &&
          confirmPasswordController != '' &&
          controller.text.length < 6) return S.of(context).bad_password;

      return null;
    },
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Color.fromARGB(255, 126, 68, 68),
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}
