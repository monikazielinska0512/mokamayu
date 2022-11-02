import 'package:flutter/material.dart';
import 'package:mokamayu/generated/l10n.dart';
import 'package:mokamayu/screens/home/home_screen.dart';
import 'package:mokamayu/screens/authenticate/register_screen.dart';
import 'package:mokamayu/screens/authenticate/reset_password_screen.dart';
import 'package:mokamayu/widgets/fields/reusable_text_field.dart';
import 'package:mokamayu/widgets/buttons/reusable_button.dart';
import 'package:mokamayu/services/auth.dart';
import 'package:mokamayu/services/auth_exception_handler.dart';

import '../../models/user/login_user.dart';
import '../../widgets/reusable_snackbar.dart';
import '../../utils/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailtextController = TextEditingController();

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 244, 232, 217),
        body: SizedBox(
            width: deviceWidth(context),
            height: deviceHeight(context),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, deviceHeight(context) * 0.05, 0, 0),
                    child: Column(children: <Widget>[
                      SizedBox(
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
                              right: 70,
                              child: Image.asset(
                                "assets/girl.png",
                                fit: BoxFit.fitWidth,
                                height: 210,
                              ),
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
                              const SizedBox(
                                height: 5,
                              ),
                              reusableTextField(
                                  S.of(context).enter_email,
                                  Icons.person_outline,
                                  false,
                                  _emailtextController,
                                  (value) => Validator.validateEmail(
                                      _emailtextController.text, context)),
                              const SizedBox(
                                height: 20,
                              ),
                              reusableTextField(
                                  S.of(context).enter_password,
                                  Icons.lock_outline,
                                  true,
                                  _passwordTextController,
                                  (value) => Validator.validatePassword(
                                      _passwordTextController.text, context)),
                              forgottenPassword(context),
                              reusableButton(context,
                                  title: S.of(context).sign_in,
                                  onTap: () async {
                                if (_form.currentState!.validate()) {
                                  final status =
                                      await _auth.signInEmailPassword(LoginUser(
                                          email: _emailtextController.text,
                                          password:
                                              _passwordTextController.text));
                                  if (status == AuthStatus.successful) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyHomePage(
                                                    title: 'Mokamayu')));
                                  } else {
                                    final error = AuthExceptionHandler
                                        .generateErrorMessage(status, context);
                                    CustomSnackBar.showErrorSnackBar(
                                      context,
                                      message: error,
                                    );
                                  }
                                }
                              }),
                              signUpOption(),
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegisterScreen()));
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
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ResetPassword())),
    ),
  );
}
