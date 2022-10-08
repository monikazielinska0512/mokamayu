import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, MediaQuery.of(context).size.height * 0.05, 0, 0),
                    child: Stack(
                      children: <Widget>[
                        // Image.asset(
                        //   "assets/mountains.png",
                        //   fit: BoxFit.fitWidth,
                        // )
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
                        ),
                        // Image.asset(
                        //   "assets/girl.png",
                        //   fit: BoxFit.fitWidth,
                        //   height: 200,
                        // ),
                        //loginWidget("assets/mountains.png"),
                        //loginWidget("assets/girl.png", 240)
                      ],
                    )))));
  }
}

Image loginWidget(String path, double height) {
  return Image.asset(
    path,
    fit: BoxFit.fitWidth,
    //width: 240,
    height: height,
    //color: Colors.white,
  );
}
