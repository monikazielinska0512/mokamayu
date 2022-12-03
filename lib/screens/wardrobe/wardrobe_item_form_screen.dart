import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/screens/wardrobe/form/form.dart';
import '../../models/wardrobe_item.dart';

class AddWardrobeItemForm extends StatefulWidget {
  final bool isEdit;
  final String? photo;
  WardrobeItem? editItem;

  AddWardrobeItemForm(
      {Key? key, this.photo, this.editItem, required this.isEdit})
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
                    child: WardrobeItemForm(
                        photoPath: widget.photo ?? "",
                        item: widget.editItem)))),
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
