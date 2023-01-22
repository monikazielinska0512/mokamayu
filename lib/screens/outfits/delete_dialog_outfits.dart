import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/widgets/widgets.dart';
import '../../generated/l10n.dart';

//ignore: must_be_immutable
class DeleteOutfitDialog extends StatelessWidget {
  Function()? onTap;
  DeleteOutfitDialog({Key? key, required Function() onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        top: false,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Stack(children: const [
                BackgroundImage(
                    imagePath: "assets/images/full_background.png",
                    imageShift: 0,
                    opacity: 0.5),
              ]),
            ),
            Dialog(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DialogCard(
                            context, "Jesteś pewny że chcesz usunąć stylizację?", onTap, 18,
                            secondText: S.of(context).for_yourself),
                      ],
                    )))
          ],
        ));
  }
}

// ignore: non_constant_identifier_names
Widget DialogCard(
    BuildContext context, String text, Function()? onTap, double pad,
    {String secondText = ""}) {
  return GestureDetector(
      onTap: onTap,
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorsConstants.whiteAccent,
              ),
              height: MediaQuery.of(context).size.height * 0.12,
              width: double.maxFinite,
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(children: [
                            const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Ionicons.radio_button_off_outline,
                                    color: ColorsConstants.darkBrick)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  text,
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyles.paragraphRegularSemiBold16(),
                                ),
                                Text(
                                  secondText,
                                  textAlign: TextAlign.center,
                                  style: TextStyles.paragraphRegular12(
                                      Colors.grey),
                                ),
                              ],
                            )
                          ]),
                        ],
                      ))))));
}
