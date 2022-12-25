import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/generated/l10n.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../constants/text_styles.dart';
import '../../utils/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
      type: "Sign in",
      leftButtonType: "back",
      isRightButtonVisible: false,
      context: context,
      isFullScreen: true,
      body: Stack(children: [
        Stack(children: [
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/images/background_auth.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.54,
            width: MediaQuery.of(context).size.width * 0.4,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Image.asset(
              "assets/images/man.png",
              fit: BoxFit.fitWidth,
            ),
          )
        ]),
        Positioned(
          bottom: 0,
          child: BackgroundCard(
            context: context,
            height: 0.54,
            child: buildLoginForm(context),
          ),
        ),
      ]),
    );
  }

  Widget buildLoginForm(BuildContext context) {
    return Form(
      key: _form,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, deviceHeight(context) * 0.05, 20, 0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
                S.of(context).enter_email,
                Icons.person_outline,
                false,
                _emailTextController,
                (value) => Validator.validateEmail(
                    _emailTextController.text, context)),
            const SizedBox(
              height: 30,
            ),
            CustomTextField(
                S.of(context).enter_password,
                Icons.lock_outline,
                true,
                _passwordTextController,
                (value) => Validator.validatePassword(
                    _passwordTextController.text, context)),
            forgottenPassword(context),
            const SizedBox(
              height: 30,
            ),
            ButtonDarker(context, S.of(context).sign_in, () async {
              if (_form.currentState!.validate()) {
                final status = await _auth.signInEmailPassword(LoginUser(
                    email: _emailTextController.text,
                    password: _passwordTextController.text));
                if (mounted && status == AuthStatus.successful) {
                  Provider.of<AppStateManager>(context, listen: false).login();
                } else {
                  final error = AuthExceptionHandler.generateErrorMessage(
                      status, context);
                  CustomSnackBar.showErrorSnackBar(
                    context: context,
                    message: error,
                  );
                }
              }
            }),
            signUpOption(context),
          ],
        ),
      ),
    );
  }

  Row signUpOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).no_account,
            style: TextStyles.paragraphRegular14(Colors.grey)),
        // const TextStyle(color: Colors.grey)),
        GestureDetector(
          onTap: () {
            GoRouter.of(context).push('/register');
          },
          child: Text(
            S.of(context).sign_up,
            style: TextStyle(
                color: ColorsConstants.red, fontWeight: FontWeight.bold),
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
          style: TextStyles.paragraphRegularSemiBold14(ColorsConstants.red),
          textAlign: TextAlign.right,
        ),
        onPressed: () => GoRouter.of(context).push('/reset-password')),
  );
}
