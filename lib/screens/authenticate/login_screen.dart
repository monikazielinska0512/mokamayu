import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:mokamayu/generated/l10n.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:mokamayu/services/services.dart';

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
                                "assets/images/mountains.png",
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Positioned(
                              right: 70,
                              child: Image.asset(
                                "assets/images/girl.png",
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
                              CustomTextField(
                                  S.of(context).enter_email,
                                  Icons.person_outline,
                                  false,
                                  _emailtextController,
                                  (value) => Validator.validateEmail(
                                      _emailtextController.text, context)),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                  S.of(context).enter_password,
                                  Icons.lock_outline,
                                  true,
                                  _passwordTextController,
                                  (value) => Validator.validatePassword(
                                      _passwordTextController.text, context)),
                              forgottenPassword(context),
                              Button(context, S.of(context).sign_in,
                                  () async {
                                if (_form.currentState!.validate()) {
                                  final status =
                                      await _auth.signInEmailPassword(LoginUser(
                                          email: _emailtextController.text,
                                          password:
                                              _passwordTextController.text));
                                  if (status == AuthStatus.successful) {
                                    Provider.of<AppStateManager>(context,
                                            listen: false)
                                        .login();
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
                              signUpOption(context),
                            ],
                          ),
                        ),
                      ),
                    ])))));
  }

  Row signUpOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).no_account,
            style: const TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            GoRouter.of(context).push('/register');
          },
          child: Text(
            S.of(context).sign_up,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
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
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.right,
        ),
        onPressed: () => GoRouter.of(context).push('/reset-password')),
  );
}
