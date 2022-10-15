import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePick extends StatefulWidget {
  const ImagePick({Key? key}) : super(key: key);

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {

  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future pickImage(ImageSource source) async {
    final pickImage = await _picker.pickImage(source: source);
    setState(() {
      if (pickImage != null) {
        _image = File(pickImage.path);
      } else {print('No image selected');}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 32,
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: _image != null
                ? Column(children: <Widget>[
                    ClipRRect(
                      child: Image.file(
                        _image!,
                        width: 400,
                        height: 400,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _image = null; //this is important
                          });
                        },
                        label: const Text('Remove Image'),
                        icon: const Icon(Icons.close))
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
          ),
        ),
      ],
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
}
