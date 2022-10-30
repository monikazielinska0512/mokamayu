import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mokamayu/screens/wardrobe/wardrobe_screen.dart';
import 'package:mokamayu/services/storage.dart';

import '../../../models/wardrobe/clothes.dart';
import '../../../res/tags.dart';
import '../../../reusable_widgets/dropdown_menu.dart';
import '../../../reusable_widgets/reusable_text_field.dart';
import '../../../services/database/database_service.dart';

class AddClothesForm extends StatefulWidget {
  final File? photo;
  final String? id;

  const AddClothesForm({Key? key, required this.photo, this.id})
      : super(key: key);

  @override
  _AddClothesFormState createState() => _AddClothesFormState();
}

class _AddClothesFormState extends State<AddClothesForm> {
  final _formKey = GlobalKey<FormState>();


  final TextEditingController _nameController = TextEditingController();

  final List<String> _stylesController = [];
  String? _sizeController = "";
  String? _typeController = Tags.types[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              const BackButton(),
              Column(children: <Widget>[
                reusableTextField("Clothes name", Icons.person_outline, false,
                    _nameController, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                }),
                const SizedBox(
                  height: 40,
                ),
                DropDownMenu(_typeController, Tags.types, (value) {
                  setState(() => _typeController = value);
                }, (value) {
                  if (value == null) {
                    return 'Type is required';
                  }
                  return null;
                }),
                const SizedBox(
                  height: 40,
                ),
                const Text("Size"),
                FormField<String>(
                    builder: (formFieldState) {
                      return Wrap(
                          children:
                          List<Widget>.generate(Tags.sizes.length, (int index) {
                            return ChoiceChip(
                                label: Text(Tags.sizes[index]),
                                selected: _sizeController == Tags.sizes[index],
                                onSelected: (bool selected) {
                                  setState(() {
                                    _sizeController = selected ? Tags.sizes[index] : null;
                                  });
                                });
                          }).toList());
                    }),
                // Wrap(
                //     children:
                //         List<Widget>.generate(Tags.sizes.length, (int index) {
                //   return ChoiceChip(
                //       label: Text(Tags.sizes[index]),
                //       selected: _sizeController == Tags.sizes[index],
                //       onSelected: (bool selected) {
                //         setState(() {
                //           _sizeController = selected ? Tags.sizes[index] : null;
                //         });
                //       });
                // }).toList()),
                const SizedBox(
                  height: 40,
                ),
                Wrap(
                  spacing: 4.0,
                  runSpacing: 0.001,
                  children: stylesTags.toList(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var photoURL = await StorageService()
                        .uploadAndGetURLFile(widget.photo);
                    Clothes data = Clothes(
                        name: _nameController.text,
                        size: _sizeController.toString(),
                        type: _typeController.toString(),
                        photoURL: photoURL.toString(),
                        styles: _stylesController);
                    DatabaseService.addClothes(data);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WardrobeScreen()));
                  },
                  child: const Text('Add new clothes'),
                )
              ])
            ]))));
  }

  Iterable<Widget> get stylesTags {
    return Tags.styles.map((String style) {
      return FilterChip(
        label: Text(style),
        selected: _stylesController.contains(style),
        onSelected: (bool value) {
          setState(() {
            if (value) {
              _stylesController.add(style);
            } else {
              _stylesController.removeWhere((String name) {
                return name == style;
              });
            }
          });
        },
      );
    });
  }
}
