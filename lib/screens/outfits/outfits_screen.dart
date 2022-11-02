import 'package:flutter/material.dart';

import '../../reusable_widgets/photo_grid/photo_grid.dart';
import '../../services/database/database_service.dart';
import 'create_outfit_dialog.dart';

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
      ]),
      floatingActionButton: checkForOutfitsScreen(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  FloatingActionButton? checkForOutfitsScreen() {
    return FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox.outfitsDialog(context);
              });
        },
        backgroundColor: Color.fromARGB(255, 244, 232, 217),
        child: Icon(Icons.add));
  }
}
