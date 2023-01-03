import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../../utils/validator.dart';

class WardrobeItemForm extends StatefulWidget {
  final String? photoPath;
  final File? editedPhoto;
  final WardrobeItem? item;
  final bool showUpdateAndDeleteButtons;

  const WardrobeItemForm(
      {Key? key,
      this.photoPath,
      this.item,
      this.showUpdateAndDeleteButtons = false,
      this.editedPhoto})
      : super(key: key);

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
        padding: widget.item == null
            ? const EdgeInsets.only(top: 30, bottom: 0, left: 30, right: 30)
            : const EdgeInsets.only(left: 30, right: 30, top: 10),
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      buildNameTextField(),
                      buildTypeChipsField(),
                      buildSizeChipsField(),
                      buildStyleChipsField(),
                      widget.item == null
                          ? buildAddButton()
                          : (widget.showUpdateAndDeleteButtons == true
                              ? buildUpdateButton()
                              : Container())
                    ])))));
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
          contentPadding: const EdgeInsets.only(bottom: 0, right: 0, top: 0),
        ));
  }

  Widget buildTypeChipsField() {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text("Type",
                  style: TextStyles.paragraphRegularSemiBold18()))),
      Align(
          alignment: Alignment.centerLeft,
          child: SingleSelectChipsFormField(
              initialValue: _type,
              autoValidate: true,
              validator: (value) =>
                  Validator.checkIfSingleValueSelected(value!, context),
              onSaved: (value) => _type = value!,
              color: ColorsConstants.sunflower,
              chipsList: Tags.types))
    ]);
  }

  Widget buildSizeChipsField() {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(top: 5),
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
            color: ColorsConstants.darkMint,
            chipsList: Tags.sizes,
          )),
    ]);
  }

  Widget buildStyleChipsField() {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text("Style",
                  style: TextStyles.paragraphRegularSemiBold18()))),
      MultiSelectChipsFormField(
          isScroll: false,
          initialValue: _styles,
          chipsList: Tags.styles,
          onSaved: (value) => _styles = value!,
          validator: (value) =>
              Validator.checkIfMultipleValueSelected(value!, context)),
    ]);
  }

  Widget buildAddButton() {
    return ButtonDarker(context, 'Add item', () async {
      _formKey.currentState!.save();
      if (_formKey.currentState!.validate()) {
        String url =
            await StorageService().uploadFile(context, widget.photoPath ?? "");

        final item = WardrobeItem(
            name: toBeginningOfSentenceCase(_name).toString(),
            type: _type,
            size: _size,
            photoURL: url,
            styles: _styles,
            created: DateTime.now());
        if (!mounted) return;
        Provider.of<WardrobeManager>(context, listen: false)
            .addWardrobeItem(item);

        _type = "";
        _size = "";
        _name = "";
        _styles = [];

        reset();

        context.pushReplacement("/home/0");

        CustomSnackBar.showSuccessSnackBar(
            context: context, message: "Dodano do bazy danych");
      } else {
        CustomSnackBar.showErrorSnackBar(
            context: context, message: "Coś poszło nie tak");
      }
    }, shouldExpand: false, width: 0.45, height: 0.061);
  }

  Widget buildUpdateButton() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomIconButton(
                onPressed: () {
                  Provider.of<WardrobeManager>(context, listen: false)
                      .removeWardrobeItem(widget.item?.reference);
                  reset();
                  context.pushReplacement("/home/0");
                },
                backgroundColor: ColorsConstants.whiteAccent,
                iconColor: ColorsConstants.grey,
                icon: Ionicons.trash_bin_outline,
                width: 0.15),
            const SizedBox(width: 10),
            ButtonDarker(context, 'Update', () async {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                if (widget.editedPhoto != null) {
                  StorageService().uploadFile(context, widget.photoPath ?? "");

                  String url = await StorageService()
                      .uploadFile(context, widget.photoPath ?? "");
                  Provider.of<WardrobeManager>(context, listen: false)
                      .updateWardrobeItem(widget.item?.reference ?? "", _name,
                          _type, _size, url, _styles);
                }

                Provider.of<WardrobeManager>(context, listen: false)
                    .updateWardrobeItem(widget.item?.reference ?? "", _name,
                        _type, _size, widget.item?.photoURL ?? "", _styles);
                reset();
                context.pushReplacement("/home/0");
                CustomSnackBar.showSuccessSnackBar(
                    context: context, message: "Updated");
              } else {
                CustomSnackBar.showErrorSnackBar(
                    context: context, message: "Error");
              }
            },
                shouldExpand: false,
                width: 0.6,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
          ],
        ));
  }

  void reset() {
    Provider.of<WardrobeManager>(context, listen: false)
        .resetBeforeCreatingNewOutfit();
  }
}
