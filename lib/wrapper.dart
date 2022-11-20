import 'package:flutter/material.dart';
import 'package:mokamayu/screens/authenticate/login_screen.dart';
import 'package:mokamayu/screens/home/home_screen.dart';
import 'package:mokamayu/services/managers/clothes_provider.dart';
import 'package:provider/provider.dart';
import 'models/firebase_user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser?>(context);

    if (user == null) {
      return const LoginScreen();
    } else {
      return ChangeNotifierProvider(
        create: (_) => WardrobeManager(),
        child: const MyHomePage(title: 'Mokamayu'),
      );
    }
  }
}
