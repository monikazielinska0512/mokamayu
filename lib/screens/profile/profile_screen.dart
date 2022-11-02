import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../reusable_widgets/reusable_button.dart';
import '../../reusable_widgets/user/user_summary.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          userSummary(context, widget.user, imageRadius: 60),
          reusableButton(
              context,
              'Create outfit for ${widget.user.displayName ?? widget.user.email}',
              () => {}),
          profileContent(),
        ],
      ),
    );
  }

  Widget profileContent() {
    List<Tab> tabs = const <Tab>[
      Tab(text: 'Closet'),
      Tab(text: 'Outfits'),
    ];
    return Expanded(
      child: DefaultTabController(
        length: tabs.length,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabBar(
                labelColor: Colors.black87,
                tabs: tabs,
              ),
              Expanded(
                child: TabBarView(
                  children: tabs.map((Tab tab) {
                    final String label = tab.text?.toLowerCase() ?? "";
                    return Center(child: Text('$label grid'));
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
