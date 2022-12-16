import 'package:flutter/material.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/utils/validator.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../services/services.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Future<UserData?>? userData;
  TextEditingController profileNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isProfilePrivate = false;

  // TextEditingController birthdayDate = TextEditingController();

  @override
  void initState() {
    userData = Provider.of<ProfileManager>(context, listen: false)
        .getCurrentUserData();
    userData?.then((data) {
      profileNameController.text = data?.profileName ?? ' ';
      usernameController.text = data?.username ?? ' ';
      emailController.text = data?.email ?? ' ';
      isProfilePrivate = data?.privateProfile ?? false;
    });
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
        const BackgroundImage(
            imagePath: "assets/images/mountains.png", imageShift: 180),
        Consumer<ProfileManager>(
            builder: (_, bar, __) => (FutureBuilder<UserData?>(
                future: userData,
                builder: (context, snapshot) {
                  return Positioned(
                    bottom: 0,
                    child: BackgroundCard(
                      context: context,
                      height: 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          children: [
                            buildPhotoRow(snapshot.data?.profilePicture),
                            buildRow(
                                'Profile name',
                                snapshot.data?.profileName ?? '',
                                profileNameController,
                                Provider.of<ProfileManager>(context,
                                        listen: false)
                                    .updateProfileName),
                            buildRow(
                                'Username',
                                snapshot.data?.username ?? '',
                                usernameController,
                                Provider.of<ProfileManager>(context,
                                        listen: false)
                                    .updateUsername),
                            buildRow(
                                'Email',
                                snapshot.data?.email ?? '',
                                emailController,
                                Provider.of<ProfileManager>(context,
                                        listen: false)
                                    .updateEmail,
                                isEmail: true),
                            buildPrivacySwitch(),
                            // buildRow('Birthday date',
                            //     snapshot.data?.birthdayDate.toString() ?? '', ),
                          ],
                        ),
                      ),
                    ),
                  );
                }))),
      ]),
    );
  }

  Widget buildPhotoRow(String? profilePicture) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox.fromSize(
            size: const Size.square(120),
            child: profilePicture != null
                ? Image.network(profilePicture, fit: BoxFit.fill)
                : Image.asset(Assets.avatarPlaceholder, fit: BoxFit.fill),
          ),
        ),
        ImagePickerButton(
            canRemoveImage: profilePicture != null,
            onUpdate: (String? photoPath) {
              Provider.of<ProfileManager>(context, listen: false)
                  .updateProfilePicture(photoPath);
            })
      ],
    );
  }

  Widget buildRow(String label, String value, TextEditingController controller,
      Function update,
      {bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  TextStyles.paragraphRegularSemiBold18(ColorsConstants.grey)),
          SizedBox(
            width: 150,
            child: EditableText(
              textAlign: TextAlign.end,
              controller: controller,
              focusNode: FocusNode(debugLabel: value),
              style: TextStyles.paragraphRegular18(ColorsConstants.blackAccent),
              cursorColor: Colors.black,
              backgroundCursorColor: Colors.black,
              onSubmitted: (String newValue) => handleInputValueUpdate(
                  newValue, value, controller, update, isEmail),
            ),
          )
        ],
      ),
    );
  }

  void handleInputValueUpdate(String newValue, String previousValue,
      TextEditingController controller, Function update, bool isEmail) {
    var validatorOutput = Validator.checkIfEmptyField(newValue, context);
    if (isEmail) {
      validatorOutput = Validator.validateEmail(newValue, context);
    }
    if (validatorOutput == null) {
      update(newValue);
    } else {
      CustomSnackBar.showErrorSnackBar(context, message: validatorOutput);
      controller.text = previousValue;
    }
  }

  Widget buildPrivacySwitch() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("Private profile",
          style: TextStyles.paragraphRegularSemiBold18(ColorsConstants.grey)),
      Switch(
        value: isProfilePrivate,
        activeColor: ColorsConstants.darkBrick,
        onChanged: (bool value) {
          setState(() {
            isProfilePrivate = !isProfilePrivate;
            Provider.of<ProfileManager>(context, listen: false)
                .updatePrivacy(isProfilePrivate);
          });
        },
      ),
    ]);
  }
}
