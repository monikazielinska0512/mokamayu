import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mokamayu/reusable_widgets/reusable_text_field.dart';
import 'package:mokamayu/services/database/database_service.dart';
import 'package:mokamayu/services/storage.dart';

import '../../models/wardrobe/clothes.dart';

class ClothesAddScreen extends StatefulWidget {
  const ClothesAddScreen({Key? key}) : super(key: key);

  @override
  _ClothesAddScreenState createState() => _ClothesAddScreenState();
}

class _ClothesAddScreenState extends State<ClothesAddScreen> {
  final TextEditingController _clothesNameController = TextEditingController();

  final List<String> sizes = ['34', '38', 'XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> types = ['One', 'Two', 'Three', 'Four'].toList();
  final List<String> styles = <String>[
    "Classic",
    "Super",
    "Cool",
    "defde",
    "efewf",
    "qwrwerwrerw",
    "Classic",
    "Super",
    "Cool",
    "defde",
    "efewf",
    "qwrwerwrerw"
  ];

  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future pickImage(ImageSource source) async {
    final pickImage = await _picker.pickImage(source: source);
    setState(() {
      if (pickImage != null) {
        _image = File(pickImage.path);
      } else {print('No image selected');}
    });
  }

  String? _clothesSize = "";
  String? dropdownValue = "A";
  final List<String> _chosenStyles = <String>[];
  String? photoPath = "";

  Iterable<Widget> get stylesTags {
    return styles.map((String style) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            const Text("Fotka"),
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
                          width: 400,
                          height: 400,
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
            DropdownButtonFormField<String>(
              value: dropdownValue,
              items: ["A", "B", "C"]
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => dropdownValue = value);
              },
            ),
            const Text("Size"),
            Wrap(
                children: List<Widget>.generate(sizes.length, (int index) {
              return ChoiceChip(
                  label: Text(sizes[index]),
                  selected: _clothesSize == sizes[index],
                  onSelected: (bool selected) {
                    setState(() {
                      _clothesSize = selected ? sizes[index] : null;
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
                    type: dropdownValue.toString(),
                    photoURL: photoURL.toString(),
                    styles: _chosenStyles);
                DatabaseService.addToWardrobe(data);
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
}
