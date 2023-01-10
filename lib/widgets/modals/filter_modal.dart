import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:mokamayu/services/managers/outfit_manager.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/wardrobe_item.dart';
import '../../services/managers/wardrobe_manager.dart';

//ignore: must_be_immutable
class FilterModal extends StatefulWidget {
  Future<List<WardrobeItem>>? futureItemListCopy;
  Future<List<Outfit>>? futureOutfitListCopy;
  List<String> selectedTypes = Tags.getTypes();
  List<String> selectedStyles = Tags.styles;
  List<String> selectedSizes = Tags.sizes;

  List<String> selectedOutfitStyles = OutfitTags.styles;
  List<String> selectedOutfitSeasons = OutfitTags.seasons;
  Function(Future<List<WardrobeItem>>?)? onApplyWardrobe;
  Function(Future<List<Outfit>>?)? onApplyOutfits;

  FilterModal({Key? key, this.onApplyWardrobe, this.onApplyOutfits})
      : super(key: key);

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
        height: 0.04,
        width: 0.16,
        icon: Ionicons.filter,
        onPressed: () => showModal());
  }

  void clearFilters() {
    setState(() {
      widget.selectedTypes = [];
      widget.selectedSizes = [];
      widget.selectedStyles = [];
    });
  }

  Widget buildBackgroundImage() {
    return GestureDetector(
        onTap: () => context.pop(),
        child: Stack(children: const [
          BackgroundImage(
              imagePath: "assets/images/full_background.png",
              imageShift: 0,
              opacity: 0.5),
        ]));
  }

  Widget buildTypesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(S.of(context).clothing_types,
          style: TextStyles.paragraphRegularSemiBold18(),
          textAlign: TextAlign.start),
      Padding(
          padding: const EdgeInsets.only(bottom: 5, top: 5),
          child: MultiSelectChip(Tags.getLanguagesTypes(context),
              isScrollable: false,
              onSelectionChanged: (selectedList) => {
                    setState(() {
                      widget.selectedTypes = selectedList;
                    })
                  },
              type: "type",
              chipsColor: ColorsConstants.peachy))
    ]);
  }

  Widget buildStylesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(S.of(context).style,
          style: TextStyles.paragraphRegularSemiBold18(),
          textAlign: TextAlign.start),
      Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 5),
          child: MultiSelectChip(
              chipsColor: ColorsConstants.mint,
              Tags.styles,
              isScrollable: false,
              type: "style",
              onSelectionChanged: (selectedList) => {
                    widget.selectedStyles = selectedList,
                    // print(widget.selectedStyles)
                  })),
    ]);
  }

  Widget buildOutfitStylesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(S.of(context).style,
          style: TextStyles.paragraphRegularSemiBold18(),
          textAlign: TextAlign.start),
      Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 5),
          child: MultiSelectChip(
              chipsColor: ColorsConstants.mint,
              OutfitTags.styles,
              isScrollable: false,
              type: "outfit_style",
              onSelectionChanged: (selectedList) => {
                    widget.selectedOutfitStyles = selectedList,
                    // print(widget.selectedStyles)
                  })),
    ]);
  }

  Widget buildOutfitSeasonSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Seasons",
          style: TextStyles.paragraphRegularSemiBold18(),
          textAlign: TextAlign.start),
      Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 5),
          child: MultiSelectChip(
              chipsColor: ColorsConstants.mint,
              OutfitTags.seasons,
              isScrollable: false,
              type: "outfit_season",
              onSelectionChanged: (selectedList) => {
                    widget.selectedOutfitSeasons = selectedList,
                    // print(widget.selectedStyles)
                  })),
    ]);
  }

  Widget buildSizesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(S.of(context).size,
          style: TextStyles.paragraphRegularSemiBold18(),
          textAlign: TextAlign.start),
      Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 5),
          child: MultiSelectChip(
              chipsColor: ColorsConstants.sunflower,
              Tags.sizes,
              type: "size",
              onSelectionChanged: (selectedList) => {
                    widget.selectedSizes = selectedList,
                    // print(widget.selectedSizes)
                  }))
    ]);
  }

  Widget buildApplyButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ButtonDarker(
          context,
          S.of(context).apply_filters,
          () => {
                if (widget.onApplyWardrobe != null)
                  {
                    widget.futureItemListCopy = Provider.of<WardrobeManager>(
                            context,
                            listen: false)
                        .filterWardrobe(
                            context,
                            widget.selectedTypes,
                            widget.selectedStyles,
                            widget.selectedSizes,
                            Provider.of<WardrobeManager>(context, listen: false)
                                .getFinalWardrobeItemList),
                    if (widget.futureItemListCopy != null)
                      {
                        Provider.of<WardrobeManager>(context, listen: false)
                            .setWardrobeItemListCopy(widget.futureItemListCopy!)
                      },
                  }
                else
                  {
                    widget.futureOutfitListCopy = Provider.of<OutfitManager>(
                            context,
                            listen: false)
                        .filterOutfits(
                            context,
                            widget.selectedOutfitStyles,
                            widget.selectedOutfitSeasons,
                            Provider.of<OutfitManager>(context, listen: false)
                                .getFinalOutfitList),
                    if (widget.futureOutfitListCopy != null)
                      {
                        Provider.of<OutfitManager>(context, listen: false)
                            .setOutfitsCopy(widget.futureOutfitListCopy!)
                      },
                  },

                // widget.onApply!(widget.futureItemListCopy),
                context.pop(),
                // clearFilters()
              },
          shouldExpand: false,
          height: 0.060,
          width: 0.6),
    );
  }

  void showModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) {
        return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          buildBackgroundImage(),
          Container(
              child: DraggableScrollableSheet(
                  expand: true,
                  builder: (_, controller) {
                    return Container(
                        height: 500.0,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            children: <Widget>[
                              buildCloseButton(),
                              buildTitle(),
                              Container(
                                  child: SingleChildScrollView(
                                      child: Container(
                                          child: buildFiltersSection()))),
                              buildApplyButton()
                            ],
                          ),
                        ));
                  }))
        ]);
      },
    );
  }

  Widget buildCloseButton() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 30, bottom: 15),
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Ionicons.close_outline,
                size: 25,
                color: Colors.grey,
              )),
        ));
  }

  Widget buildTitle() {
    return Align(
      alignment: Alignment.center,
      child: Text(S.of(context).filters, style: TextStyles.h4()),
    );
  }

  Widget buildFiltersSection() {
    return Align(
        alignment: Alignment.topLeft,
        child: Padding(
            padding:
                const EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 30),
            child: widget.onApplyWardrobe != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        buildTypesSection(),
                        buildStylesSection(),
                        buildSizesSection()
                      ])
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        buildOutfitStylesSection(),
                        buildOutfitSeasonSection()
                      ])));
  }
}
