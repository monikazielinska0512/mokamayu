import 'package:flutter/material.dart';
import 'package:mokamayu/widgets/buttons/back_button.dart';

import '../../constants/constants.dart';
import '../../widgets/widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final title = 'Notifications';

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
      type: title,
      leftButton: BackArrowButton(context),
      isRightButtonVisible: false,
      context: context,
      isFullScreen: true,
      body: Stack(children: [
        const BackgroundImage(
            imagePath: "assets/images/full_background.png", imageShift: 0),
        Positioned(
          bottom: 0,
          child: BackgroundCard(
            context: context,
            height: 0.8,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: buildEmptyScreen(context),
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
            ),
          ),
        ),
      ],
    );
  }
}
