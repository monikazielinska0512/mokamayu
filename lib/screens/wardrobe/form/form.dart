import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/validator.dart';
import 'package:mokamayu/widgets/widgets.dart';

class WardrobeItemForm extends StatefulWidget {
  final String? photoPath;
  final WardrobeItem? item;

  const WardrobeItemForm({Key? key, this.photoPath, this.item})
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
        padding:
            const EdgeInsets.only(top: 25, bottom: 10, left: 30, right: 30),
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildNameTextField(),
                      buildTypeChipsField(),
                      buildSizeChipsField(),
                      buildStyleChipsField(),
                      widget.item == null
                          ? buildAddButton()
                          : buildUpdateButton(),
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
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only( top: 10),
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
              padding: const EdgeInsets.only( top: 10),
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
              padding: const EdgeInsets.only( top: 10),
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
            name: _name,
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

        context.go("/home/0");

        CustomSnackBar.showSuccessSnackBar(
            context: context, message: "Dodano do bazy danych");
      } else {
        CustomSnackBar.showErrorSnackBar(
            context: context, message: "Coś poszło nie tak");
      }
    }, shouldExpand: false, width: 0.45, height: 0.061);
  }

  Widget buildUpdateButton() {
    return Column(
      children: [
        ElevatedButton(
            child: const Text('Update'),
            onPressed: () async {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                Provider.of<WardrobeManager>(context, listen: false)
                    .updateWardrobeItem(widget.item?.reference ?? "", _name,
                        _type, _size, widget.item?.photoURL ?? "", _styles);
                reset();
                context.go("/home/0");
                CustomSnackBar.showSuccessSnackBar(
                    context: context, message: "Updated");
              } else {
                CustomSnackBar.showSuccessSnackBar(
                    context: context, message: "Error");
              }
            }),
        IconButton(
            onPressed: () {
              Provider.of<WardrobeManager>(context, listen: false)
                  .removeWardrobeItem(widget.item?.reference);
              reset();
              context.go("/home/0");
            },
            icon: Image.asset(
              "assets/images/trash.png",
              fit: BoxFit.fitWidth,
              height: 40,
            ))
      ],
    );
  }

  void reset() {
    Provider.of<WardrobeManager>(context, listen: false).nullListItemCopy();
    Provider.of<WardrobeManager>(context, listen: false).setTypes([]);
    Provider.of<WardrobeManager>(context, listen: false).setSizes([]);
    Provider.of<WardrobeManager>(context, listen: false).setStyles([]);
  }
}
