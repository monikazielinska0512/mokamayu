import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/screens/wardrobe/form/form.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/wardrobe_item.dart';

class AddWardrobeItemForm extends StatefulWidget {
  bool isEdit;
  bool isLocked;
  final String? photo;
  WardrobeItem? editItem;

  AddWardrobeItemForm(
      {Key? key,
      this.photo,
      this.editItem,
      required this.isEdit,
      this.isLocked = false})
      : super(key: key);

  @override
  State<AddWardrobeItemForm> createState() => _AddWardrobeItemFormState();
}

class _AddWardrobeItemFormState extends State<AddWardrobeItemForm> {
  @override
  void initState() {
    widget.isLocked = widget.isEdit;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
        context: context,
        isFullScreen: true,
        isEdit: true,
        color: Colors.white,
        rightButtonType: "",
        body: Stack(children: [buildBackgroundPhoto(), buildForm()]),
        type: "Wardrobe Item Form");
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
            height: widget.isLocked ? 0.5 : 0.55,
            child: Padding(
                padding: widget.isLocked
                    ? const EdgeInsets.all(5)
                    : const EdgeInsets.all(5),
                child: Stack(children: [
                  Positioned.fill(
                      child: Align(
                          alignment: Alignment.center,
                          child: AbsorbPointer(
                              absorbing: widget.isLocked,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: WardrobeItemForm(
                                      photoPath: widget.photo ?? "",
                                      item: widget.editItem,
                                      showUpdateAndDeleteButtons:
                                          !widget.isLocked))))),
                  editButton()
                ]))));
  }

  bool isWardrobeItemMine() =>
      Provider.of<WardrobeManager>(context, listen: false)
          .finalWardrobeItemList
          .contains(widget.editItem);

  Widget editButton() {
    return widget.isLocked && isWardrobeItemMine()
        ? Padding(
            padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
            child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () =>
                        setState(() => widget.isLocked = !widget.isLocked),
                    icon: const Icon(Ionicons.create_outline,
                        color: ColorsConstants.grey))))
        : Container();
  }

  Widget buildBackgroundImageForAddForm() {
    return Image.file(
      File(widget.photo ?? ""),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,
    );
  }

  Widget buildBackgroundImageForEditForm(Widget picker) {
    return (!widget.isLocked
        ? picker
        : Image.network(
            widget.editItem!.photoURL,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ));
  }
}
