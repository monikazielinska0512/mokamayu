import 'package:flutter/material.dart';
import 'package:mokamayu/services/services.dart';
import 'package:provider/provider.dart';

Drawer drawer(BuildContext context) {
  return Drawer(
      child: ListView(
    children: [
      const DrawerHeader(
        child: Text("Menu"),
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
        title: const Text('Sign out'),
        onTap: () {
          Navigator.pop(context);
          Provider.of<AppStateManager>(context, listen: false).logout();
        },
      ),
    ],
  ));
}
