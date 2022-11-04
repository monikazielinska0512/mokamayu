import 'package:flutter/material.dart';

Container FloatingButton(BuildContext context, Widget screen, Icon icon) {
  return Container(
      child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 30.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => screen));
                },
                backgroundColor: Colors.green,
                child: icon,
              ))));
}
