import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/widgets/widgets.dart';
import '../../generated/l10n.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({super.key});
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
    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(top: deviceHeight(context) * 0.1),
          child: Text(
            "m  o  k  a  m  a  y  u",
            style: TextStyles.paragraphRegular16(ColorsConstants.darkBrick),
            textAlign: TextAlign.center,
          )),
      Padding(
          padding:
              EdgeInsets.only(top: deviceHeight(context) * 0.05, bottom: 20),
          child: Text(
            S.of(context).initial_title,
            style: TextStyles.h3(),
            textAlign: TextAlign.center,
          )),
      ButtonDarker(context, S.of(context).get_started, () {
        GoRouter.of(context).push('/login');
      }, shouldExpand: false),
      Stack(children: [
        SizedBox(
          height: deviceHeight(context) * 0.613,
          width: deviceWidth(context),
          child: Image.asset(
            "assets/images/mountaints-tall.png",
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
            bottom: 20,
            left: 80,
            child: SizedBox(
                width: deviceWidth(context) * 0.7,
                child: Image.asset(
                  "assets/images/woman3.png",
                  width: deviceWidth(context),
                  fit: BoxFit.fitWidth,
                ))),
      ]),
    ]);
  }
}
