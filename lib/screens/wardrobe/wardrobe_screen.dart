import 'package:flutter/material.dart';
import 'package:mokamayu/models/wardrobe/clothes.dart';
import 'package:mokamayu/screens/wardrobe/form/add_photo_screen.dart';
import 'package:mokamayu/services/clothes_provider.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../widgets/basic_page.dart';
import '../../widgets/buttons/floating_button.dart';
import '../../widgets/buttons/icon_button.dart';
import '../../widgets/fields/search_bar.dart';
import '../../widgets/page_title.dart';
import '../../widgets/photo_grid/photo_grid.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({Key? key}) : super(key: key);

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  late Future<List<Clothes>> clothesList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    clothesList =
        Provider.of<ClothesProvider>(context, listen: false).readClothesOnce();
    Provider.of<ClothesProvider>(context, listen: false)
        .setClothes(clothesList);
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
                // ChoiceChips(
                //     chipsList: Tags.types.sublist(
                //   2,
                // )),
              ]),
              const SizedBox(height: 15),
              Expanded(child: PhotoGrid(clothesList: clothesList))
            ],
          ),
          FloatingButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PhotoPickerScreen()));
              },
              icon: const Icon(Icons.add),
              backgroundColor: CustomColors.primary,
              padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
              alignment: Alignment.bottomRight)
        ]));
  }
}
