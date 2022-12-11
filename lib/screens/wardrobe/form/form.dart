import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/fundamental/snackbar.dart';
import 'package:provider/provider.dart';
import '../../../utils/validator.dart';
import '../../../widgets/chips/multi_select_chips_formfield.dart';
import '../../../widgets/chips/single_select_chips_formfield.dart';

class WardrobeItemForm extends StatefulWidget {
  final String? photoPath;
  final WardrobeItem? item;

  WardrobeItemForm({Key? key, this.photoPath, this.item}) : super(key: key);

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
    if (widget.item != null) {
      _type = widget.item!.type;
      _size = widget.item!.size;
      _name = widget.item!.name;
      _styles = widget.item!.styles;
    }
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
                  buildNameTextField(),
                  buildTypeChipsField(),
                  buildSizeChipsField(),
                  buildStyleChipsField(),
                  widget.item == null ? buildAddButton() : buildUpdateButton()
                ]))));
  }

  Widget buildNameTextField() {
    return TextFormField(
        initialValue: _name,
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
            fontSize: 26, fontFamily: "Poppins", fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Enter your item name',
          labelStyle: TextStyles.h4(),
          focusedBorder: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 0, top: 11, right: 15),
        ));
  }

  Widget buildTypeChipsField() {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          child: Text("Type", style: TextStyles.paragraphRegularSemiBold18())),
      Align(
          alignment: Alignment.centerLeft,
          child: SingleSelectChipsFormField(
            initialValue: _type,
            autoValidate: true,
            validator: (value) =>
                Validator.checkIfSingleValueSelected(value!, context),
            onSaved: (value) => _type = value!,
            chipsList: const ["T-Shirt", "Dress", "Skirt", "Shoes"],
          ))
    ]);
  }

  Widget buildSizeChipsField() {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 10),
              child: Text("Size",
                  style: TextStyles.paragraphRegularSemiBold18()))),
      Align(
          alignment: Alignment.centerLeft,
          child: SingleSelectChipsFormField(
            initialValue: _size,
            autoValidate: true,
            validator: (value) =>
                Validator.checkIfSingleValueSelected(value!, context),
            onSaved: (value) => _size = value!,
            chipsList: const ["XS", "S", "M", "L", "XL", "XXL"],
          )),
    ]);
  }

  Widget buildStyleChipsField() {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 10),
              child: Text("Style",
                  style: TextStyles.paragraphRegularSemiBold18()))),
      MultiSelectChipsFormField(
          isScroll: false,
          initialValue: _styles,
          chipsList: const ["School", "Wedding", "Classic", "Boho"],
          onSaved: (value) => _styles = value!,
          validator: (value) =>
              Validator.checkIfMultipleValueSelected(value!, context)),
    ]);
  }

  Widget buildAddButton() {
    return ElevatedButton(
        child: const Text('Add item'),
        onPressed: () async {
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            String url = await StorageService()
                .uploadFile(context, widget.photoPath ?? "");
            final item = WardrobeItem(
                name: _name,
                type: _type,
                size: _size,
                photoURL: url,
                styles: _styles,
                created: DateTime.now());

            Provider.of<WardrobeManager>(context, listen: false)
                .addWardrobeItem(item);

            _type = "";
            _size = "";
            _name = "";
            _styles = [];
            context.go("/home/0");
            CustomSnackBar.showSuccessSnackBar(context: context, message: "Dodano do bazy danych");
          } else {
            CustomSnackBar.showErrorSnackBar(context: context, message: "Coś poszło nie tak");
          }
        });
  }

  Widget buildUpdateButton() {
    return ElevatedButton(
        child: const Text('Update'),
        onPressed: () async {
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            Provider.of<WardrobeManager>(context, listen: false)
                .updateWardrobeItem(widget.item?.reference ?? "", _name, _type,
                    _size, widget.item?.photoURL ?? "", _styles);
            CustomSnackBar.showSuccessSnackBar(context: context, message: "Updated");
          } else {
            CustomSnackBar.showSuccessSnackBar(context: context, message: "Error");
          }
        });
  }
}
