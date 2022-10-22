import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/appbar.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);
  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, "SocialScreen"),
        body: const Text("Social"),
    );
  }
}
