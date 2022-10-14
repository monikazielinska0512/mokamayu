import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key}) : super(key: key);
  @override
  _ImageUploadState createState() => _ImageUploadState();
}
class _ImageUploadState extends State<ImageUpload> {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future pickImageFromGallery() async {
    final pickImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickImage != null) {
        _image = File(pickImage.path);
      } else {
        print('No image selected');
      }
    });
  }
  Future imageFromCamera() async {
    final pickImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickImage != null) {
        _image = File(pickImage.path);
      } else {
        print('No image selected.');
      }
    });
  }
  Future uploadFile() async {
    if (_image == null) return;
    final fileName = basename(_image!.path);
    final destination = 'clothes/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      await ref.putFile(_image!);
    } catch (e) {
      print('Error Occured');
    }
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
                ?
            Column(
            children: <Widget>[
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
    icon: const Icon(Icons.close)
    )
    ])
                : Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200]),
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
                    imageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      pickImageFromGallery();
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          );
        });
  }
}