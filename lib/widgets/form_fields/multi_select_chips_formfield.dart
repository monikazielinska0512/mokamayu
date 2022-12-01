import 'package:flutter/material.dart';
import 'package:mokamayu/widgets/chips/chips.dart';

class MultiSelectChipsFormField extends FormField<List<String>> {
  final List<String> chipsList;

  MultiSelectChipsFormField(
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
