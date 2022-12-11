import 'package:flutter/material.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Future<UserData?>? userData;

  @override
  void initState() {
    userData =
        Provider.of<ProfileManager>(context, listen: false).getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
      type: "My profile",
      leftButtonType: "back",
      context: context,
      isFullScreen: true,
      body: Stack(children: [
        // buildBackgroundImage(),
        const BackgroundImage(
            imagePath: "assets/images/mountains.png", imageShift: 180),
        Positioned(
          bottom: 0,
          child: BackgroundCard(
            context: context,
            height: 0.8,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.square(120),
                          child: Image.asset(Assets.avatarPlaceholder,
                              fit: BoxFit.fill),
                        ),
                      ),
                      TextButton(
                        onPressed: () => {
                          // TODO
                        },
                        child: Text(
                          'Change photo',
                          style: TextStyles.paragraphRegularSemiBold16(),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
