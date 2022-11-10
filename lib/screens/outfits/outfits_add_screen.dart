import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/models/user/firebase_user.dart';
import 'package:mokamayu/models/wardrobe/clothes.dart';
import 'package:mokamayu/services/photo_tapped.dart';
import 'package:mokamayu/widgets/drag_target_container.dart';
import 'package:provider/provider.dart';
import '../../services/clothes_provider.dart';
import '../../widgets/appbar.dart';
import '../../widgets/photo_grid/photo_grid.dart';
import '../../services/database/database_service.dart';

class CreateOutfitPage extends StatelessWidget {
  CreateOutfitPage({Key? key, required this.clothesList}) : super(key: key);
  late Future<List<Clothes>> clothesList;

  @override
  Widget build(BuildContext context) {
    // late Future<List<Clothes>> clothesList =
    //     Provider.of<ClothesProvider>(context, listen: false).getClothesList
    //         as Future<List<Clothes>>;
    print('reload');
    return Scaffold(
      appBar: customAppBar(context, "Create a look"),
      body: Column(
        children: <Widget>[
          const DragTargetContainer(),
          //categories for wardrobe
          //TODO
          //photos from wardrobe (button add if no photos) - scroll horizontally
          SizedBox(
            width: double.infinity,
            height: 300,
            child: PhotoGrid(
              clothesList: clothesList,
              scrollVertically: false,
            ),
          )
        ],
      ),
      //),
    );
  }
}
