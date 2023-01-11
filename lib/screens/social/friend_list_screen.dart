import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/constants/text_styles.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/buttons/predefined_buttons.dart';
import 'package:mokamayu/widgets/fields/search_text_field.dart';
import 'package:mokamayu/widgets/fundamental/empty_screen.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:mokamayu/constants/assets.dart';

import '../../generated/l10n.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<UserData> friendList = [];
  List<UserData> _foundFriends = [];
  late UserData currentUser;
  bool searching = false;

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileManager>(context, listen: false)
        .getCurrentUserData()
        .then((UserData? temp) {
      setState(() => currentUser = temp!);
      Provider.of<FriendsManager>(context, listen: false)
          .readFriendsOnce(currentUser)
          .then((List<UserData> temp) {
        setState(() => friendList = temp);
        setState(() => _foundFriends = friendList);
      });
    });
  }

  void _runFilter(String enteredKeyword) {
    List<UserData> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = friendList;
    } else {
      results = friendList
          .where((user) => user.profileName != null
              ? user.username
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()) ||
                  user.email
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()) ||
                  user.profileName!
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase())
              : user.username
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()) ||
                  user.email
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Refresh the UI
    setState(() {
      _foundFriends = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
      context: context,
      title: 'friends',
      leftButton: BackArrowButton(context),
      isFullScreen: false,
      rightButton: null,
      body: Column(
        children: [
          TextField(
              onChanged: (value) {
                _runFilter(value);
                value.isNotEmpty ? searching = true : searching = false;
              },
              decoration: SearchBarStyle(S.of(context).search_friend)),
          Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5, left: 2),
                  child: searching
                      ? Text(
                          "${S.of(context).found} ${_foundFriends.length} ${S.of(context).results}",
                          style: TextStyles.paragraphRegularSemiBold14(
                              Colors.grey))
                      : Text(S.of(context).all_friends,
                          style: TextStyles.paragraphRegularSemiBold14(
                              Colors.grey)))),
          _foundFriends.isNotEmpty
              ? buildList()
              : EmptyScreen(
                  context,
              searching
                      ? Text(
                          S.of(context).no_found_friends,
                          style: TextStyles.paragraphRegular14(Colors.grey),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          S.of(context).no_friends,
                          style: TextStyles.paragraphRegular14(Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                  ColorsConstants.sunflower)
        ],
      ),
    );
  }

  Widget buildList() {
    return Expanded(
        child: ListView.separated(
      padding: const EdgeInsets.all(3),
      itemCount: _foundFriends.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              context.pushNamed(
                "profile",
                queryParams: {
                  'uid': _foundFriends[index].uid,
                },
              );
            },
            child: Container(
                height: MediaQuery.of(context).size.height * 0.12,
                decoration: BoxDecoration(
                    color: ColorsConstants.peachy.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        // Image border
                        child: SizedBox.fromSize(
                          size: Size.square(
                              MediaQuery.of(context).size.height * 0.1),
                          child: _foundFriends[index].profilePicture != null
                              ? Image.network(
                                  _foundFriends[index].profilePicture!,
                                  fit: BoxFit.fill)
                              : Image.asset(Assets.avatarPlaceholder,
                                  fit: BoxFit.fill),
                        )),
                  ),
                  _foundFriends[index].profileName != null
                      ? Text(
                          _foundFriends[index].profileName!.toCapitalized(),
                          style: TextStyles.paragraphRegularSemiBold18(
                              Colors.black),
                        )
                      : Text(
                          "@${_foundFriends[index].username.toCapitalized()}",
                          style: TextStyles.paragraphRegularSemiBold18(
                              Colors.black)),
                ])));
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    ));
  }
}
