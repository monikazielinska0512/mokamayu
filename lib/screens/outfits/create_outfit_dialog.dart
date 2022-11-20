import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/screens/outfits/outfits_add_screen.dart';
import 'package:mokamayu/widgets/photo_grid/photo_tapped.dart';
import 'package:mokamayu/models/models.dart';
import 'package:provider/provider.dart';

class CustomDialogBox {
  static outfitsDialog(
      BuildContext context, Future<List<Clothes>>? clothesList) {
    return CupertinoAlertDialog(
      title: Column(
        children: <Widget>[
          Text("Create a look"),
          Image.asset(
            "assets/images/girl.png",
            fit: BoxFit.fitWidth,
            height: 100,
          ),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                          create: (_) => PhotoTapped(),
                          child: CreateOutfitPage(clothesList: clothesList),
                        )));
          },
          child: const Text('By yourself'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            //TODO in the future
          },
          child: const Text('With applied filters'),
        ),
        CupertinoDialogAction(
          child: const Text("Cancel"),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
