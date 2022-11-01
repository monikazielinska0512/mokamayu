import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/appbar.dart';

import '../../reusable_widgets/floating_button.dart';
import '../../reusable_widgets/photo_grid/photo_grid.dart';
import '../../services/database/database_service.dart';
import '../wardrobe/clothes_add_screen.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({Key? key}) : super(key: key);
  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, "Outfits Screen"),
        body: Stack(children: [
          Column(children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                    child: PhotoGrid(
                        stream: DatabaseService.readOutfits(),
                        flagHorizontal: false)))
          ]),
        ]));
  }
}
