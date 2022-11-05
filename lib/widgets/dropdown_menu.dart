import 'package:flutter/material.dart';

DropdownButtonFormField DropDownMenu(
    String? item, List<String> items, Function(String?)? onChanged, String? Function(String?)? validator) {
  return DropdownButtonFormField<String>(
      value: item,
      validator: validator,
      items: items.map((label) => DropdownMenuItem(
                value: label,
                child: Text(label),
              ))
          .toList(),
      onChanged: onChanged);
}
