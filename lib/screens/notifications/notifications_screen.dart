import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/models/models.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import '../../services/managers/managers.dart';
import '../../widgets/widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<CustomNotification> notificationList = [];
  List<UserData> userList = [];

  @override
  void initState() {
    super.initState();
    Provider.of<NotificationsManager>(context, listen: false)
        .readNotificationsOnce()
        .then((value) {
      setState(() => notificationList = value);
    });
    userList = Provider.of<UserListManager>(context, listen: false).getUserList;
  }

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
      title: S.of(context).notifications,
      leftButton: BackArrowButton(context),
      rightButton: null,
      context: context,
      isFullScreen: true,
      body: Stack(children: [
        const BackgroundImage(
          imagePath: "assets/images/full_background.png",
          imageShift: 300,
          opacity: 0.5,
        ),
        Positioned(
          bottom: 0,
          child: BackgroundCard(
            context: context,
            height: 0.85,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: notificationList.isEmpty
                  ? EmptyScreen(
                      context,
                      Text(S.of(context).empty_notifications),
                      ColorsConstants.lightSunflower)
                  : buildNotificationScreen(context, notificationList),
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildNotificationScreen(
      BuildContext context, List<CustomNotification> notificationList) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(notificationList[index].reference!),
            onDismissed: (direction) {
              Provider.of<NotificationsManager>(context, listen: false)
                  .deleteNotification(notificationList[index].reference!);
              setState(() {
                notificationList.removeAt(index);
              });
            },
            background: Container(color: ColorsConstants.darkBrick),
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorsConstants.whiteAccent),

                // height: MediaQuery.of(context).size.height * 0.1,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: buildNotifications(
                        context, notificationList[index], userList))),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            Container(height: 10),
        itemCount: notificationList.length);
  }

  Widget buildNotifications(
      BuildContext context, CustomNotification notif, List<UserData> userList) {
    UserData user =
        userList.singleWhere((element) => element.uid == notif.sentFrom);
    String name = user.profileName != null ? user.profileName! : user.username;
    switch (notif.type) {
      case "NotificationType.LIKE":
        {
          return GestureDetector(
              onTap: () {
                Provider.of<NotificationsManager>(context, listen: false)
                    .deleteNotification(notif.reference!);
                context.push('/home/4');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Ionicons.thumbs_up_outline,
                    color: ColorsConstants.darkBrick,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Flexible(
                      child: Text(
                          "${S.of(context).user} ${name} ${S.of(context).liked_your_post}",
                          style: TextStyles.paragraphRegular14())),
                ],
              ));
        }
      case "NotificationType.COMMENT":
        {
          return GestureDetector(
              onTap: () {
                Provider.of<NotificationsManager>(context, listen: false)
                    .deleteNotification(notif.reference!);
                context.push('/home/4');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Ionicons.text,
                    color: ColorsConstants.darkBrick,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Flexible(
                      child: Text(
                          "${S.of(context).user} ${name} ${S.of(context).commented_on_your_post}",
                          style: TextStyles.paragraphRegular14())),
                ],
              ));
        }
      case "NotificationType.NEW_OUTFIT":
        {
          return GestureDetector(
              onTap: () {
                Provider.of<NotificationsManager>(context, listen: false)
                    .deleteNotification(notif.reference!);
                context.push('/home/1');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Ionicons.body_outline,
                    color: ColorsConstants.darkBrick,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Flexible(
                      child: Text(
                          "${S.of(context).user} ${name} ${S.of(context).created_outfit_for_you}",
                          style: TextStyles.paragraphRegular14())),
                ],
              ));
        }
      case "NotificationType.ACCEPTED_INVITE":
        {
          return GestureDetector(
              onTap: () {
                Provider.of<NotificationsManager>(context, listen: false)
                    .deleteNotification(notif.reference!);
                context.pushNamed(
                  "profile",
                  queryParams: {
                    'uid': notif.sentFrom,
                  },
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Ionicons.checkmark_circle_outline,
                    color: ColorsConstants.darkBrick,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Flexible(
                      child: Text(
                          "${S.of(context).you_and_user} $name ${S.of(context).are_now_friends}",
                          style: TextStyles.paragraphRegular14())),
                ],
              ));
        }
      case "NotificationType.RECEIVED_INVITE":
        {
          return GestureDetector(
              onTap: () {
                Provider.of<NotificationsManager>(context, listen: false)
                    .deleteNotification(notif.reference!);
                context.pushNamed(
                  "profile",
                  queryParams: {
                    'uid': notif.sentFrom,
                  },
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Ionicons.mail_unread_outline,
                    color: ColorsConstants.darkBrick,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Flexible(
                      child: Text(
                          "Masz zaproszenie do znajomych od użytkownika $name!",
                          style: TextStyles.paragraphRegular14())),
                ],
              ));
        }
      default:
        {
          return const Text("Błąd");
        }
    }
  }
}
