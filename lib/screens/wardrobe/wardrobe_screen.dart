import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/constants/constants.dart';

import '../../widgets/chips/multi_select_chips_formfield.dart';
import '../../widgets/photo/photo_grid.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({Key? key}) : super(key: key);

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  Future<List<WardrobeItem>>? itemList;

  @override
  void initState() {
    itemList = Provider.of<WardrobeManager>(context, listen: false)
        .readWardrobeItemOnce();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<WardrobeManager>(context, listen: false)
          .setWardrobeItemList(itemList!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
        type: "wardrobe",
        leftButtonType: "dots",
        context: context,
        body: Stack(children: [
          Column(
            children: [
              Wrap(spacing: 20, runSpacing: 20, children: [
                buildSearchBarAndFilters(),
                MultiSelectChipsFormField(
                    chipsList: Tags.types, isScroll: true),
              ]),
              Expanded(child: PhotoGrid(itemList: itemList)),
            ],
          ),
          buildFloatingButton(),
        ]));
  }

  Widget buildSearchBarAndFilters() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.075,
        child: Row(children: [
          Expanded(
              child: SearchBar(title: "Search", hintTitle: "Name of item")),
          SizedBox(width: MediaQuery.of(context).size.width * 0.045),
          CustomIconButton(onPressed: () => {})
        ]));
  }


  Widget buildFloatingButton() {
    return FloatingButton(
        onPressed: () {
          context.goNamed('pick-photo');
        },
        icon: const Icon(Icons.add),
        backgroundColor: ColorsConstants.darkBrick,
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
        alignment: Alignment.bottomRight);
  }
}
