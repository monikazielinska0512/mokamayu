import 'package:flutter/material.dart';
import 'package:mokamayu/screens/outfits/outfits_add_screen.dart';

class CustomDialogBox {
  static outfitsDialog(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Color.fromARGB(255, 244, 232, 217),
      title: Text('Create a look'),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateOutfitPage()));
          },
          child: Text('By yourself'),
        ),
        SimpleDialogOption(
          onPressed: () {},
          child: Text('With applied filters'),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
