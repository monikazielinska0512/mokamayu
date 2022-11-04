import 'package:flutter/material.dart';

DropdownButtonFormField DropDownMenu(
    String? item, List<String> items, Function(String?)? onChanged) {
  return DropdownButtonFormField<String>(
      value: item,
      items: items
          .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
          .toList(),
      onChanged: onChanged);
}
