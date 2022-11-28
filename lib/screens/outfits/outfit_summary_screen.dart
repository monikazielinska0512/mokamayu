import 'package:flutter/material.dart';
import 'package:mokamayu/widgets/drag_target_container.dart';

class OutfitSummaryScreen extends StatelessWidget {
  OutfitSummaryScreen({super.key, this.map});
  Map<String, ContainerList>? map = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("Outfit Summary",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
