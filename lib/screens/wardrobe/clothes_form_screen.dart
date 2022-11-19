import 'dart:io';
import 'package:flutter/material.dart';

import 'package:mokamayu/ui/widgets/widgets.dart';

class AddClothesForm extends StatefulWidget {
  final File? photo;
  final String? id;

  const AddClothesForm({Key? key, required this.photo, this.id})
      : super(key: key);

  @override
  _AddClothesFormState createState() => _AddClothesFormState();
}

class _AddClothesFormState extends State<AddClothesForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        ClipRRect(
          child: Image.file(
            widget.photo!,
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
        ),
        const BackButton(),
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
                    child: ClothesForm(photo: widget.photo!))))
      ],
    ));
  }
}
