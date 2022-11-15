import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/widgets/buttons/floating_button.dart';
import 'package:provider/provider.dart';

import '../../models/wardrobe/clothes.dart';
import '../../services/clothes_provider.dart';
import '../../widgets/photo_grid/photo_grid.dart';
import 'create_outfit_dialog.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({Key? key}) : super(key: key);

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  Future<List<Clothes>>? clothesList;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          clothesList = Provider.of<ClothesProvider>(context, listen: false)
              .getClothesList;
        }));
    return Scaffold(
        body: Stack(children: [
      Column(children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                child: PhotoGrid(clothesList: clothesList)))
      ]),
      FloatingButton(
          onPressed: () {
            Future.delayed(Duration.zero, showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBox.outfitsDialog(context, clothesList);
                }) as FutureOr Function()?);
          },
          icon: const Icon(Icons.add),
          backgroundColor: CustomColors.primary,
          padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
          alignment: Alignment.bottomRight)
    ]));
  }
}
