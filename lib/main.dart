import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/services/authentication/auth.dart';
import 'package:mokamayu/wrapper.dart';
import 'models/user/firebase_user.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kDebugMode) {
    try {
      //do testowania na emulatorach lokalnie - tu akurat moje ip, wiec jak cos to u siebie zmiencie
      FirebaseFirestore.instance.useFirestoreEmulator('192.168.1.37', 8080);
      await FirebaseAuth.instance.useAuthEmulator('192.168.1.37', 9099);
    } catch (e) {
      // ignore: avoids_print
      print(e);
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        title: 'Mokamayu',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: CustomColors.primary),
        ),
        home: const Wrapper(),
      ),
    );
  }
}
