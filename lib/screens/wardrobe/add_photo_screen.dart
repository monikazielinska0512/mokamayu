import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/widgets/widgets.dart';

class AddPhotoScreen extends StatefulWidget {
  AddPhotoScreen({Key? key}) : super(key: key);
  final PhotoPicker _picker = PhotoPicker(width: 370, height: 620);

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return BasicScreen(
        type: "add_photo",
        isRightButtonVisible: false,
        context: context,
        isFullScreen: true,
        body: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          Stack(children: const [
            BackgroundImage(
              imagePath: "assets/images/full_background.png",
              imageShift: 0,
              opacity: 0.7,
            )
          ]),
          BackgroundCard(
            context: context,
            height: 0.88,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
                child: Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: SizedBox(
                        height: double.maxFinite,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              widget._picker,
                              const SizedBox(height: 10),
                              buildButton()
                            ])))),
          )
        ]));
  }

  Widget buildButton() {
    return ButtonDarker(context, "Next", () {
      widget._picker.photo != null
          ? context.goNamed(
              'add-wardrobe-item',
              params: {
                'file': widget._picker.photoPath as String,
              },
            )
          : null;
    }, shouldExpand: false, width: 0.41, height: 0.061);
  }
}
