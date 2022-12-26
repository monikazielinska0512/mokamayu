import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/managers/managers.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> chipsList;
  final Function(List<String>)? onSelectionChanged;
  String? type;
  Future<List<WardrobeItem>>? wardrobeItemList;
  Future<List<Outfit>>? outfitList;
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
    if ((widget.type == 'type' || widget.type == 'type_main') &&
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
    if ((widget.type == 'style_main' || widget.type == 'outfit_style') &&
        Provider.of<OutfitManager>(context, listen: false).getStyles != null) {
      selectedChoices =
          Provider.of<OutfitManager>(context, listen: false).getStyles!;
    }
    if (widget.type == 'outfit_season' &&
        Provider.of<OutfitManager>(context, listen: false).getSeasons != null) {
      selectedChoices =
          Provider.of<OutfitManager>(context, listen: false).getSeasons!;
    }
    super.initState();
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    for (var item in widget.chipsList) {
      choices.add(Container(
        padding: const EdgeInsets.only(right: 10),
        child: ChoiceChip(
          label: selectedChoices.contains(item) ? Text(item, style: TextStyles.paragraphRegularSemiBold16(Colors.white)) : Text(item, style: TextStyles.paragraphRegular16(Colors.white)) ,
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
                widget.wardrobeItemList =
                    Provider.of<WardrobeManager>(context, listen: false)
                        .filterWardrobe(
                            context,
                            selectedChoices,
                            [],
                            [],
                            Provider.of<WardrobeManager>(context, listen: false)
                                .getFinalWardrobeItemList);

                if (widget.wardrobeItemList != null) {
                  Provider.of<WardrobeManager>(context, listen: false)
                      .setWardrobeItemListCopy(widget.wardrobeItemList!);
                }
              }
              if (widget.type == 'style_main') {
                Provider.of<OutfitManager>(context, listen: false)
                    .setStyles(selectedChoices);
                widget.outfitList =
                    Provider.of<OutfitManager>(context, listen: false)
                        .filterOutfits(
                            context,
                            selectedChoices,
                            [],
                            Provider.of<OutfitManager>(context, listen: false)
                                .getfinalOutfitList);

                if (widget.outfitList != null) {
                  Provider.of<OutfitManager>(context, listen: false)
                      .setOutfitsCopy(widget.outfitList!);
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
            if (widget.type == 'outfit_style') {
              Provider.of<OutfitManager>(context, listen: false)
                  .setStyles(selectedChoices);
            }
            if (widget.type == 'outfit_season') {
              Provider.of<OutfitManager>(context, listen: false)
                  .setSeasons(selectedChoices);
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
