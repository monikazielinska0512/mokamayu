import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/screens/wardrobe/form/form.dart';
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
    widget.isLocked = (widget.isEdit == true ? true : false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isLocked);
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
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
                      ))),
        Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 20,
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40)),
                    ),
                    child: Column(children: [
                      widget.isEdit
                          ? Row(children: [
                              IconButton(
                                  onPressed: () {
                                    Provider.of<WardrobeManager>(context,
                                            listen: false)
                                        .removeWardrobeItem(
                                            widget.editItem?.reference);
                                    context.go("/home/0");
                                  },
                                  icon: const Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.isLocked = false;
                                      print(widget.isLocked);
                                    });
                                  },
                                  icon: const Icon(Icons.edit))
                            ])
                          : Container(),
                      AbsorbPointer(
                          absorbing: widget.isLocked!,
                          child: WardrobeItemForm(
                              photoPath: widget.photo ?? "",
                              item: widget.editItem))
                    ])))),
        Positioned(
            height: MediaQuery.of(context).size.height - 700,
            width: MediaQuery.of(context).size.width - 310,
            child: IconButton(
              iconSize: 30,
              color: Colors.white,
              onPressed: () {
                widget.isEdit
                    ? context.go("/home/0")
                    : context.go("/pick-photo");
              },
              icon: Icon(Icons.arrow_back_ios),
            )),
      ],
    ));
  }
}
