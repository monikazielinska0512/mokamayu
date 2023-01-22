import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/widgets/widgets.dart';
import '../../generated/l10n.dart';

class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({Key? key}) : super(key: key);

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  @override
  Widget build(BuildContext context) {
    final PhotoPicker picker = PhotoPicker();
    return BasicScreen(
        title: "",
        rightButton: null,
        leftButton: BackArrowButton(context),
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
                              picker,
                              const SizedBox(height: 10),
                              buildButton(picker)
                            ])))),
          )
        ]));
  }

  Widget buildButton(PhotoPicker picker) {
    return ButtonDarker(context, S.of(context).next, () {
      picker.photo != null
          ? context.pushNamed(
              'add-wardrobe-item',
              params: {
                'file': picker.photoPath as String,
              },
            )
          : CustomSnackBar.showErrorSnackBar(
          context: context, message: S.of(context).photo_not_added);
    }, shouldExpand: false, width: 0.41, height: 0.061);
  }
}
