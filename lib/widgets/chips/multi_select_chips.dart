import 'package:flutter/material.dart';

import 'package:mokamayu/constants/constants.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> chipsList;
  final Function(List<String>)? onSelectionChanged;
  Color chipsColor;
  bool isScrollable;

  MultiSelectChip(this.chipsList,
      {super.key,
      required this.onSelectionChanged,
      this.isScrollable = true,
      this.chipsColor = ColorsConstants.darkPeach});

  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];
    for (var item in widget.chipsList) {
      choices.add(Container(
        padding: const EdgeInsets.only(right: 15),
        child: ChoiceChip(
          labelPadding: const EdgeInsets.only(right: 7, left: 7, top: 2, bottom: 2),
          label: selectedChoices.contains(item)
              ? Text(item,
                  style: TextStyles.paragraphRegularSemiBold18(
                      ColorsConstants.white))
              : Text(item,
                  style: TextStyles.paragraphRegular18(ColorsConstants.white)),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          selected: selectedChoices.contains(item),
          backgroundColor: widget.chipsColor.withOpacity(0.6),
          selectedColor: widget.chipsColor,
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged!(selectedChoices);
            });
          },
        ),
      ));
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: widget.isScrollable
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(children: _buildChoiceList()))
            : Wrap(runSpacing: 7, children: _buildChoiceList()));
  }
}
