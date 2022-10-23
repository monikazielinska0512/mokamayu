import 'package:flutter/material.dart';
import 'package:mokamayu/screens/wardrobe/clothes_edit_screen.dart';

//TODO On tap Photo you are directed to edit page
GestureDetector PhotoBox(String id, String photoUrl, BuildContext context){
  return GestureDetector(
      child: Container(
    width: 300,
    height: 400,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
    ),
    child: SizedBox.expand(
      child: FittedBox(
        alignment: Alignment.center,
        child: Image.network(photoUrl),
        fit: BoxFit.fill,
      ),
    ),
  ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClothesForm(clothesID: id)),
        );
      }
  );
}