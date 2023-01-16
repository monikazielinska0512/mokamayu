import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/screens/wardrobe/form/form.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:mokamayu/widgets/buttons/predefined_buttons.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/wardrobe_item.dart';

class AddWardrobeItemForm extends StatefulWidget {
  bool isEdit;
  final String? photo;
  WardrobeItem? editItem;

  AddWardrobeItemForm(
      {Key? key,
      this.photo,
      this.editItem,
      required this.isEdit})
      : super(key: key);

  @override
  State<AddWardrobeItemForm> createState() => _AddWardrobeItemFormState();
}

class _AddWardrobeItemFormState extends State<AddWardrobeItemForm> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
        context: context,
        isFullScreen: true,
        isEdit: true,
        color: Colors.white,
        rightButton: null,
        leftButton: BackArrowButton(context),
        body: Stack(children: [buildBackgroundPhoto(), buildForm()]),
        );
  }

  Widget buildBackgroundPhoto() {
    final picker = widget.editItem != null
        ? PhotoPicker(
            photoURL: widget.editItem!.photoURL, isEditPhotoForm: true)
        : Container();
    return Positioned(
        child: !widget.isEdit
            ? buildBackgroundImageForAddForm()
            : buildBackgroundImageForEditForm(picker));
  }

  Widget buildForm() {
    return Align(
        alignment: Alignment.bottomLeft,
        child: BackgroundCard(
            context: context,
            height: 0.7,
            child: Stack(children: [
                   Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child:
                          WardrobeItemForm(
                                      photoPath: widget.photo ?? "",
                                      item: widget.editItem))),
                ])));
  }

  bool isWardrobeItemMine() =>
      Provider.of<WardrobeManager>(context, listen: false)
          .finalWardrobeItemList
          .contains(widget.editItem);

  // Widget editButton() {
  //   return isWardrobeItemMine()
  //       ? Padding(
  //           padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
  //           child: Align(
  //               alignment: Alignment.topRight,
  //               child: IconButton(
  //                   onPressed: () =>
  //                       setState(() => widget.isLocked = !widget.isLocked),
  //                   icon: const Icon(Ionicons.create_outline,
  //                       color: Colors.black))))
  //       : Container();
  // }

  Widget buildBackgroundImageForAddForm() {
    return Image.file(
      File(widget.photo ?? ""),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,
    );
  }

  Widget buildBackgroundImageForEditForm(Widget picker) {
    return Image.network(
            widget.editItem!.photoURL,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          );
  }
}
