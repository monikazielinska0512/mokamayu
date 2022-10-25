import 'package:flutter/material.dart';

GestureDetector PhotoBox(String id, String photoUrl, BuildContext context) {
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
  );
}
