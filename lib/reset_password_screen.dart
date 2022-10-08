import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/reusable_text_field.dart';
import 'package:mokamayu/reusable_widgets/reusable_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();

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
          title: const Text(
            "Reset Password",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            width: deviceWidth(context),
            height: deviceHeight(context),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                    child: Column(children: <Widget>[
                      Form(
                          key: _form,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  20, deviceHeight(context) * 0.05, 20, 0),
                              child: Column(children: <Widget>[
                                reusableTextField(
                                    "Enter Email address",
                                    Icons.mail,
                                    false,
                                    _emailTextController,
                                    ''),
                                const SizedBox(
                                  height: 20,
                                ),
                                reusableButton(context, "Reset Password", () {
                                  if (_form.currentState!.validate()) {
                                    FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: _emailTextController.text)
                                        .then((value) =>
                                            Navigator.of(context).pop());
                                  }
                                })
                              ]))),
                      Container(
                        width: deviceWidth(context),
                        child: Image.asset(
                          "assets/navigationAsset.png",
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    ])))));
  }
}
