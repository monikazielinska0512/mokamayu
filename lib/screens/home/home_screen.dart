import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/appbar.dart';
import 'package:mokamayu/screens/profile/profile_screen.dart';
import 'package:mokamayu/screens/social/social_screen.dart';

import '../../generated/l10n.dart';
import '../../reusable_widgets/navbar.dart';
import '../../services/auth.dart';
import '../outfits/outfits_screen.dart';
import '../wardrobe/wardrobe_screen.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final User user = AuthService().currentUser!;
  int _selectedIndex = 0;
  static List<Widget> pages = <Widget>[
    const WardrobeScreen(),
    const OutfitsScreen(),
    const SocialScreen(),
    ProfileScreen(user: user),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> pageLabels = [
      S.of(context).closet,
      S.of(context).outfits,
      S.of(context).social,
      S.of(context).profile,
    ];
    return Scaffold(
        appBar: customAppBar(context, pageLabels[_selectedIndex]),
        body: pages[_selectedIndex],
        bottomNavigationBar:
            NavBar(context, _selectedIndex, _onItemTapped, pageLabels));
  }
}
