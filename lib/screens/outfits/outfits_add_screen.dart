import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/appbar.dart';
import '../../widgets/photo_grid/photo_grid.dart';
import '../../services/database/database_service.dart';

class CreateOutfitPage extends StatefulWidget {
  const CreateOutfitPage({Key? key}) : super(key: key);

  @override
  State<CreateOutfitPage> createState() => _CreateOutfitPageState();
}

class _CreateOutfitPageState extends State<CreateOutfitPage> {
  bool accepted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, "Create a look"),
        body: Column(
          children: <Widget>[
            //canvas for dragging photos
            DragTarget(
              builder: (context, candidateData, rejectedData) {
                return accepted
                    ? Container(
                        height: 450.0,
                        width: MediaQuery.of(context).size.width,
                        color: Color.fromARGB(255, 244, 232, 217),
                      )
                    : Container(
                        height: 450.0,
                        width: MediaQuery.of(context).size.width,
                        color: Color.fromARGB(255, 244, 232, 217),
                      );
              },
              onWillAccept: (data) {
                return true;
              },
              onAccept: (data) {
                accepted = true;
              },
              onMove: (details) {},
            ),
            //categories for wardrobe
            //TODO
            //photos from wardrobe (button add if no photos) - scroll horizontally
            SizedBox(
              width: double.infinity,
              height: 300,
              child: PhotoGrid(
                stream: DatabaseService.readClothes(),
                scrollVertically: false,
              ),
            )
          ],
        ));
  }
}
