import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/constants.dart';
import '../services/storage.dart';

class ImagePickerButton extends StatelessWidget {
  final Function(String?) onUpdate;
  final bool canRemoveImage;

  const ImagePickerButton(
      {super.key, required this.onUpdate, this.canRemoveImage = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () =>
      {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext buildContext) {
              return SafeArea(
                child: Wrap(children: [
                  if (canRemoveImage) ...[
                    buildImageSourceOption(
                        buildContext, const Icon(Icons.delete), "Remove photo",
                        null)
                  ],
                  buildImageSourceOption(buildContext, const Icon(
                      Icons.photo_library),
                      "Gallery", ImageSource.gallery),
                  buildImageSourceOption(buildContext, const Icon(
                      Icons.photo_camera),
                      "Camera", ImageSource.camera),
                ]),
              );
            }),
      },
      child: Text(
        'Change photo',
        style: TextStyles.paragraphRegularSemiBold16(),
      ),
    );
  }

  Widget buildImageSourceOption(BuildContext context, Icon icon, String title,
      ImageSource? source) {
    return ListTile(
        leading: icon,
        title: Text(title),
        onTap: () {
          if (source != null) {
            pickImage(context, source);
          } else {
            removeImage();
          }
          Navigator.of(context).pop();
        });
  }

  Future<void> pickImage(BuildContext context, ImageSource source) async {
    final pickedFile =
    await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      var photoPath = pickedFile.path;
      String url = await StorageService().uploadFile(context, photoPath);
      onUpdate(url);
    }
  }

  void removeImage() {
    onUpdate(null);
  }
}
