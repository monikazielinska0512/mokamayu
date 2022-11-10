import 'package:flutter/material.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/widgets/buttons/floating_button.dart';
import 'package:provider/provider.dart';

import '../../models/wardrobe/clothes.dart';
import '../../services/clothes_provider.dart';
import '../../widgets/photo_grid/photo_grid.dart';
import '../../services/database/database_service.dart';
import 'create_outfit_dialog.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({Key? key}) : super(key: key);

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  late Future<List<Clothes>> clothesList;

  @override
  Widget build(BuildContext context) {
    clothesList =
        Provider.of<ClothesProvider>(context, listen: false).getClothesList;
    return Scaffold(
        body: Stack(children: [
      Column(children: [
        // Expanded(
        //     child: Padding(
        //         padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
        //         child: PhotoGrid(clothesList: DatabaseService.readOutfits()))
        //         )
      ]),
      FloatingButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBox.outfitsDialog(context, clothesList);
                });
          },
          icon: const Icon(Icons.add),
          backgroundColor: CustomColors.primary,
          padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
          alignment: Alignment.bottomRight)
    ]));
  }
}
