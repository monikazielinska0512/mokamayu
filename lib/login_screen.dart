import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/generated/l10n.dart';
import 'package:mokamayu/home_screen.dart';
import 'package:mokamayu/register_screen.dart';
import 'package:mokamayu/reset_password_screen.dart';
import 'package:mokamayu/reusable_widgets/reusable_text_field.dart';
import 'package:mokamayu/reusable_widgets/reusable_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailextController = TextEditingController();

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 244, 232, 217),
        body: Container(
            width: deviceWidth(context),
            height: deviceHeight(context),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, deviceHeight(context) * 0.05, 0, 0),
                    child: Column(children: <Widget>[
                      Container(
                        height: deviceWidth(context),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child: Image.asset(
                                "assets/mountains.png",
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Positioned(
                              child: Image.asset(
                                "assets/girl.png",
                                fit: BoxFit.fitWidth,
                                height: 210,
                              ),
                              right: 70,
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
                                  S.of(context).enter_email,
                                  Icons.person_outline,
                                  false,
                                  _emailextController,
                                  '',
                                  context,
                                  true),
                              SizedBox(
                                height: 20,
                              ),
                              reusableTextField(
                                  S.of(context).enter_password,
                                  Icons.lock_outline,
                                  true,
                                  _passwordTextController,
                                  '',
                                  context,
                                  false),
                              forgottenPassword(context),
                              reusableButton(context, S.of(context).sign_in,
                                  () {
                                if (_form.currentState!.validate()) {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: _emailextController.text,
                                          password:
                                              _passwordTextController.text)
                                      .then((value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyHomePage(title: 'Mokamayu')));
                                  }).onError((error, stackTrace) {
                                    print("Error ${error.toString()}");
                                  });
                                }
                              }),
                              signUpOption()
                            ],
                          ),
                        ),
                      ),
                    ])))));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).no_account, style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterScreen()));
          },
          child: Text(
            S.of(context).sign_up,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

Widget forgottenPassword(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 35,
    alignment: Alignment.bottomRight,
    child: TextButton(
      child: Text(
        S.of(context).forgot_password,
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.right,
      ),
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => ResetPassword())),
    ),
  );
}
