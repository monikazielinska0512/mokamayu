import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PickerImage extends StatefulWidget {
  Image? pickedImage;

  PickerImage({Key? key, required this.pickedImage}) : super(key: key);

  @override
  _PickerImageState createState() => _PickerImageState();
}

class _PickerImageState extends State<PickerImage> {
  late Image? pickedImage = widget.pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: pickedImage != null
          ? Column(children: <Widget>[
              ClipRRect(child: pickedImage),
            ])
          : Container(
              decoration: BoxDecoration(color: Colors.grey[200]),
              width: 300,
              height: 400,
              child: Icon(
                Icons.camera_alt,
                color: Colors.grey[800],
              ),
            ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          );
        });
  }

  Future pickImage(ImageSource source) async {
    final pickImage = await _picker.pickImage(source: source);
    setState(() {
      if (pickImage != null) {
        pickedImage = Image.file(File(pickImage.path));
      } else {
        Fluttertoast.showToast(
            msg: "No image selected",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }

  Image? getPickedImage() {
    return pickedImage;
  }
}
