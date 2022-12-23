import 'package:flutter/material.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../services/managers/outfit_manager.dart';
import '../../utils/validator.dart';
import '../../widgets/chips/single_select_chips_formfield.dart';

class OutfitForm extends StatelessWidget {
  OutfitForm({super.key, required this.formKey, this.item});
  final Outfit? item;
  final GlobalKey<FormState> formKey;
  String _season = "";
  String _style = "";
  @override
  Widget build(BuildContext context) {
    _season = Provider.of<OutfitManager>(context, listen: false).getSeason!;
    _style = Provider.of<OutfitManager>(context, listen: false).getStyle!;
    return Padding(
        padding:
            const EdgeInsets.only(top: 30, bottom: 10, left: 30, right: 30),
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
              padding: const EdgeInsets.only(bottom: 5, top: 10),
              child: Text("Season",
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
            chipsList: const ["Spring", "Summer", "Fall", "Winter"],
          ))
    ]);
  }

  Widget buildStyleChipsField(BuildContext context) {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 10),
              child: Text("Style",
                  style: TextStyles.paragraphRegularSemiBold18()))),
      Align(
          alignment: Alignment.centerLeft,
          child: SingleSelectChipsFormField(
            initialValue: _style,
            type: 'style',
            autoValidate: true,
            context: context,
            validator: (value) =>
                Validator.checkIfSingleValueSelected(value!, context),
            onSaved: (value) {
              _style = value!;
            },
            color: ColorsConstants.sunflower,
            chipsList: const ["Party", "Work", "Active", "Casual", "Wedding"],
          )),
    ]);
  }
}
