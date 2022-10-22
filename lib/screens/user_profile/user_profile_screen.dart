import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Row(children: [
          Text('Image'),
          Column(children: [
            Text('username'),
            Text('follow/add to friends'),
          ])
        ]),
        Text('create outfit button'),
        Text('Wardrobe/Outfits tabs'),
        Text('Grid of elements'),
      ]),
    );
  }
}
