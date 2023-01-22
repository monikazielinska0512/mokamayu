// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

Expanded EmptyScreen(BuildContext context, Text information, Color color,
    {IconData? icon = Ionicons.sad_outline}) {
  return Expanded(
      child: Container(
          decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width,
          child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Icon(
                  icon,
                  size: 25,
                  color: Colors.grey,
                ),
                Padding(padding: const EdgeInsets.all(20), child: information)
              ]))));
}
