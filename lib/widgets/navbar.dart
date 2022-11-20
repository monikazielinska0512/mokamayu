import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mokamayu/constants/colors.dart';

class NavBar extends StatefulWidget {
  Function(int)? onTabChange;
  int selectedIndex;

  NavBar({Key? key, required this.selectedIndex, required this.onTabChange})
      : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: CustomColors.soft,
            hoverColor: CustomColors.soft,
            gap: 8,
            activeColor: CustomColors.primary,
            iconSize: 28,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Closet',
              ),
              GButton(
                icon: Icons.save,
                text: 'Outfits',
              ),
              GButton(
                icon: Icons.search,
                text: 'Social',
              ),
              GButton(
                icon: Icons.add,
                text: 'Profile',
              ),
            ],
            selectedIndex: widget.selectedIndex,
            onTabChange: widget.onTabChange,
          ),
        ),
      ),
    );
  }
}