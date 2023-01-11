import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/authentication/auth.dart';
import 'package:provider/provider.dart';

import '../../services/managers/managers.dart';
import '../../widgets/widgets.dart';

class FriendDialogBox extends StatelessWidget {
  FriendDialogBox({Key? key, required this.friend, required this.isResponse}) : super(key: key);
  UserData friend;
  bool isResponse;

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
                                child:
                                isResponse
                                  ? friendDialogCard("Reject invite",
                                          () {
                                            Provider.of<ProfileManager>(context, listen: false).rejectFriendInvite(friend);
                                            context.pop();
                                      }, 18)
                                   : friendDialogCard("Delete friend",
                                        () {
                                      Provider.of<ProfileManager>(context, listen: false).removeFriend(friend);
                                      context.pop();
                                    }, 18),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child:
                                isResponse
                                    ? friendDialogCard("Accept invite", () {
                                      Provider.of<ProfileManager>(context, listen: false).acceptFriendInvite(friend);
                                      CustomNotification notif = CustomNotification(
                                          sentFrom: AuthService().getCurrentUserID(),
                                          type: NotificationType.RECEIVED_INVITE.toString(),
                                          creationDate: DateTime.now().millisecondsSinceEpoch
                                      );
                                      Provider.of<NotificationsManager>(context, listen: false).addNotificationToFirestore(notif, friend.uid);
                                      context.pop();
                                    }, 85)
                                    : friendDialogCard("No, take me back",
                                        () {
                                      context.pop();
                                    }, 18),
                                )
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
