import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/widgets/buttons/predefined_buttons.dart';

import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/models.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import '../../services/managers/notifications_manager.dart';
import '../../services/managers/user_list_manager.dart';
import '../../widgets/widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final title = 'Notifications';
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
      title: 'Notifications',
      leftButton: BackArrowButton(context),
      rightButton: null,
      context: context,
      isFullScreen: true,
      body: Stack(children: [
        const BackgroundImage(
          imagePath: "assets/images/full_background.png",
          imageShift: 100,
          opacity: 0.5,
        ),
        Positioned(
          bottom: 0,
          child: BackgroundCard(
            context: context,
            height: 0.85,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: notificationList.isEmpty
                  ? buildEmptyScreen()
                  : buildNotificationScreen(context, notificationList),
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildEmptyScreen() {
    return Container(
        decoration: BoxDecoration(
            color: ColorsConstants.peachy.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        height: double.maxFinite,
        width: double.maxFinite,
        child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              const Icon(
                Ionicons.sad_outline,
                size: 25,
                color: Colors.grey,
              ),
              Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(S.of(context).empty_notifications,
                      textAlign: TextAlign.center,
                      style: TextStyles.paragraphRegular14(Colors.grey)))
            ])));
  }

  Widget buildNotificationScreen(
      BuildContext context, List<CustomNotification> notificationList) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorsConstants.whiteAccent),
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.1,
            child:
                buildNotifications(context, notificationList[index], userList),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            Container(height: 10),
        itemCount: notificationList.length);
  }

  Widget buildNotifications(BuildContext context,
      CustomNotification notification, List<UserData> userList) {
    UserData user =
        userList.singleWhere((element) => element.uid == notification.sentFrom);
    String name = user.profileName != null ? user.profileName! : user.username;
    switch (notification.type) {
      case "NotificationType.LIKE":
        {
          return GestureDetector(
              onTap: () {
                Provider.of<NotificationsManager>(context, listen: false)
                    .notificationRead(notification.reference!);
                context.go('/home/4');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Icons.notifications_none_outlined,
                    color: ColorsConstants.darkBrick,
                  ),
                  Text("$name liked your post!",
                      style: TextStyles.paragraphRegularSemiBold14()),
                ],
              ));
        }
      case "NotificationType.COMMENT":
        {
          return GestureDetector(
              onTap: () {
                Provider.of<NotificationsManager>(context, listen: false)
                    .notificationRead(notification.reference!);
                context.go('/home/4');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Ionicons.chatbox_ellipses_outline,
                        color: ColorsConstants.darkBrick,
                      )),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("You have new comment!",
                            style: TextStyles.paragraphRegularSemiBold14()),
                        Text("$name commented on your post!",
                            style: TextStyles.paragraphRegular14())
                      ])
                ],
              ));
        }
      case "NotificationType.NEW_OUTFIT":
        {
          return GestureDetector(
              onTap: () {
                Provider.of<NotificationsManager>(context, listen: false)
                    .notificationRead(notification.reference!);
                context.go('/home/1');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Icons.notifications_none_outlined,
                    color: ColorsConstants.darkBrick,
                  ),
                  Text("$name created an outfit for you!",
                      style: TextStyles.paragraphRegularSemiBold14()),
                ],
              ));
        }
      case "NotificationType.ACCEPTED_INVITE":
        {
          return GestureDetector(
              onTap: () {
                Provider.of<NotificationsManager>(context, listen: false)
                    .notificationRead(notification.reference!);
                context.pushNamed(
                  "profile",
                  queryParams: {
                    'uid': notification.sentFrom,
                  },
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Icons.notifications_none_outlined,
                    color: ColorsConstants.darkBrick,
                  ),
                  Text("You and $name are now friends!",
                      style: TextStyles.paragraphRegularSemiBold14()),
                ],
              ));
        }
      case "NotificationType.RECEIVED_INVITE":
        {
          return GestureDetector(
              onTap: () {
                Provider.of<NotificationsManager>(context, listen: false)
                    .notificationRead(notification.reference!);
                context.pushNamed(
                  "profile",
                  queryParams: {
                    'uid': notification.sentFrom,
                  },
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Icons.notifications_none_outlined,
                    color: ColorsConstants.darkBrick,
                  ),
                  Text("New friend invite from $name!",
                      style: TextStyles.paragraphRegularSemiBold14()),
                ],
              ));
        }
      default:
        {
          return const Text("Unexpected error has occured");
        }
    }
  }
}
