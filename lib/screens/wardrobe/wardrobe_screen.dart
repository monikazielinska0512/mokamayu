import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/basic_page.dart';
import 'package:mokamayu/reusable_widgets/choice_chips.dart';
import 'package:mokamayu/reusable_widgets/icon_button.dart';
import 'package:mokamayu/reusable_widgets/search_bar.dart';
import '../../res/tags.dart';
import '../../reusable_widgets/page_title.dart';
import '../../reusable_widgets/photo_grid/photo_grid.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({Key? key}) : super(key: key);

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  @override
  Widget build(BuildContext context) {
    return BasicPage(
        context: context,
        child: Stack(children: [
          Column(
            children: [
              Column(children: [
                PageTitle(
                    title: "Your Wardrobe",
                    description: "Explore your clothes"),
                const SizedBox(height: 20),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.89,
                    height: MediaQuery.of(context).size.height * 0.074,
                    child: Row(children: [
                      Expanded(
                          child: SearchBar(
                              title: "Search", hintTitle: "Name of clothes")),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.042),
                      CustomIconButton(
                          onPressed: () {},
                          width: MediaQuery.of(context).size.width * 0.15,
                          icon: Icons.filter_list)
                    ])),
                const SizedBox(height: 15),
                ChoiceChips(chipsList: Tags.types.sublist(2,)),
              ]),
              const SizedBox(height: 15),
               Expanded(child: PhotoGrid())
            ],
          ),
        ]));
  }
}
