import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../../models/wardrobe/clothes.dart';
import '../../../res/tags.dart';
import '../../../reusable_widgets/dropdown_menu.dart';
import '../../../reusable_widgets/reusable_text_field.dart';
import '../../../services/database/database_service.dart';

class EditClothesForm extends StatefulWidget {
  Clothes? clothes;
  String clothesID;

  EditClothesForm({Key? key, required this.clothes, required this.clothesID})
      : super(key: key);

  @override
  State<EditClothesForm> createState() => _EditClothesFormState();
}

class _EditClothesFormState extends State<EditClothesForm> {
  List<String>? _stylesController = [];
  TextEditingController _nameController = TextEditingController();
  String? _sizeController = "";
  String? _typeController = Tags.types[0];

  @override
  void initState() {
    _stylesController = widget.clothes?.styles ?? [];
    _nameController.text = widget.clothes?.name ?? "";
    _sizeController = widget.clothes?.size ?? "";
    _typeController = widget.clothes?.type ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      reusableTextField(
          "Clothes name", Icons.person_outline, false, _nameController, null),
      DropDownMenu(_typeController, Tags.types, (value) {
        setState(() => _typeController = value);
      }, (value) {
        if (value == null) {
          return 'Type is required';
        }
      }),
      Wrap(
          children: List<Widget>.generate(Tags.sizes.length, (int index) {
        return ChoiceChip(
            label: Text(Tags.sizes[index]),
            selected: _sizeController == Tags.sizes[index],
            onSelected: (bool selected) {
              setState(() {
                _sizeController = selected ? Tags.sizes[index] : null;
              });
            });
      }).toList()),
      Wrap(
        spacing: 4.0,
        runSpacing: 0.001,
        children: stylesTags.toList(),
      ),
      TextButton(
          onPressed: () {
            DatabaseService.updateClothes(
                widget.clothesID,
                Clothes(
                    name: _nameController.text,
                    type: _typeController,
                    size: _sizeController,
                    styles: _stylesController,
                    photoURL: widget.clothes?.photoURL));
            Navigator.of(context).pop();
          },
          child: const Text("Update")),
      TextButton(
          onPressed: () {
            DatabaseService.removeClothes(widget.clothesID);
            FirebaseStorage.instance.refFromURL(widget.clothes!.photoURL!).delete();
            Navigator.of(context).pop();
          },
          child: const Text("Delete")),
      const BackButton()
    ]));
  }

  Iterable<Widget> get stylesTags {
    return Tags.styles.map((String style) {
      return FilterChip(
        label: Text(style),
        selected: _stylesController!.contains(style),
        onSelected: (bool value) {
          setState(() {
            if (value) {
              _stylesController?.add(style);
            } else {
              _stylesController?.removeWhere((String name) {
                return name == style;
              });
            }
          });
        },
      );
    });
  }
}
