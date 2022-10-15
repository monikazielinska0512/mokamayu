import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/appbar.dart';
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
        appBar: customAppBar(context, "Wardrobe Screen"),
        body: Column(
          children: [
            const Text("Witaj w twojej szafie!"),
            Text(
                "Jesteś zalogowany jako: " + AuthService().getCurrentUserUID()),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ClothesAddScreen()));
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
          ],
        ));
  }
}
