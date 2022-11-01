import 'package:flutter/material.dart';
import 'package:mokamayu/screens/profile/profile_screen.dart';
import 'package:mokamayu/screens/social/social_screen.dart';
import '../../reusable_widgets/navbar.dart';
import '../outfits/create_outfit_dialog.dart';
import '../outfits/outfits_screen.dart';
import '../wardrobe/wardrobe_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static List<Widget> pages = <Widget>[
    const WardrobeScreen(),
    const OutfitsScreen(),
    const SocialScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          backgroundColor: Color.fromARGB(255, 244, 232, 217),
          child: Icon(Icons.add));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[_selectedIndex],
        floatingActionButton: checkForOutfitsScreen(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: NavBar(context, _selectedIndex, _onItemTapped));
  }
}
