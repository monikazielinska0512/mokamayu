import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../generated/l10n.dart';
import '../fundamental/background_image.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () => context.pop(),
        child: Stack(children: const [
          BackgroundImage(
              imagePath: "assets/images/full_background.png",
              imageShift: 0,
              opacity: 0.5),
        ]),
      ),
      Drawer(
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
                  buildDrawerOption(context, S.of(context).edit_profile,
                      () => context.push('/edit-profile')),
                  buildDrawerOption(
                      context,
                      S.of(context).friends,
                      () => {
                            context.pushNamed('friends'),
                          }),
                  buildDrawerOption(context, S.of(context).friend_requests,
                      () => {context.pushNamed('requests')}),
                  buildDrawerOption(context, S.of(context).wardrobe,
                      () => {context.push('/home/0')}),
                  buildDrawerOption(context, S.of(context).outfits,
                      () => {context.push('/home/1')}),
                ],
              ),
            ),
            buildSignOutOption(context),
          ],
        ),
      )),
    ]);
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
    void clearFilters() {
      Provider.of<WardrobeManager>(context, listen: false).setTypes([]);
      Provider.of<WardrobeManager>(context, listen: false).setSizes([]);
      Provider.of<WardrobeManager>(context, listen: false).setStyles([]);
      Provider.of<OutfitManager>(context, listen: false).setStyles([]);
      Provider.of<OutfitManager>(context, listen: false).setSeasons([]);
      Provider.of<OutfitManager>(context, listen: false).setOutfitsCopy(null);
      Provider.of<WardrobeManager>(context, listen: false)
          .setWardrobeItemListCopy(null);
    }

    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        children: [
          Divider(color: ColorsConstants.lightGrey, thickness: 1.5),
          buildDrawerOption(context, S.of(context).sign_out, () {
            clearFilters();
            Provider.of<AppStateManager>(context, listen: false).logout();
          }, TextStyles.paragraphRegularSemiBold16(ColorsConstants.grey)),
        ],
      ),
    );
  }
}
