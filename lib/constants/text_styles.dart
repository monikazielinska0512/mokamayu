import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle appTitle([Color? color]) {
    return TextStyle(
        fontSize: 26,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w700,
        color: color);
  }

  static TextStyle h1([Color? color]) {
    return TextStyle(
        fontSize: 40,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w600,
        color: color);
  }

  static TextStyle h2([Color? color]) {
    return TextStyle(
        fontSize: 34,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w600,
        color: color);
  }

  static TextStyle h3([Color? color]) {
    return TextStyle(
        fontSize: 30,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w600,
        color: color);
  }

  static TextStyle h4([Color? color]) {
    return TextStyle(
        fontSize: 24,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w600,
        color: color);
  }

  static TextStyle h5([Color? color]) {
    return TextStyle(
        fontSize: 20,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w600,
        color: color);
  }

  static TextStyle h6({Color? color = Colors.black}) {
    return TextStyle(
        fontSize: 18,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w600,
        color: color);
  }

  static TextStyle titleForDescription([Color? color]) {
    return TextStyle(
        fontSize: 20,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w500,
        color: color);
  }

  static TextStyle paragraphRegular18([Color? color]) {
    return TextStyle(
        fontSize: 18,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w400,
        color: color);
  }

  static TextStyle paragraphRegularSemiBold18([Color? color]) {
    return TextStyle(
        fontSize: 18,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        color: color);
  }

  static TextStyle paragraphRegular16([Color? color = Colors.black]) {
    return TextStyle(
        fontSize: 16,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w400,
        color: color);
  }

  static TextStyle paragraphRegularSemiBold16() {
    return TextStyle(
        fontSize: 16,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600);
  }

  static TextStyle paragraphRegular14([Color? color]) {
    return TextStyle(
        fontSize: 14,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w400,
        color: color);
  }

  static TextStyle paragraphRegularSemiBold14([Color? color]) {
    return TextStyle(
        fontSize: 14,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        color: color);
  }
}
