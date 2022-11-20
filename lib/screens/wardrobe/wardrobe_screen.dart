import 'package:flutter/material.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/screens/screens.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/constants/constants.dart';


class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({Key? key}) : super(key: key);

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  Future<List<Clothes>>? clothesList;

  @override
  void initState() {
    clothesList =
        Provider.of<WardrobeManager>(context, listen: false).readClothesOnce();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<WardrobeManager>(context, listen: false)
          .setClothes(clothesList!);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
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
                //     chipsList: Tags.types.sublist(0, Tags.types.length - 1)),
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
                        builder: (context) => ChangeNotifierProvider(
                              create: (_) => WardrobeManager(),
                              child: AddPhotoScreen(),
                            )));
              },
              icon: const Icon(Icons.add),
              backgroundColor: ColorManager.primary,
              padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
              alignment: Alignment.bottomRight)
        ]));
  }
}
