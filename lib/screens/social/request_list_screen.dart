import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/constants/text_styles.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:mokamayu/constants/assets.dart';

import '../../generated/l10n.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List<UserData> requestList = [];
  List<UserData> _foundRequests = [];
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
          .readRequestsOnce(currentUser)
          .then((List<UserData> temp) {
        setState(() => requestList = temp);
        setState(() => _foundRequests = requestList);
      });
    });
  }

  void _runFilter(String enteredKeyword) {
    List<UserData> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = requestList;
    } else {
      results = requestList
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

    setState(() {
      _foundRequests = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
      context: context,
      type: 'friend-requests',
      isFullScreen: false,
      isRightButtonVisible: false,
      body: Column(
        children: [
          TextField(
              onChanged: (value) {
                _runFilter(value);
                value.isNotEmpty ? searching = true : searching = false;
              },
              decoration: InputDecoration(
                  hintText: S.of(context).search_friend,
                  filled: true,
                  fillColor: ColorsConstants.whiteAccent,
                  labelStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: ColorsConstants.turquoise),
                  hintStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: ColorsConstants.turquoise),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorsConstants.whiteAccent, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorsConstants.whiteAccent, width: 0.0),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0))),
                  prefixIcon: const Icon(Icons.search,
                      color: ColorsConstants.darkBrick))),
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: _foundRequests.isNotEmpty
                      ? Text("Found ${_foundRequests.length} results")
                      : Container())),
          _foundRequests.isNotEmpty ? buildList() : buildEmpty(),
        ],
      ),
    );
  }

  Widget buildList() {
    return Expanded(
        child: ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _foundRequests.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              context.pushNamed(
                "profile",
                queryParams: {
                  'uid': _foundRequests[index].uid,
                },
              );
            },
            child: Container(
                height: MediaQuery.of(context).size.height * 0.13,
                decoration: BoxDecoration(
                    color: ColorsConstants.whiteAccent,
                    borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14), // Image border
                    child: SizedBox.fromSize(
                      size:
                          Size.square(MediaQuery.of(context).size.height * 0.1),
                      child: _foundRequests[index].profilePicture != null
                          ? Image.network(_foundRequests[index].profilePicture!,
                              fit: BoxFit.fill)
                          : Image.asset(Assets.avatarPlaceholder,
                              fit: BoxFit.fill),
                    ),
                  ),
                  _foundRequests[index].profileName != null
                      ? Text(
                          _foundRequests[index].profileName!,
                          style: TextStyles.paragraphRegularSemiBold18(
                              Colors.black),
                        )
                      : Text("@${_foundRequests[index].username}",
                          style: TextStyles.paragraphRegularSemiBold18(
                              Colors.black)),
                ])));
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    ));
  }

  Widget buildEmpty() {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
                color: ColorsConstants.mint.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const Icon(
                    Ionicons.sad_outline,
                    size: 25,
                    color: Colors.grey,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: searching
                          ? Text(
                              S.of(context).no_pending_invitation_user,
                              style: TextStyles.paragraphRegular14(
                                  ColorsConstants.grey),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              S.of(context).no_pending_invitation,
                              style: TextStyles.paragraphRegular14(
                                  ColorsConstants.grey),
                              textAlign: TextAlign.center,
                            ))
                ]))));
  }
}
