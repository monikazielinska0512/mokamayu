// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../../services/managers/wardrobe_manager.dart';
import 'icon_button.dart';

IconButton BackArrowButton(BuildContext context, {String? backPath}) {
  return IconButton(
    onPressed: () {
      Provider.of<WardrobeManager>(context, listen: false).blockEdit(false);
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
  return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: CustomIconButton(
          width: 0.12,
          onPressed: () => context.push('/notifications'),
          icon: Ionicons.notifications_outline,
          backgroundColor: Colors.transparent,
          iconColor: Colors.black));
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
  return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomIconButton(
                width: 0.12,
                onPressed: () => context.push('/find-users'),
                icon: Ionicons.search_outline,
                backgroundColor: Colors.transparent,
                iconColor: Colors.black),
            NotificationsButton(context)
          ]));
}

Widget GoForwardButton(Function() onPressed) {
  return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: IconButton(
        color: Colors.black,
        onPressed: onPressed,
        icon: const Icon(
          size: 35,
          Ionicons.chevron_forward,
        ),
      ));
}
