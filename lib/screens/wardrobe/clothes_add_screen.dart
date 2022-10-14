import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/photo_upload.dart';
import 'package:mokamayu/reusable_widgets/reusable_text_field.dart';


class ClothesAddScreen extends StatefulWidget {
  const ClothesAddScreen({Key? key}) : super(key: key);
  @override
  _ClothesAddScreenState createState() => _ClothesAddScreenState();
}

class _ClothesAddScreenState extends State<ClothesAddScreen> {
  final TextEditingController _clothesNameController = TextEditingController();

  final List<String> sizes = ['34', '38', 'XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> types = ['One', 'Two', 'Three', 'Four'].toList();
  final List<String> styles = <String>["Classic", "Super", "Cool", "defde", "efewf", "qwrwerwrerw", "Classic", "Super", "Cool", "defde", "efewf", "qwrwerwrerw"];


  String? _clothesSize = "";
  String? dropdownValue = "A";
  final List<String> _chosenStyles = <String>[];

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
            const ImageUpload(),
            reusableTextField("Clothes name", Icons.person_outline, false, _clothesNameController, null),
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
              children: List<Widget>.generate(
                sizes.length,
                    (int index) {
                  return ChoiceChip(
                      label: Text(sizes[index]),
                      selected: _clothesSize == sizes[index],
                      onSelected: (bool selected) {
                        setState(() {
                          _clothesSize = selected ? sizes[index] : null;

                        });});}).toList()),
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
              onPressed: () {
                final data = {
                  "clothes_name": _clothesNameController.text,
                  "type": dropdownValue.toString(),
                  "size": _clothesSize.toString(),
                  "style": _chosenStyles.toString(),
                  "photo_path": ""};
                print(data);
              },
              child: const Text('Add new clothes'),
            )
          ],
        )
        )
    );
  }
}