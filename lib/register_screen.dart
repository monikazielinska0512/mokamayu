import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mokamayu/generated/l10n.dart';
import 'package:mokamayu/home_screen.dart';
import 'package:mokamayu/reusable_widgets/reusable_text_field.dart';
import 'package:mokamayu/reusable_widgets/reusable_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _retypepasswordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 244, 232, 217),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            S.of(context).sign_up,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            width: deviceWidth(context),
            height: deviceHeight(context),
            child: SingleChildScrollView(
                child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, deviceHeight(context) * 0, 0, 0),
                    child: Column(children: <Widget>[
                      Container(
                        height: deviceWidth(context),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child: Image.asset(
                                "assets/mountains_zoomed.png",
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Positioned(
                              child: Image.asset(
                                "assets/woman.png",
                                fit: BoxFit.fitWidth,
                                height: 260,
                              ),
                              right: 20,
                              bottom: 6,
                            )
                          ],
                        ),
                      ),
                      Form(
                          key: _form,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                20, deviceHeight(context) * 0.05, 20, 0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                reusableTextField(
                                    S.of(context).enter_username,
                                    Icons.person_outline,
                                    false,
                                    _usernameTextController,
                                    '',
                                    context,
                                    false),
                                SizedBox(
                                  height: 5,
                                ),
                                reusableTextField(
                                    S.of(context).enter_email,
                                    Icons.mail,
                                    false,
                                    _emailTextController,
                                    '',
                                    context,
                                    true),
                                SizedBox(
                                  height: 5,
                                ),
                                reusableTextField(
                                    S.of(context).enter_password,
                                    Icons.lock_outline,
                                    true,
                                    _passwordTextController,
                                    '',
                                    context,
                                    false),
                                SizedBox(
                                  height: 5,
                                ),
                                reusableTextField(
                                    S.of(context).confirm_password,
                                    Icons.lock_outline,
                                    true,
                                    _retypepasswordTextController,
                                    _passwordTextController.text,
                                    context,
                                    false),
                                SizedBox(
                                  height: 5,
                                ),
                                reusableButton(context, S.of(context).sign_up,
                                    () {
                                  if (_form.currentState!.validate()) {
                                    FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _emailTextController.text,
                                            password:
                                                _passwordTextController.text)
                                        .then((value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyHomePage(
                                                  title: 'Mokamayu')));
                                    }).onError((error, stackTrace) {
                                      print("Error ${error.toString()}");
                                    });
                                  }
                                })
                              ],
                            ),
                          ))
                    ])))));
  }
}
