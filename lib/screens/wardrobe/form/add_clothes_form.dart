import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mokamayu/screens/wardrobe/form/form.dart';

class AddClothesForm extends StatefulWidget {
  final File? photo;

  const AddClothesForm({Key? key, required this.photo}) : super(key: key);

  @override
  _AddClothesFormState createState() => _AddClothesFormState();
}

class _AddClothesFormState extends State<AddClothesForm> {
  final _formKey = GlobalKey<FormState>();

  // String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        ClipRRect(
          child: Image.file(
            widget.photo!,
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
        ),
        const BackButton(),
        Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 20,
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40)),
                    ),
                    child: ClothesForm(photo: widget.photo))))
      ],
    ));
  }
}

// final _formKey = GlobalKey<FormState>();
// final TextEditingController _nameController = TextEditingController();
// final List<String> _stylesController = [];
// String? _sizeController = "";
// String? _typeController = Tags.types[0];
// return Scaffold(
//     body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//             child: Column(children: <Widget>[
//           const SizedBox(
//             height: 40,
//           ),
//           const BackButton(),
//           Column(children: <Widget>[
//             reusableTextField("Clothes name", Icons.person_outline, false,
//                 _nameController, (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter name';
//               }
//               return null;
//             }),
//             const SizedBox(
//               height: 40,
//             ),
//             DropDownMenu(_typeController, Tags.types, (value) {
//               setState(() => _typeController = value);
//             }, (value) {
//               if (value == null) {
//                 return 'Type is required';
//               }
//               return null;
//             }),
//             const SizedBox(
//               height: 40,
//             ),
//             const Text("Size"),
//             FormField<String>(
//                 builder: (formFieldState) {
//                   return Wrap(
//                       children:
//                       List<Widget>.generate(Tags.sizes.length, (int index) {
//                         return ChoiceChip(
//                             label: Text(Tags.sizes[index]),
//                             selected: _sizeController == Tags.sizes[index],
//                             onSelected: (bool selected) {
//                               setState(() {
//                                 _sizeController = selected ? Tags.sizes[index] : null;
//                               });
//                             });
//                       }).toList());
//                 }),
//             const SizedBox(
//               height: 40,
//             ),
//             Wrap(
//               spacing: 4.0,
//               runSpacing: 0.001,
//               children: stylesTags.toList(),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 var photoURL = await StorageService()
//                     .uploadAndGetURLFile(widget.photo);
//                 Clothes data = Clothes(
//                     name: _nameController.text,
//                     size: _sizeController.toString(),
//                     type: _typeController.toString(),
//                     photoURL: photoURL.toString(),
//                     styles: _stylesController);
//                 DatabaseService.addClothes(data);
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const WardrobeScreen()));
//               },
//               child: const Text('Add new clothes'),
//             )
//           ])
//         ]))));

// Iterable<Widget> get stylesTags {
//   return Tags.styles.map((String style) {
//     return FilterChip(
//       label: Text(style),
//       selected: _stylesController.contains(style),
//       onSelected: (bool value) {
//         setState(() {
//           if (value) {
//             _stylesController.add(style);
//           } else {
//             _stylesController.removeWhere((String name) {
//               return name == style;
//             });
//           }
//         });
//       },
//     );
//   });
// }
