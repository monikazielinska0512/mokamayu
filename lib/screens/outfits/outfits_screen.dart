import 'package:flutter/material.dart';

import '../../reusable_widgets/photo_grid/photo_grid.dart';
import '../../services/database/database_service.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({Key? key}) : super(key: key);

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                child: PhotoGrid(stream: DatabaseService.readOutfits())))
      ]),
    ]));
  }
}
