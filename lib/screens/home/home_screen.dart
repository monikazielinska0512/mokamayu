import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/user/firebase_user.dart';
import '../../services/authentication/auth.dart';
import '../../services/managers/managers.dart';
import '../../widgets/appbar.dart';
import '../../widgets/drawer.dart';
import '../../widgets/navbar.dart';
import '../outfits/outfits_screen.dart';
import '../profile/profile_screen.dart';
import '../social/social_screen.dart';
import '../wardrobe/wardrobe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.currentTab = 0,
  });

  final int currentTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final User user = AuthService().currentUser!;

  static List<Widget> pages = <Widget>[
    const WardrobeScreen(),
    const OutfitsScreen(),
    const SocialScreen(),
    ProfileScreen(user: user),
  ];

  @override
  Widget build(BuildContext context) {
    final firebase_user = Provider.of<FirebaseUser?>(context);
    // TODO(karina)
    print("ffirebase_user: ${firebase_user?.uid}  user: ${user.uid}");

    List<String> pageLabels = [
      S.of(context).closet,
      S.of(context).outfits,
      S.of(context).social,
      S.of(context).profile,
    ];

    return Scaffold(
        appBar: customAppBar(context, pageLabels[widget.currentTab]),
        drawer: drawer(context),
        body: IndexedStack(index: widget.currentTab, children: pages),
        bottomNavigationBar: NavBar(
            selectedIndex: widget.currentTab,
            onTabChange: (int index) {
              Provider.of<AppStateManager>(context, listen: false)
                  .goToTab(index);
              context.goNamed(
                'home',
                params: {
                  'tab': '$index',
                },
              );
            }));
  }
}
