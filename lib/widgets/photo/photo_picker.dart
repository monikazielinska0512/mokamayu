import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/widgets/buttons/button_darker_orange.dart';
import 'package:mokamayu/widgets/fundamental/fundamentals.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../generated/l10n.dart';

//ignore: must_be_immutable
class PhotoPicker extends StatefulWidget {
  File? photo;
  bool isEditPhotoForm;
  String? photoPath;
  String? photoURL;
  final ImagePicker picker = ImagePicker();

  File? get getPhoto => photo;
  String? get getPhotoPath => photoPath;

  void setPhoto(File? newPhoto) {
    photo = newPhoto;
  }

  void setPhotoPath(String? newPath) {
    photoPath = newPath;
  }

  PhotoPicker({Key? key, this.isEditPhotoForm = false, this.photoURL})
      : super(key: key);

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: widget.isEditPhotoForm
          ? Image.network(
              widget.photoURL ?? "",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            )
          : widget.photo != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    widget.photo!,
                    height: MediaQuery.of(context).size.height * 0.69,
                    fit: BoxFit.fill,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      color: ColorsConstants.whiteAccent,
                      borderRadius: BorderRadius.circular(20)),
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.69,
                  child: const Icon(Ionicons.camera_outline,
                      color: ColorsConstants.grey),
                ),
    ));
  }

  Future pickImage(ImageSource source) async {
    var pickedFile =
        await widget.picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        widget.photoPath = pickedFile.path;
        widget.photo = File(pickedFile.path);
        Future.delayed(const Duration(seconds: 3),
            () async => widget.photo = await compressFile(widget.photo!));
      });
    } else {
      CustomSnackBar.showErrorSnackBar(
          context: context, message: S.of(context).photo_not_added);
    }
  }

  Future<File?> compressFile(File file, {int quality = 30}) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath =
        dir.absolute.path + '/${Random().nextInt(1000)}-temp.jpg';

    return await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
    );
  }

  Future removeImage() async {
    setState(() {
      widget.photo = null;
    });
  }

  void _showPicker(
    context,
  ) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
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
                borderRadius: BorderRadius.all(Radius.circular(30))),
            height: widget.photo == null
                ? MediaQuery.of(context).size.height * 0.25
                : MediaQuery.of(context).size.height * 0.35,
            child: Column(
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      widget.photo == null
                          ? Container()
                          : buildSourceElement(
                              context, S.of(context).remove, null),
                      buildSourceElement(
                          context, S.of(context).gallery, ImageSource.gallery),
                      buildSourceElement(
                          context, S.of(context).camera, ImageSource.camera),
                    ])
              ],
            ),
          ),
        ]);
      },
    );
  }

  Widget buildSourceElement(
      BuildContext context, String title, ImageSource? source) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ButtonDarker(
            context,
            title,
            source != null
                ? () {
                    pickImage(source);
                    Navigator.of(context).pop();
                  }
                : () {
                    removeImage();
                    Navigator.of(context).pop();
                  },
            shouldExpand: false,
            height: 0.06,
            width: 0.8,
            margin: const EdgeInsets.all(0)));
  }
}
