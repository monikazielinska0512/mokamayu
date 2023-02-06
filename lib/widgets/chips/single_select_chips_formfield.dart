import 'package:flutter/material.dart';
import 'package:mokamayu/services/managers/wardrobe_manager.dart';
import 'package:provider/provider.dart';
import '../../constants/text_styles.dart';
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
      bool disableChange = false,
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
                          label: state.value == chipsList[index]
                              ? Text(chipsList[index],
                                  style: TextStyles.paragraphRegularSemiBold16(
                                      Colors.white))
                              : Text(chipsList[index],
                                  style: TextStyles.paragraphRegular16(
                                      Colors.white)),
                          selected: state.value == chipsList[index],
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          backgroundColor: color.withOpacity(0.6),
                          selectedColor: color,
                          onSelected: (bool selected) {
                            if (!disableChange) {
                              state.didChange(selected ? chipsList[index] : "");
                              if (type == 'season') {
                                Provider.of<OutfitManager>(context!,
                                        listen: false)
                                    .setSeason(chipsList[index]);
                              }
                              // if (type == 'style') {
                              //   Provider.of<OutfitManager>(context!,
                              //           listen: false)
                              //       .setStyle(chipsList[index]);
                              // }
                            }
                          });
                    }).toList()),
              ]);
            });
}
