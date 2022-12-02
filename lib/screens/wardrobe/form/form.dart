import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/validator.dart';

class WardrobeItemForm extends StatefulWidget {
  final String photoPath;

  WardrobeItemForm({Key? key, required this.photoPath}) : super(key: key);

  @override
  State<WardrobeItemForm> createState() => _WardrobeItemFormState();
}

class _WardrobeItemFormState extends State<WardrobeItemForm> {
  String _type = "";
  String _size = "";
  String _name = "";
  List<String> _styles = [];

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 30, bottom: 10, left: 30, right: 30),
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                      onSaved: (value) => _name = value!,
                      autovalidateMode: AutovalidateMode.disabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        if (value.length > 20) {
                          return 'Maximum lenght is 20 characters';
                        }
                        return null;
                      },
                      style: const TextStyle(
                          fontSize: 26,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Enter your item name',
                        labelStyle: TextStyles.h4(),
                        focusedBorder: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                            bottom: 0, top: 11, right: 15),
                      )),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 10),
                          child: Text("Type",
                              style: TextStyles.paragraphRegularSemiBold18()))),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: SingleSelectChipsFormField(
                        autoValidate: true,
                        validator: (value) =>
                            Validator.checkIfSingleValueSelected(
                                value!, context),
                        onSaved: (value) => _type = value!,
                        chipsList: const ["T-Shirt", "Dress", "Skirt", "Shoes"],
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 10),
                          child: Text("Size",
                              style: TextStyles.paragraphRegularSemiBold18()))),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: SingleSelectChipsFormField(
                        autoValidate: true,
                        validator: (value) =>
                            Validator.checkIfSingleValueSelected(
                                value!, context),
                        onSaved: (value) => _size = value!,
                        chipsList: const ["XS", "S", "M", "L", "XL", "XXL"],
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 10),
                          child: Text("Style",
                              style: TextStyles.paragraphRegularSemiBold18()))),
                  MultiSelectChipsFormField(
                      chipsList: const ["School", "Wedding", "Classic", "Boho"],
                      onSaved: (value) => _styles = value!,
                      validator: (value) =>
                          Validator.checkIfMultipleValueSelected(
                              value!, context)),
                  ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState!.save();

                      String url = await StorageService()
                          .uploadFile(context, widget.photoPath);

                      if (_formKey.currentState!.validate()) {
                        final item = WardrobeItem(
                            //id: const Uuid().v4(),
                            name: _name,
                            type: _type,
                            size: _size,
                            photoURL: url,
                            styles: _styles,
                            created: DateTime.now());

                        Provider.of<WardrobeManager>(context, listen: false)
                            .addWardrobeItem(item);
                        // Provider.of<WardrobeManager>(context, listen: false)
                        // .setWardrobeItem(item);

                        _type = "";
                        _size = "";
                        _name = "";
                        _styles = [];
                        setState(() {});
                        context.go("/home/0");

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Dodano do bazy danych')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Formularz nie jest poprawny')));
                      }
                    },
                    child: const Text('Add item'),
                  ),
                ]))));
  }
}
