import 'package:flutter/material.dart';
import '../../../../widgets/chips/multichoice_chips.dart';

class FilterChipsFormField extends FormField<List<String>> {
  final List<String> chipsList;

  FilterChipsFormField(
      {Key? key,
      required this.chipsList,
      required FormFieldSetter<List<String>> onSaved,
      required FormFieldValidator<List<String>> validator,
      List<String> initialValue = const [],
      bool autoValidate = true})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: AutovalidateMode.disabled,
            builder: (FormFieldState<List<String>> state) {
              return Column(children: [
                Wrap(spacing: 10, children: <Widget>[
                  MultiSelectChip(chipsList,
                      onSelectionChanged: (selectedList) {
                    state.didChange(selectedList);
                  })
                ])
              ]);
            });
}