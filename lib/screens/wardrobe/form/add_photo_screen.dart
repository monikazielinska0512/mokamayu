import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/basic_page.dart';
import '../../../reusable_widgets/photo_picker.dart';
import 'add_clothes_form.dart';

class PhotoPickerScreen extends StatefulWidget {
  final PhotoPicker _picker = PhotoPicker(width: 370, height: 600);


  PhotoPickerScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return BasicPage(
        context: context,
        child: Center(
            child: SizedBox(
                height: double.maxFinite,
                child: Column(children: <Widget>[
                  _picker,
                  TextButton(
                      onPressed: () {
                        print(_picker.photo);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddClothesForm(
                                          photo: _picker.photo)));
                            },
                      child: Text("elo"))
                ]))));
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
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
