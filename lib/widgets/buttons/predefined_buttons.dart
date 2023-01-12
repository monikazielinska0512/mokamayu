import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import 'icon_button.dart';

IconButton BackArrowButton(BuildContext context, {String? backPath}) {
  return IconButton(
    onPressed: () {
      backPath != null ? context.go(backPath) : context.pop();
    },
    icon: const Icon(Ionicons.chevron_back, size: 35),
  );
}

IconButton DotsButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      Scaffold.of(context).openDrawer();
    },
    icon: const Icon(Icons.more_vert),
  );
}

Widget NotificationsButton(BuildContext context) {
  return CustomIconButton(
      onPressed: () => context.push('/notifications'),
      icon: Ionicons.notifications_outline,
      backgroundColor: Colors.transparent,
      iconColor: Colors.black);
}

Widget AddButton(BuildContext context, Function() onPressed) {
  return IconButton(
    color: Colors.black,
    iconSize: 30,
    onPressed: onPressed,
    icon: const Icon(
      Ionicons.add,
    ),
  );
}

Widget SearchNotificationButton(BuildContext context) {
  return Row(children: [
    CustomIconButton(
        onPressed: () => context.push('/find-users'),
        icon: Icons.search,
        backgroundColor: Colors.transparent,
        iconColor: Colors.grey),
    CustomIconButton(
        onPressed: () => context.push('/notifications'),
        icon: Icons.notifications,
        backgroundColor: Colors.transparent,
        iconColor: Colors.grey)
  ]);
}

Widget GoForwardButton(Function() onPressed) {
  return IconButton(
    color: Colors.black,
    onPressed: onPressed,
    icon: const Icon(
      Icons.arrow_forward,
    ),
  );
}
