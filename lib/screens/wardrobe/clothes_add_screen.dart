import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mokamayu/res/tags.dart';
import 'package:mokamayu/reusable_widgets/reusable_text_field.dart';
import 'package:mokamayu/services/database/database_service.dart';
import 'package:mokamayu/services/storage.dart';

import '../../models/wardrobe/clothes.dart';
import '../../reusable_widgets/dropdown_menu.dart';

class AddClothesForm extends StatefulWidget {
  const AddClothesForm({Key? key}) : super(key: key);

  @override
  _AddClothesFormState createState() => _AddClothesFormState();
}

class _AddClothesFormState extends State<AddClothesForm> {
  final TextEditingController _clothesNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<String> _chosenStyles = [];

  File? _image;
  String? _clothesSize = "";
  String? _clothesType = Tags.types[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(
                  height: 32,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: _image != null
                        ? Column(children: <Widget>[
                            ClipRRect(
                              child: Image.file(
                                _image!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _image = null; //this is important
                                  });
                                },
                                label: const Text('Remove Image'),
                                icon: const Icon(Icons.close))
                          ])
                        : Container(
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            width: 300,
                            height: 400,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const Text("Nazwa"),
            reusableTextField("Clothes name", Icons.person_outline, false,
                _clothesNameController, null),
            const Text("Type"),
            DropDownMenu(_clothesType, Tags.types, (value) {
              setState(() => _clothesType = value);
            }),
            const Text("Size"),
            Wrap(
                children: List<Widget>.generate(Tags.sizes.length, (int index) {
              return ChoiceChip(
                  label: Text(Tags.sizes[index]),
                  selected: _clothesSize == Tags.sizes[index],
                  onSelected: (bool selected) {
                    setState(() {
                      _clothesSize = selected ? Tags.sizes[index] : null;
                    });
                  });
            }).toList()),
            const Text("Style"),
            Wrap(
              spacing: 4.0,
              runSpacing: 0.001,
              children: stylesTags.toList(),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                var photoURL = await StorageService().getURLFile(_image);
                Clothes data = Clothes(
                    name: _clothesNameController.text,
                    size: _clothesSize.toString(),
                    type: _clothesType.toString(),
                    photoURL: photoURL.toString(),
                    styles: _chosenStyles);
                DatabaseService.addToWardrobe(data);
                Navigator.of(context).pop();
              },
              child: const Text('Add new clothes'),
            )
          ],
        )));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          );
        });
  }

  Iterable<Widget> get stylesTags {
    return Tags.styles.map((String style) {
      return FilterChip(
        label: Text(style),
        selected: _chosenStyles.contains(style),
        onSelected: (bool value) {
          setState(() {
            if (value) {
              _chosenStyles.add(style);
            } else {
              _chosenStyles.removeWhere((String name) {
                return name == style;
              });
            }
          });
        },
      );
    });
  }

  Future pickImage(ImageSource source) async {
    final pickImage = await _picker.pickImage(source: source);
    setState(() {
      if (pickImage != null) {
        _image = File(pickImage.path);
      } else {
        print('No image selected');
      }
    });
  }
}
