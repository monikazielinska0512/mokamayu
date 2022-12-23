import 'package:flutter/material.dart';
import '../generated/l10n.dart';

class Validator {
  static String? validateEmail(String value, BuildContext context) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) return S.of(context).bad_email;
    return null;
  }

  static String? validatePassword(String value, BuildContext context) {
    if (value.length < 6) return S.of(context).bad_password;
    return null;
  }

  static String? checkIfPasswordsIdentical(
      String value, String password, BuildContext context) {
    if (value != password) return S.of(context).passwords_dont_match;
    return null;
  }

  static String? checkIfEmptyField(String value, BuildContext context) {
    if (value.isEmpty) return S.of(context).please_enter_test;
    return null;
  }

  static String? checkIfSingleValueSelected(
      String value, BuildContext context) {
    if (value == "") return "Error message";
    return null;
  }

  static String? checkIfMultipleValueSelected(
      List<String>? value, BuildContext context) {
    if (value!.isEmpty) return "null";
    return null;
  }
}
