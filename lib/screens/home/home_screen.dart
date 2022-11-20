import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../services/managers/managers.dart';
import '../../widgets/appbar.dart';
import '../../widgets/drawer.dart';
import '../../widgets/navbar.dart';
import '../outfits/outfits_screen.dart';
import '../profile/profile_screen.dart';
import '../social/social_screen.dart';
import '../wardrobe/wardrobe_screen.dart';

class HomeScreen extends StatefulWidget {
  final int currentTab;

  const HomeScreen({
    super.key,
    this.currentTab = 0,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProfileManager>(context).getUser;

    List<Widget> pages = [
      const WardrobeScreen(),
      const OutfitsScreen(),
      const SocialScreen(),
      ProfileScreen(user: user),
    ];

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
