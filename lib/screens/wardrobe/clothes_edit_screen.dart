import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/screens/wardrobe/picker_image.dart';
import 'package:mokamayu/screens/wardrobe/wardrobe_screen.dart';
import 'package:mokamayu/services/auth.dart';
import 'package:mokamayu/services/database/database_service.dart';

import '../../models/wardrobe/clothes.dart';
import '../../res/tags.dart';
import '../../reusable_widgets/dropdown_menu.dart';
import '../../reusable_widgets/reusable_text_field.dart';

class ClothesForm extends StatefulWidget {
  String? clothesID;

  ClothesForm({Key? key, this.clothesID}) : super(key: key);

  @override
  _ClothesFormState createState() => _ClothesFormState();
}

class _ClothesFormState extends State<ClothesForm> {
  late String? id = widget.clothesID;
  final TextEditingController _clothesNameController = TextEditingController();
  late List<String> _chosenStyles = [];
  late Image? _image;
  late String? _clothesSize = "";
  late String? _clothesType = Tags.types[0];

  @override
  Widget build(BuildContext context) {
    CollectionReference clothes = FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService().getCurrentUserUID())
        .collection("clothes");
    return FutureBuilder<DocumentSnapshot>(
      future: clothes.doc(id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          String nameTextField = data['name'].toString();
          String photoURL = data['photoURL']!.toString();
          _image = Image.network(photoURL);
          _chosenStyles = List<String>.from(data['styles']);
          _clothesSize = data['size'];
          _clothesType = data['type'].toString();

          return Scaffold(
              body: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(
                    height: 32,
                  ),
                  Center(
                      child: PickerImage(
                    pickedImage: Image.network(photoURL),
                  )),
                ],
              ),
              reusableTextField(nameTextField, Icons.person_outline, false,
                  _clothesNameController, null),
              const Text("Type"),
              DropDownMenu(_clothesType, Tags.types, (value) {
                setState(() => _clothesType = value);
              }),
              const Text("Size"),
              Wrap(
                  children:
                      List<Widget>.generate(Tags.sizes.length, (int index) {
                return ChoiceChip(
                    label: Text(Tags.sizes[index]),
                    selected: _clothesSize == Tags.sizes[index],
                    onSelected: (bool selected) {
                      setState(() {
                        print(_clothesSize.toString());
                        _clothesSize = selected ? Tags.sizes[index] : null;
                      });
                    });
              }).toList()),
              const Text("Style"),
              Wrap(
                spacing: 4.0,
                runSpacing: 0.001,
                children: stylesTags(_chosenStyles).toList(),
              ),
              TextButton(
                onPressed: () async {
                  Clothes data = Clothes(
                      name: _clothesNameController.text,
                      size: _clothesSize.toString(),
                      type: _clothesType.toString(),
                      photoURL: photoURL.toString(),
                      styles: _chosenStyles);
                  DatabaseService.updateClothes(id!, data);
                  Navigator.of(context).pop(const WardrobeScreen());
                },
                child: const Text('Update'),
              ),
              TextButton(
                onPressed: () async {
                  DatabaseService.removeClothes(id!);
                  //TODO remove photo from storage
                },
                child: const Text('Delete'),
              )
            ],
          )));
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Iterable<Widget> stylesTags(List<String>? _chosenStyles) {
    return Tags.styles.map((String style) {
      return FilterChip(
        label: Text(style),
        selected: _chosenStyles!.contains(style),
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
}
