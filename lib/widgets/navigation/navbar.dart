import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../constants/text_styles.dart';
import '../../generated/l10n.dart';

class NavBar extends StatefulWidget {
  int selectedIndex;
  Function(int)? onTabChange;

  NavBar({Key? key, required this.selectedIndex, required this.onTabChange})
      : super(key: key);

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: widget.selectedIndex,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      itemPadding:
          const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      onTap: widget.onTabChange,
      items: [
        SalomonBottomBarItem(
            icon: const Icon(Ionicons.shirt_outline),
            title: Text(S.of(context).wardrobe, style: TextStyles.paragraphRegularSemiBold14()),
            selectedColor: ColorsConstants.darkBrick),
        SalomonBottomBarItem(
            icon: const Icon(Ionicons.body_outline),
            title: Text(S.of(context).outfits, style: TextStyles.paragraphRegularSemiBold14()),
            selectedColor: ColorsConstants.darkPeach),
        SalomonBottomBarItem(
            icon: const Icon(Ionicons.people_outline),
            title: Text(S.of(context).social,style: TextStyles.paragraphRegularSemiBold14() ),
            selectedColor: ColorsConstants.sunflower),
        SalomonBottomBarItem(
            icon: const Icon(Ionicons.person_outline),
            title: Text(S.of(context).profile,
                style: TextStyles.paragraphRegularSemiBold14()),
            selectedColor: ColorsConstants.green),
      ],
    );
  }
}
