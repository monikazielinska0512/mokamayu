import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/photo_grid/photo_grid.dart';

import '../../generated/l10n.dart';
import '../../reusable_widgets/reusable_button.dart';
import '../../reusable_widgets/user/user_summary.dart';
import '../../services/auth.dart';
import '../../services/database/database_service.dart';

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
          if (AuthService().getCurrentUserUID() != widget.user.uid) ...[
            reusableButton(
                context,
                'Create outfit for ${widget.user.displayName ?? widget.user.email}',
                () => {
                      // TODO(karina)
                    })
          ],
          profileContent(context),
        ],
      ),
    );
  }

  Widget profileContent(BuildContext context) {
    List<Tab> tabs = <Tab>[
      Tab(text: S.of(context).closet),
      Tab(text: S.of(context).outfits),
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
                child: TabBarView(children: [
                  PhotoGrid(stream: DatabaseService.readClothes()),
                  PhotoGrid(stream: DatabaseService.readOutfits()),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
