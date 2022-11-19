import 'package:flutter/material.dart';

import 'package:mokamayu/ui/constants/constants.dart';

class ChoiceChipsFormField extends FormField<String> {
  final List chipsList;

  ChoiceChipsFormField(
      {Key? key,
      required this.chipsList,
      required FormFieldSetter<String> onSaved,
      required FormFieldValidator<String> validator,
      String initialValue = "",
      bool autoValidate = true})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: AutovalidateMode.disabled,
            builder: (FormFieldState<String> state) {
              return Column(children: [
                Wrap(
                    spacing: 10,
                    children:
                        List<Widget>.generate(chipsList.length, (int index) {
                      return ChoiceChip(
                          label: Text(chipsList[index]),
                          selected: state.value == chipsList[index],
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          backgroundColor: ColorManager.soft,
                          selectedColor:
                              ColorManager.colorListFilters[index].withOpacity(0.2),
                          labelStyle: state.value == chipsList[index]
                              ? TextStylesManager.paragraphRegularSemiBold18(
                                  ColorManager.colorListFilters[index])
                              : TextStylesManager.paragraphRegular18(
                                  ColorManager.grey),
                          onSelected: (bool selected) {
                            state.didChange(selected ? chipsList[index] : "");
                          });
                    }).toList()),
              ]);
            });
}
