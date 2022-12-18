import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/models/models.dart';
import 'package:provider/provider.dart';

import '../../widgets/fundamental/background_image.dart';
import '../../services/managers/photo_tapped_manager.dart';

class CustomDialogBox extends StatelessWidget {
  CustomDialogBox({Key? key, required this.itemList}) : super(key: key);
  Future<List<WardrobeItem>>? itemList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: SizedBox(
                    height: 260,
                    width: 310,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 25,
                                    color: Colors.grey,
                                  )),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: dialogCard("Create outfit by yourself!",
                                    () {
                                  Provider.of<PhotoTapped>(context,
                                          listen: false)
                                      .setMap({});
                                  context.goNamed("create-outfit-page",
                                      extra: itemList!);
                                  Navigator.of(context).pop();
                                }, 18, secondText: "Use your creativity!")),
                            Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: dialogCard("Generate Outfit!", () {
                                  //TO DO
                                }, 85))
                          ],
                        ))))
          ],
        ));
  }
}

Widget dialogCard(String text, Function onTap, double pad,
    {String secondText = ""}) {
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
            Image.asset(
              "assets/images/empty_dot.png",
              fit: BoxFit.fitWidth,
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: secondText == ""
                        ? Padding(
                            padding: const EdgeInsets.only(top: 13),
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                text,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    secondText,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ))
                            ],
                          ),
                  )
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
