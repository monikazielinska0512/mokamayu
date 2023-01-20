import 'package:flutter/material.dart';
import 'package:mokamayu/constants/constants.dart';
import '../../generated/l10n.dart';
import '../../widgets/buttons/button_darker_orange.dart';
import '../../widgets/fundamental/basic_page.dart';

class EmailSentScreen extends StatelessWidget {
  const EmailSentScreen({super.key});
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
        rightButton: null,
        leftButton: null,
        context: context,
        isFullScreen: true,
        body: buildBody(context));
  }

  Widget buildBody(context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: deviceHeight(context) * 0.2),
            child: Image.asset(
              "assets/images/woman-email.png",
              width: deviceWidth(context) * 0.8,
              fit: BoxFit.fitWidth,
            )),
        Text(S.of(context).check_inbox, style: TextStyles.h4()),
        Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
            child: Text(
              S.of(context).email_sent,
              style: TextStyles.paragraphRegular16(Colors.grey),
              textAlign: TextAlign.center,
            )),
        ButtonDarker(context, S.of(context).back, () {
          Navigator.of(context).pop();
        })
      ],
    );
  }
}
