import 'package:flutter/material.dart';

import '../screens/authenticate/login_screen.dart';
import '../services/authentication/auth.dart';

AppBar customAppBar(BuildContext context, String title) {
  final AuthService _auth = AuthService();

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        _auth.signOut();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
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
