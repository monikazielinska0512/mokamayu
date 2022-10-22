import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mokamayu/screens/authenticate/login_screen.dart';
import 'package:mokamayu/services/auth.dart';
import 'models/user/firebase_user.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
          primarySwatch: Colors.pink,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
