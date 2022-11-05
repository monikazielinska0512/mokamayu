import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/res/constants.dart';
import 'package:mokamayu/services/auth.dart';
import '../buttons/reusable_button.dart';

Widget userSummary(BuildContext context, User? user,
    {double? imageRadius, double fontSize = 25}) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: Row(
      children: [
        CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: imageRadius,
            child: SizedBox(
                child: ClipOval(
                    child: Image.asset(user?.photoURL ?? avatarPlaceholder)))),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(user?.displayName ?? user?.email ?? 'Username',
                    style: TextStyle(
                        fontSize: fontSize, overflow: TextOverflow.clip)),
                if (AuthService().getCurrentUserID() != user?.uid) ...[
                  reusableButton(
                      context,
                      'Add friend',
                      () => {
                            // TODO(karina)
                          },
                      shouldExpand: false)
                ],
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
