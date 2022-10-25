import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/appbar.dart';
import 'package:mokamayu/reusable_widgets/photo_grid/photo_grid.dart';
import 'package:mokamayu/screens/wardrobe/add_photo_screen.dart';
import '../../reusable_widgets/floating_button.dart';
import '../../services/auth.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({Key? key}) : super(key: key);

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, "Wardrobe Screen"),
        body: Stack(children: [
          Column(children: [
            Text(
                "Jesteś zalogowany jako: " + AuthService().getCurrentUserUID()),
            const Expanded(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                    child: PhotoGrid()))
          ]),
          FloatingButton(
              context, ImageUploads(), const Icon(Icons.add))
        ]));
  }
}
