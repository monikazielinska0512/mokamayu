import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/appbar.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({Key? key}) : super(key: key);
  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "WardrobeScreen"),
      body: const Text("Wardrobe"),
    );
  }
}
