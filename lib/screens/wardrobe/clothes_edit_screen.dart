import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mokamayu/reusable_widgets/appbar.dart';
import 'package:mokamayu/screens/wardrobe/wardrobe_screen.dart';
import 'package:mokamayu/services/auth.dart';
import 'dart:io';

import '../../models/wardrobe/clothes.dart';
import '../../res/tags.dart';
import '../../reusable_widgets/dropdown_menu.dart';
import '../../reusable_widgets/reusable_text_field.dart';
import '../../services/database/database_service.dart';
import '../../services/storage.dart';

class ClothesForm extends StatefulWidget {
  String? clothesID;

  ClothesForm({Key? key, this.clothesID}) : super(key: key);

  @override
  _ClothesFormState createState() => _ClothesFormState();
}

class _ClothesFormState extends State<ClothesForm> {
  late String id = widget.clothesID!;
  final TextEditingController _clothesNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    CollectionReference clothes = FirebaseFirestore.instance.collection('users')
        .doc(AuthService().getCurrentUserUID())
        .collection("clothes");
    return
      FutureBuilder<DocumentSnapshot>(
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
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            String nameTextField = data['name'].toString();
            String photoURL = data['photo_url'].toString();
            final List<String> _chosenStyles = List<String>.from(data['styles']);
            String? _clothesSize = data['size'];
            String? _clothesType = data['type'].toString();
            File? _image;

            return Scaffold(
                appBar: customAppBar(context, data['name']),
                body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        // Column(
                        //   children: <Widget>[
                        //     const SizedBox(
                        //       height: 32,
                        //     ),
                        //     Center(
                        //       child: GestureDetector(
                        //         onTap: () {
                        //           _showPicker(context);
                        //         },
                        //         child: _image != null
                        //             ? Column(children: <Widget>[
                        //           ClipRRect(
                        //             child: Image.file(
                        //               _image,
                        //               width: 200,
                        //               height: 200,
                        //               fit: BoxFit.fitHeight,
                        //             ),
                        //           ),
                        //           ElevatedButton.icon(
                        //               onPressed: () {
                        //                 setState(() {
                        //                   _image = null; //this is important
                        //                 });
                        //               },
                        //               label: const Text('Remove Image'),
                        //               icon: const Icon(Icons.close))
                        //         ])
                        //             : Container(
                        //           decoration: BoxDecoration(
                        //               color: Colors.grey[200]),
                        //           width: 300,
                        //           height: 400,
                        //           child: Icon(
                        //             Icons.camera_alt,
                        //             color: Colors.grey[800],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const Text("Nazwa"),
                        reusableTextField(
                            nameTextField, Icons.person_outline, false,
                            _clothesNameController, null),

                        const Text("Type"),
                        DropDownMenu(_clothesType, Tags.types, (value) {
                          setState(() => _clothesType = value);
                        }),

                        const Text("Size"),
                        Wrap(
                            children: List<Widget>.generate(
                                Tags.sizes.length, (int index) {
                              return ChoiceChip(
                                  label: Text(Tags.sizes[index]),
                                  selected: _clothesSize == Tags.sizes[index],
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _clothesSize =
                                      selected ? Tags.sizes[index] : null;
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
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue),
                          ),
                          onPressed: () async {
                            var photoURL = await StorageService().getURLFile(
                                _image);
                            Clothes data = Clothes(
                                name: _clothesNameController.text,
                                size: _clothesSize.toString(),
                                type: _clothesType.toString(),
                                photoURL: photoURL.toString(),
                                styles: _chosenStyles);
                            DatabaseService.addToWardrobe(data);
                            Navigator.of(context).pop(const WardrobeScreen());
                          },
                          child: const Text('Add new clothes'),
                        )
                      ],
                    )));
          }
          return  const CircularProgressIndicator();

        },
      );
  }

  // void _showPicker(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return SafeArea(
  //           child: Wrap(
  //             children: <Widget>[
  //               ListTile(
  //                 leading: const Icon(Icons.photo_camera),
  //                 title: const Text('Camera'),
  //                 onTap: () {
  //                   pickImage(ImageSource.camera);
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //               ListTile(
  //                   leading: const Icon(Icons.photo_library),
  //                   title: const Text('Gallery'),
  //                   onTap: () {
  //                     pickImage(ImageSource.gallery);
  //                     Navigator.of(context).pop();
  //                   }),
  //             ],
  //           ),
  //         );
  //       });
  // }

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

  // Future pickImage(ImageSource source) async {
  //   final pickImage = await _picker.pickImage(source: source);
  //   setState(() {
  //     if (pickImage != null) {
  //       _image = File(pickImage.path);
  //     } else {
  //       print('No image selected');
  //     }
  //   });
  // }
}
