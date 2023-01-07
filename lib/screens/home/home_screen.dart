import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/screens/screens.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../calendar/calendar_screen.dart';

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
    final currentUserUid =
        Provider.of<ProfileManager>(context).currentAuthUser?.uid;

    List<Widget> pages = [
      const WardrobeScreen(),
      const OutfitsScreen(),
      const SocialScreen(),
      const CalendarScreen(),
      ProfileScreen(uid: currentUserUid),
    ];

    return Scaffold(
        drawer: const CustomDrawer(),
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
