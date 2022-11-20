import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/services/managers/managers.dart';

AppBar customAppBar(BuildContext context, String title) {
  // final AuthService _auth = AuthService();

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        // _auth.signOut();
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => const LoginScreen()));
        Provider.of<AppStateManager>(context, listen: false).logout();
        break;
    }
  }

  return AppBar(
    title: Text(title),
    actions: [
      PopupMenuButton<int>(
          onSelected: (item) => onSelected(context, item),
          itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 0,
                  child: Text('Sign out'),
                )
              ])
    ],
  );
}
