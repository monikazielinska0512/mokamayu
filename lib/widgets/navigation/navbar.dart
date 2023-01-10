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
      itemShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      currentIndex: widget.selectedIndex,
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04,
          top: 0,
          bottom: 15),
      itemPadding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03,
          top: 5,
          bottom: 10),
      onTap: widget.onTabChange,
      items: [
        SalomonBottomBarItem(
            icon: const Icon(Ionicons.shirt_outline),
            activeIcon: const Icon(Ionicons.shirt),
            title: Text(S.of(context).wardrobe,
                style: TextStyles.paragraphRegularSemiBold14()),
            selectedColor: ColorsConstants.darkBrick),
        SalomonBottomBarItem(
            icon: const Icon(Ionicons.body_outline),
            activeIcon: const Icon(Ionicons.body),
            title: Text(S.of(context).outfits,
                style: TextStyles.paragraphRegularSemiBold14()),
            selectedColor: ColorsConstants.darkPeach),
        SalomonBottomBarItem(
            icon: const Icon(Ionicons.people_outline),
            activeIcon: const Icon(Ionicons.people),
            title: Text(S.of(context).social,
                style: TextStyles.paragraphRegularSemiBold14()),
            selectedColor: ColorsConstants.sunflower),
        SalomonBottomBarItem(
            icon: const Icon(Ionicons.calendar_outline),
            activeIcon: const Icon(Ionicons.calendar),
            title: Text("Calendar",
                style: TextStyles.paragraphRegularSemiBold14()),
            selectedColor: ColorsConstants.mint),
        SalomonBottomBarItem(
            icon: const Icon(Ionicons.person_outline),
            activeIcon: const Icon(Ionicons.person),
            title: Text(S.of(context).profile,
                style: TextStyles.paragraphRegularSemiBold14()),
            selectedColor: ColorsConstants.green),
      ],
    );
  }
}
