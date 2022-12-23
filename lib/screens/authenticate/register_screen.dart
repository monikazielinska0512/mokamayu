import 'package:flutter/material.dart';
import 'package:mokamayu/generated/l10n.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/utils/validator.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

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
    return BasicScreen(
      type: "Sign up",
      leftButtonType: "back",
      isRightButtonVisible: false,
      context: context,
      isFullScreen: true,
      body: Stack(children: [
        Stack(children: [
          Positioned(
            bottom: MediaQuery.of(context).size.height - 448,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/images/background_auth.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height - 412,
            width: MediaQuery.of(context).size.width - 250,
            right: MediaQuery.of(context).size.width - 240,
            child: Image.asset(
              "assets/images/woman2.png",
              fit: BoxFit.fitWidth,
            ),
          )
        ]),
        Positioned(
          bottom: 0,
          child: BackgroundCard(
            context: context,
            height: 0.54,
            child: buildRegistrationForm(context),
          ),
        ),
      ]),
    );
  }

  Widget buildRegistrationForm(BuildContext context) {
    return Form(
        key: _form,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, deviceHeight(context) * 0.05, 20, 0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                  S.of(context).enter_username,
                  Icons.person_outline,
                  false,
                  _usernameTextController,
                  (value) => Validator.checkIfEmptyField(
                      _usernameTextController.text, context)),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                  S.of(context).enter_email,
                  Icons.mail,
                  false,
                  _emailTextController,
                  (value) => Validator.validateEmail(
                      _emailTextController.text, context)),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                  S.of(context).enter_password,
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                  (value) => Validator.validatePassword(
                      _passwordTextController.text, context)),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                  S.of(context).confirm_password,
                  Icons.lock_outline,
                  true,
                  _retypepasswordTextController,
                  (value) => Validator.checkIfPasswordsIdentical(
                      _retypepasswordTextController.text,
                      _passwordTextController.text,
                      context)),
              const SizedBox(
                height: 15,
              ),
              ButtonDarker(context, S.of(context).sign_up, () async {
                if (_form.currentState!.validate()) {
                  final status = await _auth.register(LoginUser(
                      email: _emailTextController.text,
                      password: _passwordTextController.text));
                  if (mounted && status == AuthStatus.successful) {
                    Provider.of<ProfileManager>(context, listen: false)
                        .createUser(
                            _emailTextController.text,
                            _usernameTextController.text,
                            _auth.getCurrentUserID());
                    Navigator.pop(context);
                    Provider.of<AppStateManager>(context, listen: false)
                        .login();
                  } else {
                    final error = AuthExceptionHandler.generateErrorMessage(
                        status, context);
                    CustomSnackBar.showErrorSnackBar(
                      context: context,
                      message: error,
                    );
                  }
                }
              })
            ],
          ),
        ));
  }
}
