import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/appbar.dart';

class AddClothesForm extends StatefulWidget {
  final File? photo;

  const AddClothesForm({Key? key, required this.photo}) : super(key: key);

  @override
  _AddClothesFormState createState() => _AddClothesFormState();
}

class _AddClothesFormState extends State<AddClothesForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, "Add clothes"),
        body: Image.file(
          widget.photo!,
          width: 370,
          height: 650,
          fit: BoxFit.fill,
        ));
  }
}
