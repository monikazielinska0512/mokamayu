import 'package:flutter/material.dart';
import 'package:mokamayu/widgets/basic_page.dart';
import '../../../widgets/photo_picker.dart';
import 'add_clothes_form.dart';

class PhotoPickerScreen extends StatefulWidget {
  final PhotoPicker _picker = PhotoPicker(width: 370, height: 600);

  PhotoPickerScreen({Key? key}) : super(key: key);

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
                  widget._picker,
                  TextButton(
                      onPressed: () {
                        widget._picker.photo != null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddClothesForm(
                                        photo: widget._picker.photo)))
                            : null;
                      },
                      child: Text("elo"))
                ]))));
  }
}

// Padding(
//     padding: const EdgeInsets.all(20.0),
//     child: ElevatedButton(
//         onPressed: () {
// //           print(_picker.photo);
// //         },
//         child: const Text("Przejdź dalej"))),
// // child: ElevatedButton(
//     onPressed:
// //     child: const Text("Przejdź dalej"))),
