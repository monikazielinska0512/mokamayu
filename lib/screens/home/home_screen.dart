import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/screens/screens.dart';
import 'package:mokamayu/ui/widgets/widgets.dart';
import 'package:mokamayu/services/authentication/auth.dart';

import '../../generated/l10n.dart';

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
      S.of(context).wardrobe,
      S.of(context).outfits,
      S.of(context).social,
      S.of(context).profile,
    ];

    return Scaffold(
        appBar: customAppBar(context, pageLabels[_selectedIndex]),
        drawer: drawer(context),
        body: IndexedStack(index: _selectedIndex, children: pages),
        bottomNavigationBar: NavBar(
            selectedIndex: _selectedIndex,
            onTabChange: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            }));
  }
}
