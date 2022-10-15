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
  // final FirebaseAuth auth = FirebaseAuth.instance;
  //
  // String getCurrentUserUID() {
  //   final User? user = auth.currentUser;
  //   final uid = user?.uid;
  //   return uid.toString();
  //   // here you write the codes to input the data into firestore
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Wardrobe Screen"),
      body:
      Column(
        children: [
          Text("Witaj w twojej szafie!") ,
          Text ("Jesteś zalogowany jako: " + AuthService().getCurrentUserUID()),
        FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ClothesAddScreen()));
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        )
        ],
      )
    );
  }
}
