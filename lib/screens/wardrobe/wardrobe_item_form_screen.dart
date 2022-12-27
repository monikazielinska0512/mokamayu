import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/screens/wardrobe/form/form.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../models/wardrobe_item.dart';
import '../../services/managers/wardrobe_manager.dart';

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
    widget.isLocked = widget.isEdit == true ? true : false;
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
    return Positioned(
        child: ClipRRect(
            child: !widget.isEdit
                ? Image.file(
                    File(widget.photo ?? ""),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  )
                : Image.network(
                    widget.editItem!.photoURL,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  )));
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
                                          widget.isLocked ? false : true))))),
                  editButton()
                ]))));
  }

  Widget editButton() {
    return widget.isLocked
        ? Padding(
            padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
            child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.isLocked =
                            widget.isLocked == true ? false : true;
                      });
                    },
                    icon: const Icon(Ionicons.create_outline,
                        color: ColorsConstants.grey))))
        : Container();
  }

  Widget buildEditFormButtons() {
    return Row(children: [
      IconButton(
          onPressed: () {
            Provider.of<WardrobeManager>(context, listen: false)
                .removeWardrobeItem(widget.editItem?.reference);
            Provider.of<WardrobeManager>(context, listen: false)
                .nullListItemCopy();
            Provider.of<WardrobeManager>(context, listen: false).setTypes([]);
            Provider.of<WardrobeManager>(context, listen: false).setSizes([]);
            Provider.of<WardrobeManager>(context, listen: false).setStyles([]);
            context.go("/home/0");
          },
          icon: const Icon(Icons.delete)),
      IconButton(
          onPressed: () {
            setState(() {});
          },
          icon: const Icon(Icons.edit))
    ]);
  }
}
