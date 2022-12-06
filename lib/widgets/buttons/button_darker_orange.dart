import 'package:flutter/material.dart';
import 'package:mokamayu/constants/colors.dart';

Container ButtonDarker(BuildContext context, String title, Function onTap,
    {bool shouldExpand = true}) {
  return Container(
    width: shouldExpand ? MediaQuery.of(context).size.width - 40 : null,
    height: shouldExpand ? 50 : null,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 50),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return ColorsConstants.primary;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}
