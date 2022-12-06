import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

AppBar customAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
    actions: [
      GestureDetector(
        child: const Icon(Icons.notifications_outlined),
        onTap: () => {GoRouter.of(context).push('/notifications')},
      ),
      const Padding(padding: EdgeInsets.symmetric(horizontal: 10))
    ],
  );
}
