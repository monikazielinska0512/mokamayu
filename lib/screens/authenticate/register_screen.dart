import 'package:flutter/material.dart';
import 'package:mokamayu/generated/l10n.dart';
import 'package:mokamayu/screens/home/home_screen.dart';
import 'package:mokamayu/services/managers/clothes_provider.dart';
import 'package:mokamayu/utils/validator.dart';
import 'package:provider/provider.dart';

import '../../models/login_user.dart';
import '../../services/authentication/auth.dart';
import '../../services/authentication/auth_exception_handler.dart';
import '../../widgets/buttons/reusable_button.dart';
import '../../widgets/fields/reusable_text_field.dart';
import '../../widgets/reusable_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _retypepasswordTextController =
      TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 244, 232, 217),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            S.of(context).sign_up,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: SizedBox(
            width: deviceWidth(context),
            height: deviceHeight(context),
            child: SingleChildScrollView(
                child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, deviceHeight(context) * 0, 0, 0),
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
                              right: 20,
                              bottom: 6,
                              child: Image.asset(
                                "assets/images/woman.png",
                                fit: BoxFit.fitWidth,
                                height: 260,
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
                                    S.of(context).enter_username,
                                    Icons.person_outline,
                                    false,
                                    _usernameTextController,
                                    (value) => Validator.checkIfEmptyField(
                                        _usernameTextController.text, context)),
                                const SizedBox(
                                  height: 5,
                                ),
                                reusableTextField(
                                    S.of(context).enter_email,
                                    Icons.mail,
                                    false,
                                    _emailTextController,
                                    (value) => Validator.validateEmail(
                                        _emailTextController.text, context)),
                                const SizedBox(
                                  height: 5,
                                ),
                                reusableTextField(
                                    S.of(context).enter_password,
                                    Icons.lock_outline,
                                    true,
                                    _passwordTextController,
                                    (value) => Validator.validatePassword(
                                        _passwordTextController.text, context)),
                                const SizedBox(
                                  height: 5,
                                ),
                                reusableTextField(
                                    S.of(context).confirm_password,
                                    Icons.lock_outline,
                                    true,
                                    _retypepasswordTextController,
                                    (value) =>
                                        Validator.checkIfPasswordsIdentical(
                                            _retypepasswordTextController.text,
                                            _passwordTextController.text,
                                            context)),
                                const SizedBox(
                                  height: 5,
                                ),
                                reusableButton(context, S.of(context).sign_up,
                                    () async {
                                  if (_form.currentState!.validate()) {
                                    final status = await _auth.register(
                                        LoginUser(
                                            email: _emailTextController.text,
                                            password:
                                                _passwordTextController.text));
                                    if (status == AuthStatus.successful) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeNotifierProvider(
                                                    create: (_) =>
                                                        WardrobeManager(),
                                                    child: const MyHomePage(
                                                        title: 'Mokamayu'),
                                                  )));
                                    } else {
                                      final error = AuthExceptionHandler
                                          .generateErrorMessage(
                                              status, context);
                                      CustomSnackBar.showErrorSnackBar(
                                        context,
                                        message: error,
                                      );
                                    }
                                  }
                                })
                              ],
                            ),
                          ))
                    ])))));
  }
}
