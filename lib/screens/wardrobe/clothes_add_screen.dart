// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mokamayu/reusable_widgets/reusable_text_field.dart';
// import 'package:mokamayu/res/tags.dart';
// import 'package:mokamayu/screens/wardrobe/wardrobe_screen.dart';
// import 'package:mokamayu/services/database/database_service.dart';
// import 'package:mokamayu/services/storage.dart';
// import '../../models/wardrobe/clothes.dart';
// import '../../reusable_widgets/dropdown_menu.dart';
//
// class AddClothesForm extends StatefulWidget {
//   const AddClothesForm({Key? key}) : super(key: key);
//
//   @override
//   _AddClothesFormState createState() => _AddClothesFormState();
// }
//
// class _AddClothesFormState extends State<AddClothesForm> {
//   final TextEditingController _clothesNameController = TextEditingController();
//   final List<String> _chosenStyles = [];
//   String? _clothesSize = "";
//   String? _clothesType = Tags.types[0];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: SingleChildScrollView(
//             child: Column(children: <Widget>[
//           Column(
//             children: <Widget>[
//               const Text("Nazwa"),
//               reusableTextField("Clothes name", Icons.person_outline, false,
//                   _clothesNameController, null),
//               const Text("Type"),
//               DropDownMenu(_clothesType, Tags.types, (value) {
//                 setState(() => _clothesType = value);
//               }),
//               const Text("Size"),
//               Wrap(
//                   children:
//                       List<Widget>.generate(Tags.sizes.length, (int index) {
//                 return ChoiceChip(
//                     label: Text(Tags.sizes[index]),
//                     selected: _clothesSize == Tags.sizes[index],
//                     onSelected: (bool selected) {
//                       setState(() {
//                         _clothesSize = selected ? Tags.sizes[index] : null;
//                       });
//                     });
//               }).toList()),
//               const Text("Style"),
//               Wrap(
//                 spacing: 4.0,
//                 runSpacing: 0.001,
//                 children: stylesTags.toList(),
//               ),
//               TextButton(
//                 style: ButtonStyle(
//                   foregroundColor:
//                       MaterialStateProperty.all<Color>(Colors.blue),
//                 ),
//                 onPressed: () async {
//                   var photoURL = await StorageService().getURLFile(_image);
//                   Clothes data = Clothes(
//                       name: _clothesNameController.text,
//                       size: _clothesSize.toString(),
//                       type: _clothesType.toString(),
//                       photoURL: photoURL.toString(),
//                       styles: _chosenStyles);
//                   DatabaseService.addClothes(data);
//                   Navigator.of(context).pop(const WardrobeScreen());
//                 },
//                 child: const Text('Add new clothes'),
//               )
//             ],
//           )
//         ])));
//   }
//
//   Iterable<Widget> get stylesTags {
//     return Tags.styles.map((String style) {
//       return FilterChip(
//         label: Text(style),
//         selected: _chosenStyles.contains(style),
//         onSelected: (bool value) {
//           setState(() {
//             if (value) {
//               _chosenStyles.add(style);
//             } else {
//               _chosenStyles.removeWhere((String name) {
//                 return name == style;
//               });
//             }
//           });
//         },
//       );
//     });
//   }
// }
