import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class ChoiceChips extends StatefulWidget {
  final List chipsList;
  String _chipsChoice = "";

  ChoiceChips({Key? key, required this.chipsList}) : super(key: key);

  String? get chipsChoice => _chipsChoice;

  @override
  _ChoiceChipsState createState() => _ChoiceChipsState();
}

class _ChoiceChipsState extends State<ChoiceChips> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
          spacing: 10,
          children: List<Widget>.generate(widget.chipsList.length, (int index) {
            return ChoiceChip(
                label: Text(widget.chipsList[index]),
                selected: widget._chipsChoice == widget.chipsList[index],
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                backgroundColor: Colors.transparent,
                selectedColor: CustomColors.colorList[index].withOpacity(0.2),
                labelStyle: widget._chipsChoice == widget.chipsList[index]
                    ? TextStyles.paragraphRegularSemiBold18(
                        CustomColors.colorList[index])
                    : TextStyles.paragraphRegular18(CustomColors.grey),
                onSelected: (bool selected) {
                  setState(() {
                    widget._chipsChoice =
                        (selected ? widget.chipsList[index] : "");
                  });
                });
          }).toList()),
    );
  }
}
