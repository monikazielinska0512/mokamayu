import 'package:flutter/material.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:provider/provider.dart';

AppBar customAppBar(BuildContext context, String title) {
  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Provider.of<AppStateManager>(context, listen: false).logout();
        break;
    }
  }
  return AppBar(
    backgroundColor: Colors.white,
    title: Text(title),
    actions: [
      PopupMenuButton<int>(
          onSelected: (item) => onSelected(context, item),
          itemBuilder: (context) =>
          [
            const PopupMenuItem(
              value: 0,
              child: Text('Sign out'),
            )
          ])
    ],
  );
}
