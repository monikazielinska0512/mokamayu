import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/screens/wardrobe/wardrobe_item_search.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/constants/constants.dart';
import '../../widgets/photo/photo_grid.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({Key? key}) : super(key: key);

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  Future<List<WardrobeItem>>? futureItemList;
  List<WardrobeItem>? itemList;
  List<String> selectedTypes = Tags.types;
  List<String> selectedSizes = Tags.sizes;
  List<String> selectedStyles = Tags.styles;
  List<String> selectedChips = Tags.types;

  @override
  void initState() {
    futureItemList = Provider.of<WardrobeManager>(context, listen: false)
        .readWardrobeItemOnce();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<WardrobeManager>(context, listen: false)
          .setWardrobeItemList(futureItemList!);
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
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(spacing: 10, children: [
                      MultiSelectChip(Tags.types,
                          onSelectionChanged: (selectedList) {
                        selectedChips =
                            selectedList.isEmpty ? Tags.types : selectedList;
                      })
                    ])),
              ]),
              Expanded(child: PhotoGrid(itemList: futureItemList)),
            ],
          ),
          buildFloatingButton(),
        ]));
  }

  Widget buildSearchBarAndFilters() {
    setState(() {});
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.075,
        child: Row(children: [
          Expanded(child: WardrobeItemSearch(title: "name")),
          SizedBox(width: MediaQuery.of(context).size.width * 0.045),
          CustomIconButton(
              onPressed: () => {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            color: Colors.white,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text("Filter & Sorting"),
                                  const Text("Type"),
                                  MultiSelectChip(Tags.types,
                                      onSelectionChanged: (selectedList) {
                                    selectedTypes = selectedList;
                                  }),
                                  const Text("Size"),
                                  MultiSelectChip(Tags.sizes,
                                      onSelectionChanged: (selectedList) {
                                    selectedSizes = selectedList;
                                  }),
                                  const Text("Styles"),
                                  MultiSelectChip(Tags.styles,
                                      onSelectionChanged: (selectedList) {
                                    selectedStyles = selectedList;
                                  }),
                                  ElevatedButton(
                                      onPressed: () => {
                                            setState(() {
                                              futureItemList =
                                                  Provider.of<WardrobeManager>(
                                                          context,
                                                          listen: false)
                                                      .filterWardrobe(
                                                          context,
                                                          selectedTypes,
                                                          selectedStyles,
                                                          selectedSizes);
                                              Future.delayed(Duration.zero)
                                                  .then((value) {
                                                Provider.of<WardrobeManager>(
                                                        context,
                                                        listen: false)
                                                    .setWardrobeItemList(
                                                        futureItemList!);
                                              });
                                            }),
                                            context.pop(),
                                            selectedTypes = [],
                                            selectedSizes = [],
                                            selectedStyles = []
                                          },
                                      child: const Text("Aplikuj filtry"))
                                ],
                              ),
                            ),
                          );
                        })
                  }),
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
