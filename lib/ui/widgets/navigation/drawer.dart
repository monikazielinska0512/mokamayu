import 'package:flutter/material.dart';
import 'package:mokamayu/ui/widgets/user/user_summary.dart';

import '../../../screens/authenticate/login_screen.dart';
import '../../../services/authentication/auth.dart';

Drawer drawer(BuildContext context) {
  AuthService _auth = AuthService();

  return Drawer(
      child: ListView(
    children: [
      DrawerHeader(
        child: userSummary(context, _auth.currentUser, imageRadius: 40),
      ),
      ListTile(
        title: const Text('Settings'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: const Text('My friends'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: const Text('Edit profile'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: const Text('Notifications'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: const Text('Sign out'),
        onTap: () {
          Navigator.pop(context);
          _auth.signOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
      ),
    ],
  ));
}
