import 'package:flutter/material.dart';
import 'package:mokamayu/screens/profile/profile_screen.dart';
import 'package:mokamayu/screens/social/social_screen.dart';
import '../../reusable_widgets/navbar.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavBar(context, _selectedIndex, _onItemTapped)
    );
  }
}