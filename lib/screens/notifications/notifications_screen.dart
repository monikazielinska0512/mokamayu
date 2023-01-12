import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/models.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../services/managers/managers.dart';
import 'package:mokamayu/screens/screens.dart';
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
      type: title,
      leftButtonType: "back",
      isRightButtonVisible: false,
      context: context,
      isFullScreen: true,
      body: Stack(children: [
        const BackgroundImage(
            imagePath: "assets/images/full_background.png", imageShift: 0, opacity: 0.5,),
        Positioned(
          bottom: 0,
          child: BackgroundCard(
            context: context,
            height: 0.8,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: notificationList.isEmpty
                  ? buildEmptyScreen(context)
                  : buildNotificationScreen(context, notificationList),
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildEmptyScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "It seems you don't have any notifications",
          style: TextStyles.paragraphRegularSemiBold18(ColorsConstants.grey),
          textAlign: TextAlign.center,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/woman.png"),
                fit: BoxFit.fitWidth,
                opacity: 0.5),
          ),
        ),
      ],
    );
  }

  Widget buildNotificationScreen(
      BuildContext context, List<CustomNotification> notificationList) {
    return Expanded(
        child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  padding: const EdgeInsets.all(10),
                  color: ColorsConstants.whiteAccent,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: buildNotifications(context, notificationList[index], userList),
                  );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: notificationList.length));
  }

  Widget buildNotifications(BuildContext context, CustomNotification notif, List<UserData> userList){
    UserData user = userList.singleWhere((element) => element.uid == notif.sentFrom);
    String name = user.profileName != null ? user.profileName! : user.username;
    switch (notif.type) {
      case "NotificationType.LIKE":
        {
          return GestureDetector(
              onTap: () {
                Provider.of<NotificationsManager>(context,
                    listen: false)
                    .notificationRead(
                    notif.reference!);
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
                Text("$name liked your post!", style: TextStyles.paragraphRegularSemiBold14()),
                ],
              )
          );
        }
      case "NotificationType.COMMENT":
        {
        return GestureDetector(
          onTap: () {
            Provider.of<NotificationsManager>(context,
                listen: false)
                .notificationRead(
                notif.reference!);
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
              Text("$name commented on your post!", style: TextStyles.paragraphRegularSemiBold14()),
            ],
          )
        );
        }
      case "NotificationType.NEW_OUTFIT":
        {
        return GestureDetector(
          onTap: () {
            Provider.of<NotificationsManager>(context,
                listen: false)
                .notificationRead(
                notif.reference!);
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
            Text("$name created an outfit for you!", style: TextStyles.paragraphRegularSemiBold14()),
            ],
          )
        );
        }
      case "NotificationType.ACCEPTED_INVITE":
        {
        return GestureDetector(
          onTap: () {
            Provider.of<NotificationsManager>(context,
                listen: false)
                .notificationRead(
                notif.reference!);
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
                Icons.notifications_none_outlined,
                color: ColorsConstants.darkBrick,
              ),
              Text("You and $name are now friends!", style: TextStyles.paragraphRegularSemiBold14()),
              ],
            )
          );
        }
      case "NotificationType.RECEIVED_INVITE":
        {
        return GestureDetector(
          onTap: () {
            Provider.of<NotificationsManager>(context,
                listen: false)
                .notificationRead(
                notif.reference!);
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
                Icons.notifications_none_outlined,
                color: ColorsConstants.darkBrick,
              ),
              Text("New friend invite from $name!", style: TextStyles.paragraphRegularSemiBold14()),
            ],
          )
        );
        }
      default:
        {
          return const Text("Unexpected error has occured");
        }
    }
  }
}
