import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/services/services.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                DrawerHeader(
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text("Menu",
                            style:
                                TextStyles.h3(ColorsConstants.blackAccent)))),
                buildDrawerOption(context, 'Edit profile',
                    () => context.push('/edit-profile')),
                buildDrawerOption(context, 'Settings', () => {}),
                buildDrawerOption(context, 'Friends', () => {}),
                buildDrawerOption(context, 'Wardrobe', () => {}),
                buildDrawerOption(context, 'Outfits', () => {}),
              ],
            ),
          ),
          buildSignOutOption(context),
        ],
      ),
    ));
  }

  Widget buildDrawerOption(
      BuildContext context, String text, Function navigateTo,
      [TextStyle? textStyle]) {
    return ListTile(
      title: Text(text,
          style:
              textStyle ?? TextStyles.paragraphRegular16(ColorsConstants.grey)),
      onTap: () {
        Navigator.pop(context);
        navigateTo();
      },
    );
  }

  Widget buildSignOutOption(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        children: [
          Divider(color: ColorsConstants.grey),
          buildDrawerOption(
              context,
              'Sign out',
              () =>
                  Provider.of<AppStateManager>(context, listen: false).logout(),
              TextStyles.paragraphRegularSemiBold16(ColorsConstants.grey)),
        ],
      ),
    );
  }
}
