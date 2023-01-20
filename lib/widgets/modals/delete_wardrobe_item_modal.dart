import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/widgets/widgets.dart';
import '../../generated/l10n.dart';
import '../../models/outfit.dart';
import '../../models/wardrobe_item.dart';


//ignore: must_be_immutable
class DeleteBottomModal extends StatefulWidget {
  WardrobeItem? wardrobe = WardrobeItem.init();
  Outfit? outfit;
  Function actionFunction;

  DeleteBottomModal(
      {Key? key,
      // required this.item,
      this.outfit,
      this.wardrobe,
      required this.actionFunction})
      : super(key: key);

  @override
  State<DeleteBottomModal> createState() => _DeleteBottomModalState();
}

class _DeleteBottomModalState extends State<DeleteBottomModal> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            barrierColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
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
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(children: [
                                  widget.wardrobe != null
                                      ? Text(
                                          S.of(context).ask_deletion +
                                              '${widget.wardrobe!.name} ?',
                                          textAlign: TextAlign.center,
                                          style: TextStyles.paragraphRegular18(
                                              ColorsConstants.grey))
                                      : Text(S.of(context).delete_outfit,
                                          textAlign: TextAlign.center,
                                          style: TextStyles.paragraphRegular20(
                                              ColorsConstants.grey))
                                ])),
                            ButtonDarker(context, S.of(context).delete,
                                widget.actionFunction,
                                shouldExpand: false,
                                height: 0.062,
                                width: 0.25),
                          ],
                        ),
                      ),
                    )
                  ]);
            },
          );
        },
        child: widget.wardrobe != null
            ? PhotoBox(
                object: widget.wardrobe,
                scrollVertically: true,
              )
            : PhotoCardOutfit(object: widget.outfit));
  }
}
