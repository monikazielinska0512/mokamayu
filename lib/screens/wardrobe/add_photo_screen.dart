import 'package:flutter/material.dart';
import 'package:mokamayu/ui/widgets/basic_page.dart';
import '../../ui/widgets/photo_picker.dart';
import 'clothes_form_screen.dart';

class PhotoPickerScreen extends StatefulWidget {
  PhotoPickerScreen({Key? key}) : super(key: key);
  final PhotoPicker _picker = PhotoPicker(
    //TODO size depends on MediaQuery
      width: 370, height: 500);

  @override
  _PhotoPickerScreenState createState() => _PhotoPickerScreenState();
}

class _PhotoPickerScreenState extends State<PhotoPickerScreen> {
  @override
  Widget build(BuildContext context) {

    return BasicPage(
        context: context,
        child: Center(
            child: SizedBox(
                height: double.maxFinite,
                child: Column(children: <Widget>[
                  const BackButton(),
                  widget._picker,
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        widget._picker.photo != null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddClothesForm(photo:  widget._picker.photo)))
                            : null;
                      },
                      child: const Text("Przjedź dalej"))
                ]))));
  }
}
