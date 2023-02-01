// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import '../../services/storage.dart';
import '../buttons/button_darker_orange.dart';
import '../fundamental/background_image.dart';

class ImagePickerButton extends StatelessWidget {
  final Function(String?) onUpdate;
  final bool canRemoveImage;

  const ImagePickerButton(
      {super.key, required this.onUpdate, this.canRemoveImage = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            barrierColor: Colors.transparent,
            context: context,
            builder: (BuildContext buildContext) {
              return Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    GestureDetector(
                        onTap: () => context.pop(),
                        child: Stack(children: const [
                          BackgroundImage(
                              imagePath: "assets/images/full_background.png",
                              imageShift: 0,
                              opacity: 0.5),
                        ])),
                    Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Wrap(children: [
                              if (canRemoveImage) ...[
                                buildImageSourceOption(
                                    buildContext,
                                    const Icon(Ionicons.trash_bin_outline,
                                        color: Colors.white),
                                    S.of(context).delete_photo,
                                    null)
                              ],
                              buildImageSourceOption(
                                  buildContext,
                                  const Icon(Ionicons.images_outline,
                                      color: Colors.white),
                                  S.of(context).gallery,
                                  ImageSource.gallery),
                              buildImageSourceOption(
                                  buildContext,
                                  const Icon(Ionicons.camera_outline,
                                      color: Colors.white),
                                  S.of(context).camera,
                                  ImageSource.camera),
                            ]))),
                  ]);
            }),
      },
      child: Text(
        S.of(context).change_photo,
        style: TextStyles.paragraphRegularSemiBold14(ColorsConstants.darkMint),
      ),
    );
  }

  Widget buildImageSourceOption(
      BuildContext context, Icon icon, String title, ImageSource? source) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorsConstants.darkBrick),
            child: ListTile(
                leading: icon,
                title: Text(title,
                    style: TextStyles.paragraphRegularSemiBold14(Colors.white)),
                onTap: () {
                  if (source != null) {
                    pickImage(context, source);
                  } else {
                    removeImage();
                  }
                  Navigator.of(context).pop();
                })));
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
