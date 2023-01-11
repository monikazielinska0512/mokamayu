import 'package:flutter/material.dart';

IconButton DotsButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      Scaffold.of(context).openDrawer();
    },
    icon: const Icon(Icons.more_vert),
  );
}
