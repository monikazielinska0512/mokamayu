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
                  child: GestureDetector(
                    onTap: () {
                      switch (notificationList[index].type) {
                        case "NotificationType.LIKE":
                          {
                            late Post post;
                            late UserData user;
                            Provider.of<PostManager>(context, listen: true)
                                .getPostByUid(
                                    notificationList[index].additionalData!)
                                .then((Post? temp) {
                              setState(() => post = temp!);
                              user = userList.singleWhere(
                                  (element) => element.uid == temp!.createdBy);
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PostScreen(
                                          post: post,
                                          user: user,
                                          userList: userList,
                                        )));
                            Provider.of<NotificationsManager>(context,
                                    listen: false)
                                .notificationRead(
                                    notificationList[index].reference!);
                            break;
                          }
                        case "NotificationType.COMMENT":
                          {
                            late Post post;
                            late UserData user;
                            Provider.of<PostManager>(context, listen: true)
                                .getPostByUid(
                                    notificationList[index].additionalData!)
                                .then((Post? temp) {
                              setState(() => post = temp!);
                              user = userList.singleWhere(
                                  (element) => element.uid == temp!.createdBy);
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PostScreen(
                                          post: post,
                                          user: user,
                                          userList: userList,
                                        )));
                            Provider.of<NotificationsManager>(context,
                                    listen: false)
                                .notificationRead(
                                    notificationList[index].reference!);
                            break;
                          }
                        case "NotificationType.NEW_OUTFIT":
                          {
                            Provider.of<NotificationsManager>(context,
                                    listen: false)
                                .notificationRead(
                                    notificationList[index].reference!);
                            return context.go('/home/2');
                          }
                        case "NotificationType.ACCEPTED_INVITE":
                          {
                            Provider.of<NotificationsManager>(context,
                                    listen: false)
                                .notificationRead(
                                    notificationList[index].reference!);
                            return context.pushNamed(
                              "profile",
                              queryParams: {
                                'uid': notificationList[index].sentFrom,
                              },
                            );
                          }
                        case "NotificationType.RECEIVED_INVITE":
                          {
                            Provider.of<NotificationsManager>(context,
                                    listen: false)
                                .notificationRead(
                                    notificationList[index].reference!);
                            return context.pushNamed(
                              "profile",
                              queryParams: {
                                'uid': notificationList[index].sentFrom,
                              },
                            );
                          }
                        default:
                          {}
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(
                          Icons.notifications_none_outlined,
                          color: ColorsConstants.darkBrick,
                        ),
                        buildNotifText(notificationList[index].type,
                            notificationList[index].sentFrom),
                      ],
                    ),
                  ));
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: notificationList.length));
  }

  Widget buildNotifText(String type, String data) {
    switch (type) {
      case "NotificationType.LIKE":
        {
          UserData user =
              userList.singleWhere((element) => element.uid == data);
          String name =
              user.profileName != null ? user.profileName! : user.username;
          return Text("$name liked your post!", style: TextStyles.paragraphRegularSemiBold14(),);
        }
      case "NotificationType.COMMENT":
        {
          UserData user =
              userList.singleWhere((element) => element.uid == data);
          String name =
              user.profileName != null ? user.profileName! : user.username;
          return Text("$name commented on your post!", style: TextStyles.paragraphRegularSemiBold14());
        }
      case "NotificationType.NEW_OUTFIT":
        {
          UserData user =
              userList.singleWhere((element) => element.uid == data);
          String name =
              user.profileName != null ? user.profileName! : user.username;
          return Text("$name created an outfit for you!", style: TextStyles.paragraphRegularSemiBold14());
        }
      case "NotificationType.ACCEPTED_INVITE":
        {
          UserData user =
              userList.singleWhere((element) => element.uid == data);
          String name =
              user.profileName != null ? user.profileName! : user.username;
          return Text("You and $name are now friends!", style: TextStyles.paragraphRegularSemiBold14());
        }
      case "NotificationType.RECEIVED_INVITE":
        {
          UserData user =
              userList.singleWhere((element) => element.uid == data);
          String name =
              user.profileName != null ? user.profileName! : user.username;
          return Text("New friend invite from $name!", style: TextStyles.paragraphRegularSemiBold14());
        }
      default:
        {
          return const Text("Unexpected error has occured");
        }
    }
  }
}
