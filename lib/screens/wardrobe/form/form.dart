// ignore_for_file: use_build_context_synchronously

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
import '../../../generated/l10n.dart';
import '../../../utils/validator.dart';
import 'keep_alive_wrapper.dart';

class WardrobeItemForm extends StatefulWidget {
  final String? photoPath;
  final File? editedPhoto;
  final WardrobeItem? item;

  const WardrobeItemForm(
      {Key? key, this.photoPath, this.item, this.editedPhoto})
      : super(key: key);

  @override
  State<WardrobeItemForm> createState() => _WardrobeItemFormState();
}

class _WardrobeItemFormState extends State<WardrobeItemForm> {
  String _type = "";
  String _size = "";
  String _name = "";
  List<String> _styles = [];
  bool? block;

  @override
  void initState() {
    if (widget.item != null) {
      _type = widget.item!.type;
      _size = widget.item!.size;
      _name = widget.item!.name;
      _styles = widget.item!.styles;
    }
    block = Provider.of<WardrobeManager>(context, listen: false).getBlock;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.item == null
            ? const EdgeInsets.only(top: 30, bottom: 0, left: 30, right: 30)
            : const EdgeInsets.only(left: 30, right: 30, top: 10),
        child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: buildNameTextField()),
                  Gallery(context, getTabs()),
                  widget.item == null
                      ? buildAddButton()
                      : widget.item!.createdBy !=
                                  AuthService().getCurrentUserID() ||
                              block == true
                          ? const SizedBox.shrink()
                          : buildUpdateButton()
                ])));
  }

  Widget buildNameTextField() {
    return TextFormField(
        cursorColor: Colors.grey,
        initialValue: _name,
        readOnly: widget.item == null
            ? false
            : widget.item!.createdBy != AuthService().getCurrentUserID() ||
                    block == true
                ? true
                : false,
        onSaved: (value) => _name = value!,
        autovalidateMode: AutovalidateMode.disabled,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter name';
          }
          if (value.length > 20) {
            return 'Maximum length is 20 characters';
          }
          return null;
        },
        style: TextStyles.paragraphRegularSemiBold16(Colors.grey),
        decoration: InputDecoration(
            hintText: S.of(context).enter_name,
            prefixIcon: const Icon(Ionicons.pencil_outline,
                color: ColorsConstants.darkBrick),
            filled: true,
            fillColor: ColorsConstants.whiteAccent,
            labelStyle: TextStyles.paragraphRegularSemiBold16(),
            hintStyle: TextStyles.paragraphRegular16(),
            enabledBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorsConstants.whiteAccent, width: 0.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorsConstants.whiteAccent, width: 0.0),
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14.0)))));
  }

  Map<String, Widget>? getTabs() => {
        S.of(context).type: SingleChildScrollView(
            child: KeepAliveWrapper(child: buildTypeChipsField())),
        S.of(context).style: SingleChildScrollView(
            child: KeepAliveWrapper(child: buildStyleChipsField())),
        S.of(context).size: SingleChildScrollView(
            child: KeepAliveWrapper(child: buildSizeChipsField()))
      };

  Widget buildTypeChipsField() {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: SingleSelectChipsFormField(
              initialValue: _type,
              autoValidate: true,
              validator: (value) =>
                  Validator.checkIfSingleValueSelected(value!, context),
              onSaved: (value) => _type = value!,
              disableChange: widget.item == null
                  ? false
                  : widget.item!.createdBy !=
                              AuthService().getCurrentUserID() ||
                          block == true
                      ? true
                      : false,
              color: ColorsConstants.sunflower,
              type: "wardrobeType",
              chipsList: Tags.getLanguagesTypes(context)))
    ]);
  }

  Widget buildSizeChipsField() {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: SingleSelectChipsFormField(
            initialValue: _size,
            autoValidate: true,
            validator: (value) =>
                Validator.checkIfSingleValueSelected(value!, context),
            onSaved: (value) => _size = value!,
            disableChange: widget.item == null
                ? false
                : widget.item!.createdBy != AuthService().getCurrentUserID() ||
                        block == true
                    ? true
                    : false,
            color: ColorsConstants.darkMint,
            type: "wardrobeSize",
            chipsList: Tags.sizes,
          )),
    ]);
  }

  Widget buildStyleChipsField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 5),
          child: MultiSelectChip(
              chipsColor: ColorsConstants.lightBrown,
              Tags.getLanguagesStyles(context),
              isScrollable: false,
              initialValues: _styles,
              disableChange: widget.item == null
                  ? false
                  : widget.item!.createdBy !=
                              AuthService().getCurrentUserID() ||
                          block == true
                      ? true
                      : false,
              onSelectionChanged: (selectedList) => {
                    _styles = selectedList,
                  })),
    ]);
  }

  Widget buildAddButton() {
    return ButtonDarker(context, S.of(context).add, () async {
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
            createdBy: AuthService().getCurrentUserID(),
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
            context: context, message: S.of(context).item_added);
      } else {
        CustomSnackBar.showErrorSnackBar(
            context: context, message: S.of(context).empty_paramaters);
      }
    }, shouldExpand: false, width: 0.45, height: 0.061);
  }

  Widget buildUpdateButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CustomIconButton(
                onPressed: () {
                  Provider.of<WardrobeManager>(context, listen: false)
                      .removeWardrobeItem(widget.item?.reference);

                  reset();
                  context.pushReplacement("/home/0");
                  CustomSnackBar.showErrorSnackBar(
                      context: context, message: S.of(context).deleted_item);
                },
                height: 0.061,
                backgroundColor: ColorsConstants.whiteAccent,
                iconColor: ColorsConstants.grey,
                icon: Ionicons.trash_bin_outline,
                width: 0.15)),
        const SizedBox(width: 10),
        ButtonDarker(
          context,
          S.of(context).update,
          () async {
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
                  context: context, message: S.of(context).updated_item);
            } else {
              CustomSnackBar.showErrorSnackBar(
                  context: context,
                  message: S.of(context).something_went_wrong);
            }
          },
          shouldExpand: false,
          width: 0.6,
          height: 0.061,
        )
      ],
    );
  }

  void reset() {
    Provider.of<WardrobeManager>(context, listen: false)
        .resetBeforeCreatingNewOutfit();
  }
}
