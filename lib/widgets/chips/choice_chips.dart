import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class ChoiceChips extends StatefulWidget {
  final List chipsList;

  ChoiceChips({Key? key, required this.chipsList}) : super(key: key);

  @override
  _ChoiceChipsState createState() => _ChoiceChipsState();
}

class _ChoiceChipsState extends State<ChoiceChips> {
  String? _chipsList = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
          spacing: 10,
          children: List<Widget>.generate(widget.chipsList.length, (int index) {
            return ChoiceChip(
                label: Text(widget.chipsList[index]),
                selected: _chipsList == widget.chipsList[index],
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                backgroundColor: Colors.transparent,
                selectedColor: CustomColors.colorList[index].withOpacity(0.2),
                labelStyle: _chipsList == widget.chipsList[index]
                    ? TextStyles.paragraphRegularSemiBold18(
                        CustomColors.colorList[index])
                    : TextStyles.paragraphRegular18(CustomColors.grey),
                onSelected: (bool selected) {
                  setState(() {
                    _chipsList = (selected ? widget.chipsList[index] : "");
                  });
                });
          }).toList()),
    );
  }
}
