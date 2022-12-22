import 'package:flutter/material.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:mokamayu/widgets/chips/chips.dart';
import 'package:provider/provider.dart';

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
      BuildContext? context,
      String? type,
      bool autoValidate = true})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: AutovalidateMode.disabled,
            builder: (FormFieldState<List<String>> state) {
              return Column(children: [
                isScroll
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(spacing: 10, children: <Widget>[
                          MultiSelectChip(chipsList,
                              onSelectionChanged: (selectedList) {
                            state.didChange(selectedList);
                          })
                        ]))
                    : Wrap(spacing: 10, children: <Widget>[
                        MultiSelectChip(chipsList,
                            onSelectionChanged: (selectedList) {
                          state.didChange(selectedList);

                          // if (type == 'type') {
                          //   Provider.of<WardrobeManager>(context!,
                          //           listen: false)
                          //       .setTypes(selectedList);
                          // }
                          // if (type == 'size') {
                          //   Provider.of<WardrobeManager>(context!,
                          //           listen: false)
                          //       .setSizes(selectedList);
                          // }
                          // if (type == 'styles') {
                          //   Provider.of<WardrobeManager>(context!,
                          //           listen: false)
                          //       .setStyles(selectedList);
                          // }
                        })
                      ])
              ]);
            });
}
