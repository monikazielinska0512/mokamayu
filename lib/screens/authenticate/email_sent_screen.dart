import 'package:flutter/material.dart';
import 'package:mokamayu/constants/constants.dart';
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
        type: "",
        leftButtonType: null,
        isLeftButtonVisible: false,
        isRightButtonVisible: false,
        context: context,
        isFullScreen: true,
        body: buildBody(context));
  }

  Widget buildBody(context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: deviceHeight(context) * 0.2),
            child: Container(
              child: Image.asset(
                "assets/images/woman-email.png",
                width: deviceWidth(context) * 0.8,
                fit: BoxFit.fitWidth,
              ),
            )),
        Text("The email has been sent", style: TextStyles.h4()),
        Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
            child: Text(
              "Email for reset password has been sent, please check your email.",
              style: TextStyles.paragraphRegular16(Colors.grey),
              textAlign: TextAlign.center,
            )),
        ButtonDarker(context, "Back", () {
          Navigator.of(context).pop();
        })
      ],
    );
  }
}
