import '../../generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/models/models.dart';


class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<List<Clothes>>? clothesList;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          clothesList = Provider.of<ClothesManager>(context, listen: false)
              .getClothesList;
        }));
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          userSummary(context, widget.user, imageRadius: 60),
          if (AuthService().getCurrentUserID() != widget.user.uid) ...[
            Button(
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
                  PhotoGrid(clothesList: clothesList),
                  PhotoGrid(
                      clothesList: clothesList), //potem podmienie na outfity
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
