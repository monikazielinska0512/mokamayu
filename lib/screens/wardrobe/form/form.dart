import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mokamayu/res/tags.dart';
import 'package:mokamayu/screens/wardrobe/form/choice_chips_form.dart';

import '../../../models/wardrobe/clothes.dart';
import 'filter_chips_field.dart';

class FormScreen extends StatefulWidget {
  Clothes? clothes;
  String? clothesID;
  File? photo;

  FormScreen({Key? key, required this.clothesID, this.photo, required clothes})
      : super(key: key);
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String selectedType = "Type";
  String? selectedSize = "";
  List<String> _selectedStyles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Name of your clothes'),
                TextFormField(
                  onSaved: (value) => _name = value!,
                  validator: (value) {
                    if (value!.length < 3) {
                      return 'a minimum of 3 characters is required';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  hint: const Text(
                    'Clothes type',
                  ),
                  onChanged: (salutation) =>
                      setState(() => selectedType = salutation!),
                  validator: (value) =>
                      value == "Type" ? 'Field required' : null,
                  items: ["Type", 'M', 'S', "XL", "L"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ChoiceChipFormField(
                    list: Tags.sizes,
                    validator: (size) => size == null ? 'Field required' : null,
                    onChanged: (size) {
                      selectedSize = size;
                    }),
                FilterChipFormField(
                    list: Tags.styles,
                    onChanged: (size) {
                      _selectedStyles = size;
                      print(_selectedStyles.toString());
                    }),
                TextButton(
                  child: const Text('Add clothes'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _formKey.currentState?.save();
                      });
                    }
                  },
                ),
                const SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
