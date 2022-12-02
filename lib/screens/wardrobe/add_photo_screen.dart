import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/widgets/widgets.dart';

class AddPhotoScreen extends StatefulWidget {
  AddPhotoScreen({Key? key}) : super(key: key);
  final PhotoPicker _picker = PhotoPicker(width: 370, height: 500);

  @override
  _AddPhotoScreenState createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return BasicScreen(
      type: "add_photo",
        context: context,
        child: Center(
            child: SizedBox(
                height: double.maxFinite,
                child: Column(children: <Widget>[
                  widget._picker,
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        widget._picker.photo != null
                            ? context.goNamed(
                                'add-wardrobe-item',
                                params: {
                                  'file': widget._picker.photoPath as String,
                                },
                              )
                            : null;
                      },
                      child: const Text("Przejedź dalej"))
                ]))));
  }
}
