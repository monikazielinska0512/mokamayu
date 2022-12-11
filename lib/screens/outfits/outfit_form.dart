import 'package:flutter/material.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../services/managers/outfit_manager.dart';
import '../../utils/validator.dart';
import '../../widgets/chips/single_select_chips_formfield.dart';

class OutfitForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const OutfitForm({super.key, required this.formKey, this.item});
  final Outfit? item;

  @override
  State<OutfitForm> createState() => _OutfitFormState();
}
class _OutfitFormState extends State<OutfitForm> {
  String _season = "";
  String _style = "";
  @override
  Widget build(BuildContext context) {
    _season = Provider.of<OutfitManager>(context, listen: false).getSeason;
    print(_season);
    _style = Provider.of<OutfitManager>(context, listen: false).getStyle;
    print(_style);
    return Padding(
        padding:
            const EdgeInsets.only(top: 30, bottom: 10, left: 30, right: 30),
        child: SingleChildScrollView(
            child: Form(
                key: widget.formKey,
                child: Column(children: [
                  buildSeasonChipsField(),
                  buildStyleChipsField()
                ]))));
  }

  Widget buildSeasonChipsField() {
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
            autoValidate: true,
            validator: (value) =>
                Validator.checkIfSingleValueSelected(value!, context),
            onSaved: (value) {
              _season = value!;
              Provider.of<OutfitManager>(context, listen: false)
                  .setSeason(_season);
            },
            color: ColorsConstants.darkMint,
            chipsList: const ["Spring", "Summer", "Fall", "Winter"],
          ))
    ]);
  }

  Widget buildStyleChipsField() {
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
            autoValidate: true,
            validator: (value) =>
                Validator.checkIfSingleValueSelected(value!, context),
            onSaved: (value) {
              _style = value!;
              Provider.of<OutfitManager>(context, listen: false)
                  .setStyle(_style);
            },
            color: ColorsConstants.sunflower,
            chipsList: const ["Party", "Work", "Active", "Casual", "Wedding"],
          )),
    ]);
  }

  // Widget buildAddButton() {
  //   return ElevatedButton(
  //       child: const Text('Apply'),
  //       onPressed: () async {
  //         _formKey.currentState!.save();
  //         if (_formKey.currentState!.validate()) {
  //           String url = await StorageService()
  //               .uploadFile(context, widget.photoPath ?? "");
  //           final item = WardrobeItem(
  //               name: _name,
  //               type: _type,
  //               size: _size,
  //               photoURL: url,
  //               styles: _styles,
  //               created: DateTime.now());

  //           Provider.of<WardrobeManager>(context, listen: false)
  //               .addWardrobeItem(item);

  //           _type = "";
  //           _size = "";
  //           _name = "";
  //           _styles = [];
  //           context.go("/home/0");
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('Dodano do bazy danych')),
  //           );
  //         } else {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(content: Text('Formularz nie jest poprawny')));
  //         }
  //       });
  // }

  // Widget buildUpdateButton() {
  //   return ElevatedButton(
  //       child: const Text('Update'),
  //       onPressed: () async {
  //         _formKey.currentState!.save();
  //         if (_formKey.currentState!.validate()) {
  //           Provider.of<WardrobeManager>(context, listen: false)
  //               .updateWardrobeItem(widget.item?.reference ?? "", _name, _type,
  //                   _size, widget.item?.photoURL ?? "", _styles);
  //           context.go("/home/0");
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('Update')),
  //           );
  //         } else {
  //           ScaffoldMessenger.of(context)
  //               .showSnackBar(const SnackBar(content: Text('Error')));
  //         }
  //       });
  // }
}
