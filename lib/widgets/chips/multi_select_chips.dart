import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/constants/constants.dart';

import '../../constants/colors.dart';
import '../../models/wardrobe_item.dart';
import '../../services/managers/wardrobe_manager.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> chipsList;
  final Function(List<String>)? onSelectionChanged;
  String? type;
  Future<List<WardrobeItem>>? list;
  bool isScrollable;
  Color chipsColor;

  MultiSelectChip(this.chipsList,
      {super.key,
      required this.onSelectionChanged,
      this.type,
      this.isScrollable = true,
      required this.chipsColor});

  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  @override
  void initState() {
    if (widget.type == 'type' &&
        Provider.of<WardrobeManager>(context, listen: false).getTypes != null) {
      selectedChoices =
          Provider.of<WardrobeManager>(context, listen: false).getTypes!;
    }
    if (widget.type == 'size' &&
        Provider.of<WardrobeManager>(context, listen: false).getSizes != null) {
      selectedChoices =
          Provider.of<WardrobeManager>(context, listen: false).getSizes!;
    }
    if (widget.type == 'style' &&
        Provider.of<WardrobeManager>(context, listen: false).getStyles !=
            null) {
      selectedChoices =
          Provider.of<WardrobeManager>(context, listen: false).getStyles!;
    }
    if (widget.type == 'type_main' &&
        Provider.of<WardrobeManager>(context, listen: false).getTypes != null) {
      selectedChoices =
          Provider.of<WardrobeManager>(context, listen: false).getTypes!;
    }
    super.initState();
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    for (var item in widget.chipsList) {
      choices.add(Container(
        padding: const EdgeInsets.only(right: 10),
        child: ChoiceChip(
          label: Text(item),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          selected: selectedChoices.contains(item),
          backgroundColor: widget.chipsColor.withOpacity(0.6),
          selectedColor: widget.chipsColor,
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged!(selectedChoices);
              if (widget.type == 'type_main') {
                Provider.of<WardrobeManager>(context, listen: false)
                    .setTypes(selectedChoices);
                widget.list =
                    Provider.of<WardrobeManager>(context, listen: false)
                        .filterWardrobe(
                            context,
                            selectedChoices,
                            [],
                            [],
                            Provider.of<WardrobeManager>(context, listen: false)
                                .getFinalWardrobeItemList);

                if (widget.list != null) {
                  Provider.of<WardrobeManager>(context, listen: false)
                      .setWardrobeItemListCopy(widget.list!);
                }
              }
            });

            if (widget.type == 'type') {
              Provider.of<WardrobeManager>(context, listen: false)
                  .setTypes(selectedChoices);
            }
            if (widget.type == 'size') {
              Provider.of<WardrobeManager>(context, listen: false)
                  .setSizes(selectedChoices);
            }
            if (widget.type == 'style') {
              Provider.of<WardrobeManager>(context, listen: false)
                  .setStyles(selectedChoices);
            }
          },
        ),
      ));
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: widget.isScrollable
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(children: _buildChoiceList()))
            : Wrap(runSpacing: 7, children: _buildChoiceList()));
  }
}
