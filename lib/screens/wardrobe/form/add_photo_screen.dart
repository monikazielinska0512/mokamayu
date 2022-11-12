import 'package:flutter/material.dart';
import 'package:mokamayu/widgets/basic_page.dart';
import 'package:provider/provider.dart';
import '../../../services/clothes_provider.dart';
import '../../../widgets/photo_picker.dart';
import 'add_clothes_form.dart';

class PhotoPickerScreen extends StatefulWidget {
  PhotoPickerScreen({Key? key}) : super(key: key);

  @override
  _PhotoPickerScreenState createState() => _PhotoPickerScreenState();
}

class _PhotoPickerScreenState extends State<PhotoPickerScreen> {
  @override
  Widget build(BuildContext context) {
    final PhotoPicker _picker = PhotoPicker(
        width: 370, height: MediaQuery.of(context).size.height * 0.7);
    return BasicPage(
        context: context,
        child: Center(
            child: SizedBox(
                height: double.maxFinite,
                child: Column(children: <Widget>[
                  BackButton(),
                  _picker,
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        _picker.photo != null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                          create: (_) => ClothesProvider(),
                                          child: AddClothesForm(
                                              photo: _picker.photo),
                                        )))
                            : null;
                      },
                      child: const Text("Przjedź dalej"))
                ]))));
  }
}
