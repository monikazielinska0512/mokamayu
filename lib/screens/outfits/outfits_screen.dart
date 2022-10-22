import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/appbar.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({Key? key}) : super(key: key);
  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "OutfitsScreen"),
      body: const Text("Outfits"),
    );
  }
}
