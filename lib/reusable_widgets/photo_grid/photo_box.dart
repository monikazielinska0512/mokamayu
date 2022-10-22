import 'package:flutter/cupertino.dart';

//TODO On tap Photo you are directed to edit page
Container PhotoBox(String photoUrl){
  return Container(
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
  );
}