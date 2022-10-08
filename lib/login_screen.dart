import 'package:flutter/material.dart';
import 'package:mokamayu/register_screen.dart';
import 'package:mokamayu/reusable_widgets/reusable_text_field.dart';
import 'package:mokamayu/reusable_widgets/reusable_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 222, 201, 174),
        body: Container(
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
                      Container(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20,
                              MediaQuery.of(context).size.height * 0.05, 20, 0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              reusableTextField(
                                  "Enter username",
                                  Icons.person_outline,
                                  false,
                                  _emailTextController),
                              SizedBox(
                                height: 20,
                              ),
                              reusableTextField(
                                  "Enter password",
                                  Icons.lock_outline,
                                  true,
                                  _passwordTextController),
                              SizedBox(
                                height: 20,
                              ),
                              reusableButton(context, "Log in", () {}),
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
        const Text("Don't have account?",
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
