import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> chipsList;
  final Function(List<String>)? onSelectionChanged;

  MultiSelectChip(this.chipsList,
      {super.key, required this.onSelectionChanged});

  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];
    for (var item in widget.chipsList) {
      choices.add(Container(
        padding: const EdgeInsets.only(right: 10),
        child: ChoiceChip(
          label: Text(item),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          selected: selectedChoices.contains(item),
          backgroundColor: ColorsConstants.darkPeach.withOpacity(0.2),
          selectedColor: ColorsConstants.darkPeach,
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
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(children: _buildChoiceList())));
  }
}
