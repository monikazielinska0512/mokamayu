import 'package:flutter/material.dart';

class FilterChipFormField extends StatefulWidget {
  FilterChipFormField({Key? key, required this.onChanged, required this.list})
      : super(key: key);
  final Function(List<String>) onChanged;
  final List<String> list;
  final List<String> pickedStyles = [];

  @override
  _FilterChipFormFieldState createState() => _FilterChipFormFieldState();
}

class _FilterChipFormFieldState extends State<FilterChipFormField> {
  @override
  Widget build(BuildContext context) {
    return FormField<String>(builder: (formFieldState) {
      return Column(children: [
        Wrap(
          spacing: 4.0,
          runSpacing: 0.001,
          children: stylesTags.toList(),
        ),
      ]);
    });
  }

  Iterable<Widget> get stylesTags {
    return widget.list.map((String style) {
      return FilterChip(
        label: Text(style),
        selected: widget.pickedStyles.contains(style),
        onSelected: (bool value) {
          setState(() {
            if (value) {
              widget.pickedStyles.add(style);
            } else {
              widget.pickedStyles.removeWhere((String name) {
                return name == style;
              });
            }
          });
          widget.onChanged.call(widget.pickedStyles);
        },
      );
    });
  }
}
