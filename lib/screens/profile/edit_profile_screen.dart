import 'package:flutter/material.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/utils/validator.dart';
import 'package:mokamayu/widgets/buttons/predefined_buttons.dart';
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
      title: "Mój profil",
      leftButton: BackArrowButton(context),
      rightButton: null,
      context: context,
      isFullScreen: true,
      backgroundColor: Colors.white,
      body: Stack(children: [
        const BackgroundImage(
            imagePath: "assets/images/full_background.png",
            imageShift: 0,
            opacity: 0.4),
        Consumer<ProfileManager>(
            builder: (context, manager, _) => (FutureBuilder<UserData?>(
                future: userData,
                builder: (context, snapshot) {
                  return Padding(
                      padding: const EdgeInsets.only(
                          top: 120, bottom: 100, right: 15, left: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorsConstants.whiteAccent,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ColorsConstants.white),
                            child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    buildPhotoRow(
                                        snapshot.data?.profilePicture),

                                    Padding(
                                        padding: EdgeInsets.only(top: 0),
                                        child: Column(children: [
                                          buildRow(
                                              'Nazwa profilu',
                                              snapshot.data?.profileName ?? '',
                                              profileNameController,
                                              Provider.of<ProfileManager>(
                                                      context,
                                                      listen: false)
                                                  .updateProfileName),
                                          buildRow(
                                              'Nazwa użytkownika',
                                              snapshot.data?.username ?? '',
                                              usernameController,
                                              Provider.of<ProfileManager>(
                                                      context,
                                                      listen: false)
                                                  .updateUsername),
                                          buildRow(
                                              'E-mail',
                                              snapshot.data?.email ?? '',
                                              emailController,
                                              Provider.of<ProfileManager>(
                                                      context,
                                                      listen: false)
                                                  .updateEmail,
                                              isEmail: true)
                                        ])),
                                    buildPrivacySwitch(),

                                    // buildRow('Birthday date',
                                    //     snapshot.data?.birthdayDate.toString() ?? '', ),
                                  ],
                                )),
                          ),
                        ),
                      ));
                }))),
      ]),
    );
  }

  Widget buildPhotoRow(String? profilePicture) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox.fromSize(
            size: const Size.square(140),
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
        padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyles.paragraphRegularSemiBold18(
                      ColorsConstants.darkBrick)),
              SizedBox(
                width: double.maxFinite,
                height: 50,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    decoration: BoxDecoration(
                        color: ColorsConstants.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child: EditableText(
                      textAlign: TextAlign.start,
                      controller: controller,
                      focusNode: FocusNode(debugLabel: value),
                      style: TextStyles.paragraphRegular16(
                          ColorsConstants.blackAccent),
                      cursorColor: Colors.black,
                      backgroundCursorColor: Colors.black,
                      onSubmitted: (String newValue) => handleInputValueUpdate(
                          newValue, value, controller, update, isEmail),
                    )),
              )
            ],
          ),
        ));
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
      CustomSnackBar.showErrorSnackBar(
          message: validatorOutput, context: context);
      controller.text = previousValue;
    }
  }

  Widget buildPrivacySwitch() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("Profil prywatny",
          style:
              TextStyles.paragraphRegularSemiBold18(ColorsConstants.darkBrick)),
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
