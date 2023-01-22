import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/generated/l10n.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:mokamayu/services/services.dart';
import '../../utils/validator.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailTextController = TextEditingController();

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
        title: S.of(context).reset_password,
        leftButton: BackArrowButton(context),
        rightButton: null,
        context: context,
        isFullScreen: true,
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return Column(children: <Widget>[
      Form(
          key: _form,
          child: Padding(
              padding:
                  EdgeInsets.fromLTRB(20, deviceHeight(context) * 0.2, 20, 0),
              child: Column(children: <Widget>[
                CustomTextField(
                    S.of(context).enter_email,
                    Icons.mail,
                    false,
                    _emailTextController,
                    (value) => Validator.validateEmail(
                        _emailTextController.text, context)),
                const SizedBox(
                  height: 20,
                ),
                ButtonDarker(context, S.of(context).reset_password, () async {
                  if (_form.currentState!.validate()) {
                    dynamic result =
                        await _auth.resetPassword(_emailTextController.text);
                    if (mounted && result != AuthStatus.successful) {
                      final error = AuthExceptionHandler.generateErrorMessage(
                          result, context);
                      CustomSnackBar.showErrorSnackBar(
                        context: context,
                        message: error,
                      );
                    } else {
                      Navigator.of(context).pop();
                      GoRouter.of(context).push('/email-sent');
                    }
                  }
                })
              ]))),
      Expanded(child: SizedBox(
          height: deviceWidth(context) * 1.295,
          child: Opacity(
            opacity: 0.9,
            child: Image.asset(
              "assets/images/navigationAsset.png",
              width: deviceWidth(context),
              fit: BoxFit.fitWidth,
            ),
          )))
    ]);
  }
}
