import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/models.dart';

class CustomDialogBox {
  static outfitsDialog(
      BuildContext context, Future<List<WardrobeItem>>? itemList) {
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
            context.goNamed("create-outfit-page", extra: itemList!);
            Navigator.of(context).pop();
          },
          child: const Text('By yourself'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            //TODO in the future
            Navigator.of(context).pop();
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
