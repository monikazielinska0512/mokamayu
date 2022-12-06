import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/constants/constants.dart';

class DropdownMenuFormField extends FormField<String> {
  List<String> list;

  DropdownMenuFormField(
      {Key? key,
      required this.list,
      required FormFieldSetter<String> onSaved,
      required FormFieldValidator<String> validator,
      required String initialValue,
      bool autoValidate = true})
      : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: AutovalidateMode.disabled,
          builder: (FormFieldState<String> state) {
            return DropdownButtonFormField2(
              decoration: InputDecoration(
                fillColor: ColorsConstants.whiteAccent,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              isExpanded: true,
              hint: Text(
                'Select item type',
                style: TextStyles.paragraphRegular18(),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 30,
              dropdownMaxHeight: 200,
              buttonHeight: 60,
              scrollbarRadius: const Radius.circular(40),
              scrollbarThickness: 6,
              scrollbarAlwaysShow: true,
              buttonPadding: const EdgeInsets.only(left: 20, right: 10),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              items: list
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select type.';
                }
              },
              onChanged: (value) {
                //Do something when changing the item if you want.
              },
              onSaved: (value) {
                state.didChange(value.toString());
              },
            );
          },
        );
}
