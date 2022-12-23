import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/widgets/widgets.dart';

import '../../constants/colors.dart';
import '../../widgets/fundamental/background_image.dart';
import '../outfits/create_outfit_dialog.dart';

class CustomCalendarDialog extends StatelessWidget {
  CustomCalendarDialog({super.key, this.selectedDay});
  String? selectedDay;

  @override
  Widget build(BuildContext context) {
    return FloatingButton(
        onPressed: () {
          _showModal(context);
        },
        icon: const Icon(Icons.add),
        backgroundColor: ColorsConstants.mint,
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
        alignment: Alignment.bottomRight);
  }

  void _showModal(
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
                    opacity: 0.3),
              ])),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            height: MediaQuery.of(context).size.height * 0.30,
            child: Center(
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0, left: 0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Ionicons.close_outline,
                              size: 25,
                              color: Colors.grey,
                            )),
                      )),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 20, left: 0),
                            child: dialogCardCalendar(
                                "Add look for ${selectedDay} :)", () {
                              Navigator.of(context).pop();
                            }, 25)),
                      ])
                ],
              ),
            ),
          )
        ]);
      },
    );
  }

  Widget dialogCardCalendar(String text, Function onTap, double pad) {
    return SizedBox(
      width: 280,
      height: 65,
      child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shadowColor: Colors.transparent,
            backgroundColor: ColorsConstants.whiteAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 13),
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )))
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: pad),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.grey,
                  )),
            ],
          )),
    );
  }
}
