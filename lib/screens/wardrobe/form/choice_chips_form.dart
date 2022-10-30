import 'package:flutter/material.dart';
import '../../../res/tags.dart';

class ChoiceChipFormField extends StatefulWidget {
  ChoiceChipFormField({
    Key? key,
    required this.validator,
    required this.onChanged,
    required this.list
  }) : super(key: key);
  final String? Function(String?) validator;
  final Function(String?) onChanged;
  final List<String> list;
  String? _pickedSize;

  @override
  _ChoiceChipFormFieldState createState() => _ChoiceChipFormFieldState();
}

class _ChoiceChipFormFieldState extends State<ChoiceChipFormField> {
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (formFieldState) {
          return Column(children: [
            Wrap(
                children: List<Widget>.generate(widget.list.length, (int index) {
              return ChoiceChip(
                  label: Text(widget.list[index]),
                  selected: widget._pickedSize == widget.list[index],
                  onSelected: (bool selected) {
                    setState(() {

                      widget._pickedSize =
                          (selected ? widget.list[index] : null);
                      widget.onChanged.call(widget._pickedSize);
                    });
                  });
            }).toList()),
            if (formFieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 10),
                child: Text(
                  formFieldState.errorText!,
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 13,
                      color: Colors.red[700],
                      height: 0.5),
                ),
              )
          ]);
        });
  }
}
