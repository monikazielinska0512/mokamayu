import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mokamayu/ui/ui.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'create_outfit_dialog.dart';
import 'package:provider/provider.dart';

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
          backgroundColor: ColorManager.primary,
          padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
          alignment: Alignment.bottomRight)
    ]));
  }
}
