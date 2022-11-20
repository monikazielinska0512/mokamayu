import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'clothes_form_screen.dart';
import 'package:mokamayu/services/managers/managers.dart';

class AddPhotoScreen extends StatefulWidget {
  AddPhotoScreen({Key? key}) : super(key: key);
  final PhotoPicker _picker = PhotoPicker(width: 370, height: 500);

  @override
  _AddPhotoScreenState createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return BasicScreen(
        context: context,
        child: Center(
            child: SizedBox(
                height: double.maxFinite,
                child: Column(children: <Widget>[
                  const BackButton(),
                  widget._picker,
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        widget._picker.photo != null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                          create: (_) => WardrobeManager(),
                                          child: AddClothesForm(
                                              photo: widget._picker.photo),
                                        )))
                            : null;
                      },
                      child: const Text("Przjedź dalej"))
                ]))));
  }
}

// class AddPhotoScreen extends BasePageScreen {
//   AddPhotoScreen({Key? key}) : super(key: key);
//   final PhotoPicker _picker = PhotoPicker(width: 370, height: 500);
//
//   @override
//   _AddPhotoScreenState createState() => _AddPhotoScreenState();
// }
//
// class _AddPhotoScreenState extends BasePageScreenState<AddPhotoScreen> with BaseScreen {
//   @override
//   void initState() {
//     isNavBarVisible(false);
//     isAppBarVisible(false);
//     super.initState();
//   }
//
//   @override
//   PreferredSizeWidget? appBar() {
//     return null;
//   }
//
//   @override
//   Widget body() {
//     return Center(
//         child: SizedBox(
//             height: double.maxFinite,
//             child: Column(children: <Widget>[
//               const BackButton(),
//               widget._picker,
//               const SizedBox(height: 10),
//               TextButton(
//                   onPressed: () {
//                     widget._picker.photo != null
//                         ? Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ChangeNotifierProvider(
//                                       create: (_) => WardrobeManager(),
//                                       child: AddClothesForm(
//                                           photo: widget._picker.photo),
//                                     )))
//                         : null;
//                   },
//                   child: const Text("Przjedź dalej"))
//             ])));
//   }
//
//   @override
//   Widget? navBar() {
//     return null;
//   }
// }
