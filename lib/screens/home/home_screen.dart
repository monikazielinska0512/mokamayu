import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/screens/outfits/create_outfit_dialog.dart';
import 'package:mokamayu/screens/profile/profile_screen.dart';
import 'package:mokamayu/screens/social/social_screen.dart';

import '../../generated/l10n.dart';
import '../../services/authentication/auth.dart';
import '../../widgets/appbar.dart';
import '../../widgets/drawer.dart';
import '../../widgets/navbar.dart';
import '../outfits/outfits_screen.dart';
import '../wardrobe/wardrobe_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

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

  @override
  Widget build(BuildContext context) {
    List<String> pageLabels = [
      S.of(context).closet,
      S.of(context).outfits,
      S.of(context).social,
      S.of(context).profile,
    ];

    FloatingActionButton? checkForOutfitsScreen() {
      if (_selectedIndex == 1) {
        return FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialogBox.outfitsDialog(context);
                  });
            },
            backgroundColor: const Color.fromARGB(255, 244, 232, 217),
            child: const Icon(Icons.add));
      }
      return null;
    }

    return Scaffold(
        appBar: customAppBar(context, pageLabels[_selectedIndex]),
        drawer: drawer(context),
        body: pages[_selectedIndex],
        floatingActionButton: checkForOutfitsScreen(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomNavigationBar: NavBar(context, _selectedIndex, _onItemTapped));
        bottomNavigationBar: NavBar(
            selectedIndex: _selectedIndex,
            onTabChange: (int index) {
              setState(() {
                print(index);
                _selectedIndex = index;
              });
            }));
  }
}
