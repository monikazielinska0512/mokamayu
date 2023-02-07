import 'package:flutter/material.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class MultiSelectChip extends StatefulWidget {
  final List<String> chipsList;
  final List<String> initialValues;
  final Function(List<String>)? onSelectionChanged;
  String? type;
  bool usingFriendsWardrobe;

  Future<List<WardrobeItem>>? wardrobeItemList;
  Future<List<Outfit>>? outfitList;
  bool isScrollable;
  bool disableChange;
  Color chipsColor;

  MultiSelectChip(this.chipsList,
      {super.key,
      required this.onSelectionChanged,
      this.type,
      this.disableChange = false,
      this.initialValues = const [],
      this.isScrollable = true,
      required this.chipsColor,
      this.usingFriendsWardrobe = false});

  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  @override
  void initState() {
    selectedChoices = widget.initialValues;
    if (selectedChoices == []) {
      if ((widget.type == 'type' || widget.type == 'type_main') &&
          Provider.of<WardrobeManager>(context, listen: false).getTypes !=
              null) {
        selectedChoices =
            Provider.of<WardrobeManager>(context, listen: false).getTypes!;
      }
      if (widget.type == 'size' &&
          Provider.of<WardrobeManager>(context, listen: false).getSizes !=
              null) {
        selectedChoices =
            Provider.of<WardrobeManager>(context, listen: false).getSizes!;
      }
      if (widget.type == 'style' &&
          Provider.of<WardrobeManager>(context, listen: false).getStyles !=
              null) {
        selectedChoices =
            Provider.of<WardrobeManager>(context, listen: false).getStyles!;
      }
      if (widget.type == 'color' &&
          Provider.of<WardrobeManager>(context, listen: false).getColors !=
              null) {
        selectedChoices =
            Provider.of<WardrobeManager>(context, listen: false).getColors!;
      }
      if (widget.type == 'material' &&
          Provider.of<WardrobeManager>(context, listen: false).getMaterials !=
              null) {
        selectedChoices =
            Provider.of<WardrobeManager>(context, listen: false).getMaterials!;
      }
      if ((widget.type == 'style_main' || widget.type == 'outfit_style') &&
          Provider.of<OutfitManager>(context, listen: false).getStyles !=
              null) {
        selectedChoices =
            Provider.of<OutfitManager>(context, listen: false).getStyles!;
      }
      if (widget.type == 'outfit_season' &&
          Provider.of<OutfitManager>(context, listen: false).getSeasons !=
              null) {
        selectedChoices =
            Provider.of<OutfitManager>(context, listen: false).getSeasons!;
      }
      if (widget.type == 'outfitStyle' &&
          Provider.of<OutfitManager>(context, listen: false).getStyle != null) {
        selectedChoices =
            Provider.of<OutfitManager>(context, listen: false).getStyle;
      }
    }

    super.initState();
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    for (var item in widget.chipsList) {
      choices.add(Container(
        padding: const EdgeInsets.only(right: 5),
        child: ChoiceChip(
          label: selectedChoices.contains(item)
              ? Text(item,
                  style: TextStyles.paragraphRegularSemiBold16(Colors.white))
              : Text(item, style: TextStyles.paragraphRegular16(Colors.white)),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          selected: selectedChoices.contains(item),
          backgroundColor: widget.chipsColor.withOpacity(0.6),
          selectedColor: widget.chipsColor,
          onSelected: (selected) {
            if (widget.disableChange == false) {
              setState(() {
                selectedChoices.contains(item)
                    ? selectedChoices.remove(item)
                    : selectedChoices = [...selectedChoices, item];
                widget.onSelectionChanged!(selectedChoices);
                if (widget.type == 'type_main') {
                  Provider.of<WardrobeManager>(context, listen: false)
                      .setTypes(selectedChoices);
                  if (widget.usingFriendsWardrobe) {
                    widget.wardrobeItemList = Provider.of<WardrobeManager>(
                            context,
                            listen: false)
                        .filterFriendWardrobe(
                            context,
                            selectedChoices,
                            Provider.of<WardrobeManager>(context, listen: false)
                                .getFinalFriendWardrobeItemList);
                    if (widget.wardrobeItemList != null) {
                      Provider.of<WardrobeManager>(context, listen: false)
                          .setFriendWardrobeItemListCopy(
                              widget.wardrobeItemList!);
                    }
                  } else {
                    widget.wardrobeItemList = Provider.of<WardrobeManager>(
                            context,
                            listen: false)
                        .filterWardrobe(
                            context,
                            selectedChoices,
                            [],
                            [],
                            [],
                            [],
                            Provider.of<WardrobeManager>(context, listen: false)
                                .getFinalWardrobeItemList);
                    if (widget.wardrobeItemList != null) {
                      Provider.of<WardrobeManager>(context, listen: false)
                          .setWardrobeItemListCopy(widget.wardrobeItemList!);
                    }
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
                                  .getFinalOutfitList);

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
              if (widget.type == 'color') {
                Provider.of<WardrobeManager>(context, listen: false)
                    .setColors(selectedChoices);
              }
              if (widget.type == 'material') {
                Provider.of<WardrobeManager>(context, listen: false)
                    .setMaterials(selectedChoices);
              }
              if (widget.type == 'outfit_style') {
                Provider.of<OutfitManager>(context, listen: false)
                    .setStyles(selectedChoices);
              }
              if (widget.type == 'outfitStyle') {
                Provider.of<OutfitManager>(context, listen: false)
                    .setStyle(selectedChoices);
              }
              if (widget.type == 'outfit_season') {
                Provider.of<OutfitManager>(context, listen: false)
                    .setSeasons(selectedChoices);
              }
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
        padding: const EdgeInsets.only(bottom: 0),
        child: widget.isScrollable
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(children: _buildChoiceList()))
            : Wrap(runSpacing: 1, spacing: 1, children: _buildChoiceList()));
  }
}
