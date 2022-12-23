import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../services/managers/outfit_manager.dart';

class SingleSelectChipsFormField extends FormField<String> {
  final List chipsList;
  final Color color;

  SingleSelectChipsFormField(
      {Key? key,
      required this.chipsList,
      required this.color,
      required FormFieldSetter<String> onSaved,
      required FormFieldValidator<String> validator,
      BuildContext? context,
      String initialValue = "",
      String? type,
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
                          backgroundColor: color,
                          selectedColor: color.withOpacity(0.2),
                          // labelStyle: state.value == chipsList[index]
                          //     ? TextStyles.paragraphRegularSemiBold18(
                          //     ColorsConstants.colorList[index])
                          //     : TextStyles.paragraphRegular18(
                          //     ColorsConstants.grey),
                          onSelected: (bool selected) {
                            state.didChange(selected ? chipsList[index] : "");
                            if (type == 'season') {
                              print('season');
                              Provider.of<OutfitManager>(context!,
                                      listen: false)
                                  .setSeason(chipsList[index]);
                            }
                            if (type == 'style') {
                              print('style');
                              Provider.of<OutfitManager>(context!,
                                      listen: false)
                                  .setStyle(chipsList[index]);
                            }
                          });
                    }).toList()),
              ]);
            });
}
