import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/photo_grid/photo_grid.dart';

import '../../reusable_widgets/floating_button.dart';
import '../../services/auth.dart';
import 'clothes_add_screen.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({Key? key}) : super(key: key);

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(children: [
          Text("Jesteś zalogowany jako: " + AuthService().getCurrentUserUID()),
          const Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                  child: PhotoGrid()))
        ]),
      ]),
      floatingActionButton: FloatingButton(
          context, const AddClothesForm(), const Icon(Icons.add)),
    );
  }
}
