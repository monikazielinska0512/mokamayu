import 'package:flutter/material.dart';
import 'package:mokamayu/widgets/chips/chips.dart';

import '../../constants/colors.dart';

class MultiSelectChipsFormField extends FormField<List<String>> {
  final List<String> chipsList;
  final bool isScroll;

  MultiSelectChipsFormField(
      {Key? key,
      required this.isScroll,
      required this.chipsList,
      FormFieldSetter<List<String>>? onSaved,
      FormFieldValidator<List<String>>? validator,
      List<String>? initialValue,
      bool autoValidate = true})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: AutovalidateMode.disabled,
            builder: (FormFieldState<List<String>> state) {
              return
                isScroll
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(spacing: 20, children: <Widget>[
                          MultiSelectChip(chipsList,
                              isScrollable: isScroll,
                              chipsColor: ColorsConstants.darkPeach,
                              onSelectionChanged: (selectedList) {
                            state.didChange(selectedList);
                          })
                        ]))
                    : Wrap(spacing: 10, children: <Widget>[
                        MultiSelectChip(chipsList,
                            isScrollable: isScroll,
                            chipsColor: ColorsConstants.darkPeach,
                            onSelectionChanged: (selectedList) {
                          state.didChange(selectedList);
                        })
                      ]);
            });
}
