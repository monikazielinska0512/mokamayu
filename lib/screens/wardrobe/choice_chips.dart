import 'package:flutter/material.dart';

class ChoiceChips extends StatefulWidget {
  final List<String> list;
  final String? controller;
  final Function(bool) onSelected;
  ChoiceChips({Key? key, required this.list, required this.controller, required this.onSelected}) : super(key: key);

  @override
  _ChoiceChipsState createState() => _ChoiceChipsState();
}

class _ChoiceChipsState extends State<ChoiceChips> {

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: List<Widget>.generate(widget.list.length, (int index) {
      return ChoiceChip(
          label: Text(widget.list[index]),
          selected: widget.controller == widget.list[index],
          onSelected: widget.onSelected);
    }).toList());
  }

}
