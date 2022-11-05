import 'package:flutter/cupertino.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class PageTitle extends StatelessWidget {
  final String title;
  String? description;

  PageTitle({
    Key? key,
    required this.title,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Column(children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.appTitle()),
                const SizedBox(height: 5),
                Text(description ?? "",
                    style: TextStyles.paragraphRegular14(CustomColors.grey)),
              ])
        ]));
  }
}
