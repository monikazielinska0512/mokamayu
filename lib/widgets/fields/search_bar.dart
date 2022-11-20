import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class SearchBar extends StatefulWidget {
  String title;
  String? hintTitle;

  SearchBar({Key? key, required this.title, this.hintTitle}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      cursorColor: Colors.black,
      decoration: InputDecoration(
          filled: true,
          fillColor: ColorsConstants.soft,
          labelText: focusNode.hasFocus == false ? widget.title : "",
          labelStyle: TextStyles.paragraphRegular18(ColorsConstants.grey),
          hintText: widget.hintTitle,
          hintStyle: TextStyles.paragraphRegular18(ColorsConstants.grey),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorsConstants.soft, width: 0.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorsConstants.soft, width: 0.0),
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0))),
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: focusNode.hasFocus == false
              ? ColorsConstants.grey
              : ColorsConstants.primary),
    );
  }
}
