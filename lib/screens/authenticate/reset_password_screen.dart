import 'package:flutter/material.dart';
import 'package:mokamayu/generated/l10n.dart';
import 'package:mokamayu/reusable_widgets/reusable_text_field.dart';
import 'package:mokamayu/reusable_widgets/reusable_button.dart';
import 'package:mokamayu/services/auth.dart';

import '../../reusable_widgets/reusable_snackbar.dart';
import '../../services/auth_exception_handler.dart';
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
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 244, 232, 217),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            S.of(context).reset_password,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            width: deviceWidth(context),
            height: deviceHeight(context),
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                    child: Column(children: <Widget>[
                      Form(
                          key: _form,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  20, deviceHeight(context) * 0.05, 20, 0),
                              child: Column(children: <Widget>[
                                reusableTextField(
                                    S.of(context).enter_email,
                                    Icons.mail,
                                    false,
                                    _emailTextController,
                                    (value) => Validator.validateEmail(
                                        _emailTextController.text, context)),
                                const SizedBox(
                                  height: 20,
                                ),
                                reusableButton(
                                    context,
                                    title: S.of(context).reset_password,
                                    onTap: () async {
                                  if (_form.currentState!.validate()) {
                                    dynamic result = await _auth.resetPassword(
                                        _emailTextController.text);
                                    if (result != AuthStatus.successful) {
                                      final error = AuthExceptionHandler
                                          .generateErrorMessage(
                                              result, context);
                                      CustomSnackBar.showErrorSnackBar(
                                        context,
                                        message: error,
                                      );
                                    } else {
                                      Navigator.of(context).pop();
                                    }
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
