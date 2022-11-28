import 'package:flutter/material.dart';
import 'package:mokamayu/widgets/drag_target_container.dart';

class OutfitSummaryScreen extends StatelessWidget {
  OutfitSummaryScreen({super.key, this.map});
  Map<List<dynamic>, ContainerList>? map = {};

  @override
  Widget build(BuildContext context) {
    print(map!.entries);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text("Outfit Summary",
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: map!.entries.map((entry) {
            return Container(
              child: Text(entry.key[1]),
            );
          }).toList(),
        ));
  }
}
