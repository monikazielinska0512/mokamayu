import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mokamayu/models/wardrobe/clothes.dart';
import 'package:mokamayu/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import '../../../models/wardrobe/clothes.dart';
import '../../../services/clothes_provider.dart';
import '../../../services/database/database_service.dart';
import '../../../services/storage.dart';
import '../../../widgets/chips/choice_chips.dart';
import '../wardrobe_screen.dart';
import 'choice_form_field.dart';

class ClothesForm extends StatefulWidget {
  final File? photo;

  const ClothesForm({Key? key, required this.photo}) : super(key: key);

  @override
  _ClothesFormState createState() => _ClothesFormState();
}

class _ClothesFormState extends State<ClothesForm> {
  String _type = "";
  String _size = "";

  @override
  void initState() {
    String _type = "";
    String _size = "";
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 30, bottom: 10, left: 30, right: 30),
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                      autovalidateMode: AutovalidateMode.disabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        if (value.length > 20) {
                          return 'Maximum lenght is 20 characters';
                        }
                        return null;
                      },
                      style: const TextStyle(
                          fontSize: 26,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Enter your clothes name',
                        labelStyle: TextStyle(
                            fontSize: 22,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600),
                        focusedBorder: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 10, bottom: 0, top: 11, right: 15),
                      )),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: ChoiceChipsFormField(
                        autoValidate: true,
                        validator: (value) {
                          if (value == "") {
                            return 'Wybrano M';
                          }
                          return null;
                        },
                        onSaved: (value) => _size = value!,
                        chipsList: ["XS", "S", "M", "L", "XL", "XXL"],
                      )),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Valid')),
                        );

                        //to sobie dodalam do testowania

                        var photoURL = await StorageService()
                            .uploadAndGetURLFile(widget.photo);
                        Clothes data = Clothes(
                            name: "text",
                            size: _size.toString(),
                            type: _type.toString(),
                            photoURL: photoURL.toString(),
                            styles: null);

                        Provider.of<ClothesProvider>(context, listen: false)
                            .addClothes(data);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                      create: (_) => ClothesProvider(),
                                      child:
                                          const MyHomePage(title: 'Mokamayu'),
                                    )));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Not Valid')));
                      }
                    },
                    child: const Text('Add clothes'),
                  ),
                ]))));
  }
}
