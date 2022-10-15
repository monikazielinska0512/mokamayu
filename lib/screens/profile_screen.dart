import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "ProfileScreen"),
      body: const Text("Profile"),
    );
  }
}
