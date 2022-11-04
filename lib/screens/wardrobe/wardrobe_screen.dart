import 'package:flutter/material.dart';
import 'package:mokamayu/res/colors.dart';
import 'package:mokamayu/services/database/database_service.dart';
import '../../res/tags.dart';
import '../../reusable_widgets/basic_page.dart';
import '../../reusable_widgets/buttons/floating_button.dart';
import '../../reusable_widgets/buttons/icon_button.dart';
import '../../reusable_widgets/chips/choice_chips.dart';
import '../../reusable_widgets/fields/search_bar.dart';
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
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.075,
                    child: Row(children: [
                      Expanded(
                          child: SearchBar(
                              title: "Search", hintTitle: "Name of clothes")),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.045),
                      CustomIconButton(
                          onPressed: () {},
                          width: MediaQuery.of(context).size.width * 0.15,
                          icon: Icons.filter_list)
                    ])),
                const SizedBox(height: 15),
                ChoiceChips(
                    chipsList: Tags.types.sublist(
                  2,
                )),
              ]),
              const SizedBox(height: 15),
              Expanded(
                  child: PhotoGrid(
                stream: DatabaseService.readClothes(),
              ))
            ],
          ),
          FloatingButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
              backgroundColor: CustomColors.primary,
              padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
              alignment: Alignment.bottomRight)
        ]));
  }
}
