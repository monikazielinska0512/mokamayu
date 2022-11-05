import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../reusable_widgets/appbar.dart';
import '../../reusable_widgets/photo_grid/photo_grid.dart';
import '../../services/database/database_service.dart';

class CreateOutfitPage extends StatefulWidget {
  const CreateOutfitPage({Key? key}) : super(key: key);

  @override
  State<CreateOutfitPage> createState() => _CreateOutfitPageState();
}

class _CreateOutfitPageState extends State<CreateOutfitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, "Create a look"),
        body: Column(
          children: <Widget>[
            //canvas for dragging photos
            Container(
              width: MediaQuery.of(context).size.width,
              height: 450.0,
              color: Color.fromARGB(255, 244, 232, 217),
            ),
            //categories for wardrobe
            //TODO
            //photos from wardrobe (button add if no photos) - scroll horizontally
            SizedBox(
              width: double.infinity,
              height: 300,
              child: PhotoGrid(
                stream: DatabaseService.readClothes(),
              ),
            )
          ],
        ));
  }
}

