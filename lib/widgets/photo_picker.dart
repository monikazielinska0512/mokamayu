import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mokamayu/constants/colors.dart';

class PhotoPicker extends StatefulWidget {
  File? photo;
  String? photoPath;
  final ImagePicker picker = ImagePicker();
  final double width;
  final double height;

  PhotoPicker({Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  _PhotoPickerState createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: widget.photo != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(
          widget.photo!,
          height: widget.height,
          fit: BoxFit.fill,
        ),
      )
          : Container(
        decoration: BoxDecoration(
            color: ColorsConstants.soft,
            borderRadius: BorderRadius.circular(20)),
        width: double.maxFinite,
        height: widget.height,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    final pickedFile =
    await widget.picker.pickImage(source: source, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        widget.photoPath = pickedFile.path;
        widget.photo = File(pickedFile.path);
      } else {
        //TODO SNACK BAR
      }
    });
  }

  Future removeImage() async {
    setState(() {
      widget.photo = null;
    });
  }

  void _showPicker(
      context,
      ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(children: <Widget>[
              widget.photo == null
                  ? Container()
                  : PickerBar(
                  context, const Icon(Icons.delete), "Remove photo", null),
              PickerBar(context, const Icon(Icons.photo_library), "Gallery",
                  ImageSource.gallery),
              PickerBar(context, const Icon(Icons.photo_camera), "Camera",
                  ImageSource.camera),
            ]),
          );
        });
  }

  Widget PickerBar(
      BuildContext context, Icon icon, String title, ImageSource? source) {
    return ListTile(
        leading: icon,
        title: Text(title),
        onTap: source != null
            ? () {
          pickImage(source);
          Navigator.of(context).pop();
        }
            : () {
          removeImage();
          Navigator.of(context).pop();
        });
  }

  File? get getPhoto {
    return widget.photo;
  }
}