import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/screens/wardrobe/form/form.dart';
import 'package:mokamayu/widgets/fundamental/background_card.dart';
import 'package:mokamayu/widgets/fundamental/basic_page.dart';
import 'package:provider/provider.dart';
import '../../models/wardrobe_item.dart';
import '../../services/managers/wardrobe_manager.dart';

class AddWardrobeItemForm extends StatefulWidget {
  final bool? disableFields;
  final bool isEdit;
  bool? isLocked;
  final String? photo;

  WardrobeItem? editItem;

  AddWardrobeItemForm(
      {Key? key,
      this.photo,
      this.editItem,
      required this.isEdit,
      this.disableFields})
      : super(key: key);

  @override
  State<AddWardrobeItemForm> createState() => _AddWardrobeItemFormState();
}

class _AddWardrobeItemFormState extends State<AddWardrobeItemForm> {
  @override
  void initState() {
    widget.isLocked = (widget.isEdit == true ? false : true);
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
        type: "wardrobe_item_form");
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
          height: 0.6,
          child: AbsorbPointer(
            absorbing: false,
            child: WardrobeItemForm(
                photoPath: widget.photo ?? "", item: widget.editItem),
          )),
    );
  }

  Widget buildEditFormButtons() {
    return Row(children: [
      IconButton(
          onPressed: () {
            Provider.of<WardrobeManager>(context, listen: false)
                .removeWardrobeItem(widget.editItem?.reference);
            context.go("/home/0");
          },
          icon: const Icon(Icons.delete)),
      IconButton(
          onPressed: () {
            setState(() {
              widget.isLocked = false;
            });
          },
          icon: const Icon(Icons.edit))
    ]);
  }
}
