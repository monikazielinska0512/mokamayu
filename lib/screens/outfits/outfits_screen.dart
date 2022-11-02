import 'package:flutter/material.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({Key? key}) : super(key: key);

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Outfits"),
    );
  }
}
