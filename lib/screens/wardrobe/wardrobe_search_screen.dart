import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/widgets/widgets.dart';

import '../../constants/colors.dart';
import '../../generated/l10n.dart';
import '../../models/wardrobe_item.dart';
import '../../widgets/fields/search_text_field.dart';

class WardrobeItemSearchScreen extends StatefulWidget {
  Future<List<WardrobeItem>> items;

  WardrobeItemSearchScreen({Key? key, required this.items}) : super(key: key);

  @override
  State<WardrobeItemSearchScreen> createState() =>
      _WardrobeItemSearchScreenState();
}

class _WardrobeItemSearchScreenState extends State<WardrobeItemSearchScreen> {
  String searchString = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
      context: context,
      type: "wardrobe-item-search",
      rightButtonType: "",
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SearchTextField(onChanged: (value) {
                setState(() {
                  searchString = value.toLowerCase();
                });
              })),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              builder: (context, AsyncSnapshot<List<WardrobeItem>> snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return snapshot.data![index].name
                                .toLowerCase()
                                .contains(searchString)
                            ? itemCard(snapshot, index)
                            : Container();
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Container();
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong :('));
                }
                return const CircularProgressIndicator();
              },
              future: widget.items,
            ),
          ),
        ],
      ),
    );
  }

  Widget itemCard(AsyncSnapshot<List<WardrobeItem>> snapshot, int index) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
      color: ColorsConstants.whiteAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox.fromSize(
                    size: const Size.fromRadius(30),
                    child: Image.network(snapshot.data?[index].photoURL ?? "",
                        fit: BoxFit.fill))),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        snapshot.data![index].name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 5),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                          onTap: () => {
                                context.pushNamed('wardrobe-item',
                                    extra: snapshot.data?[index])
                              },
                          child: Text(
                            S.of(context).see_details,
                            style: TextStyle(
                                color: ColorsConstants.darkBrick,
                                fontWeight: FontWeight.bold),
                          )))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
