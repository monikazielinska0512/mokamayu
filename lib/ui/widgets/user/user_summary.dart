import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/ui/constants/constants.dart';
import '../../../services/authentication/auth.dart';
import '../buttons/button.dart';

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
                    child: Image.asset(user?.photoURL ?? AssetsManager.avatarPlaceholder)))),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(user?.email ?? 'Username',
                    style: TextStyle(
                        fontSize: fontSize, overflow: TextOverflow.clip)),
                if (AuthService().getCurrentUserID() != user?.uid) ...[
                  Button(
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
