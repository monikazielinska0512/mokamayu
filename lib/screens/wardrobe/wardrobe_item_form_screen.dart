import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/screens/wardrobe/form/form.dart';

class AddWardorbeItemForm extends StatefulWidget {
  final String photo;
  final String? id;

  const AddWardorbeItemForm({Key? key, required this.photo, this.id})
      : super(key: key);

  @override
  _AddWardorbeItemFormState createState() => _AddWardorbeItemFormState();
}

class _AddWardorbeItemFormState extends State<AddWardorbeItemForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            child: ClipRRect(
          child: Image.file(
            File(widget.photo),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
        )),
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
                      photoPath: widget.photo,
                    )))),
        Positioned(
            height: MediaQuery.of(context).size.height - 700,
            width: MediaQuery.of(context).size.width - 310,
            child: IconButton(
              iconSize: 30,
              color: Colors.white,
              onPressed: () {
                context.goNamed('pick-photo');
              },
              icon: Icon(Icons.arrow_back_ios),
            )),
      ],
    ));
  }
}
