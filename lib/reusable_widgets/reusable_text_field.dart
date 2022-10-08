import 'package:flutter/material.dart';

TextFormField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller, String confirmPasswordController) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter text';
      }
      if (confirmPasswordController != '') {
        if (value != confirmPasswordController) {
          return 'Passwords do not match';
        }
        return null;
      }
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
