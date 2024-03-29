import 'package:flutter/material.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import '../../services/managers/managers.dart';
import '../../utils/validator.dart';
import '../../widgets/chips/chips.dart';

//ignore: must_be_immutable
class OutfitForm extends StatelessWidget {
  OutfitForm({super.key, required this.formKey, this.item});

  final Outfit? item;
  final GlobalKey<FormState> formKey;
  String _season = "";
  List<String> _styles = [];

  @override
  Widget build(BuildContext context) {
    if (item != null) {
      _styles = item!.styles;
      _season = item!.season;
    }
    // else {
    //   _season = Provider.of<OutfitManager>(context, listen: false).getSeason!;
    //   _styles = Provider.of<OutfitManager>(context, listen: false).getStyle;
    // }

    return Scrollbar(
        thickness: 2,
        radius: const Radius.circular(10),
        scrollbarOrientation: ScrollbarOrientation.right,
        child: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(children: [
                  buildSeasonChipsField(context),
                  buildStyleChipsField(context)
                ]))));
  }

  Widget buildSeasonChipsField(BuildContext context) {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 10, right: 5),
              child: Text(S.of(context).season,
                  style: TextStyles.paragraphRegularSemiBold18()))),
      Align(
          alignment: Alignment.centerLeft,
          child: SingleSelectChipsFormField(
            initialValue: _season,
            type: 'season',
            autoValidate: true,
            context: context,
            validator: (value) =>
                Validator.checkIfSingleValueSelected(value!, context),
            onSaved: (value) {
              _season = value!;
            },
            color: ColorsConstants.darkMint,
            chipsList: OutfitTags.getSeasons(context),
          ))
    ]);
  }

  Widget buildStyleChipsField(BuildContext context) {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 10),
              child: Text(S.of(context).style,
                  style: TextStyles.paragraphRegularSemiBold18()))),
      Align(
          alignment: Alignment.centerLeft,
          child: MultiSelectChip(
              chipsColor: ColorsConstants.lightBrown,
              OutfitTags.getLanguagesStyles(context),
              isScrollable: false,
              initialValues: _styles,
              type: "outfitStyle",
              onSelectionChanged: (selectedList) => {
                    _styles = selectedList,
                  })),
    ]);
  }
}
