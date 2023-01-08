import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/models/models.dart';
import 'package:provider/provider.dart';

import '../../services/managers/managers.dart';
import '../../widgets/widgets.dart';

class FriendDialogBox extends StatelessWidget {
  FriendDialogBox({Key? key, required this.friend}) : super(key: key);
  UserData friend;

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
                                    context.pop();
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 25,
                                    color: Colors.grey,
                                  )),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: friendDialogCard("Reject invite",
                                        () {
                                          Provider.of<ProfileManager>(context, listen: false).rejectFriendInvite(friend);
                                          context.pop();
                                    }, 18)),
                            Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: friendDialogCard("Accept invite", () {
                                  Provider.of<ProfileManager>(context, listen: false).acceptFriendInvite(friend);
                                  context.pop();
                                }, 85))
                          ],
                        ))))
          ],
        ));
  }
}

Widget friendDialogCard(String text, Function onTap, double pad) {
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
                    child:
                      Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )
                      )
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