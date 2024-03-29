// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../constants/colors.dart';
import '../../generated/l10n.dart';

//ignore: must_be_immutable
class SearchTextField extends StatefulWidget {
  Function(String)? onChanged;
  Function()? onTap;
  bool readOnly;

  SearchTextField({Key? key, this.onChanged, this.readOnly = false, this.onTap})
      : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: widget.readOnly,
      onTap: widget.readOnly == true ? widget.onTap : () => {},
      focusNode: _focus,
      autofocus: true,
      cursorColor: ColorsConstants.darkBrick,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
          hintText: _focus.hasFocus == true
              ? S.of(context).searchbar_wardrobe_item
              : "",
          filled: true,
          fillColor: ColorsConstants.whiteAccent,
          labelStyle: const TextStyle(
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              color: ColorsConstants.turquoise),
          hintStyle: const TextStyle(
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              color: ColorsConstants.turquoise),
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorsConstants.whiteAccent, width: 0.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorsConstants.whiteAccent, width: 0.0),
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0))),
          prefixIcon:
              const Icon(Icons.search, color: ColorsConstants.darkBrick)),
    );
  }
}

InputDecoration SearchBarStyle(String hintText,
    {Icon? icon =
        const Icon(Ionicons.search_outline, color: ColorsConstants.darkBrick),
    Widget? suffixIcon,
    double? fontSize = 18}) {
  return InputDecoration(
      suffixIcon: suffixIcon,
      hintText: hintText,
      filled: true,
      fillColor: ColorsConstants.whiteAccent,
      labelStyle: TextStyle(
          fontSize: fontSize,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400,
          color: ColorsConstants.grey),
      hintStyle: TextStyle(
          fontSize: fontSize,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400,
          color: ColorsConstants.grey),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: ColorsConstants.whiteAccent, width: 0.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: ColorsConstants.whiteAccent, width: 0.0),
      ),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0))),
      prefixIcon: icon);
}
