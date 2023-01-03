import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/constants/text_styles.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/services.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:mokamayu/services/managers/managers.dart';
import 'package:mokamayu/constants/assets.dart';

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
    Provider.of<ProfileManager>(context, listen: false).getCurrentUserData()
        .then((UserData? temp){
    setState(() => currentUser = temp!);
    Provider.of<FriendsManager>(context, listen: false).readFriendsOnce(currentUser)
        .then((List<UserData> temp){
      setState(() => friendList = temp);
      setState(() => _foundFriends = friendList );
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
          .where((user) =>
      user.profileName != null
          ? user.username.toLowerCase().contains(enteredKeyword.toLowerCase())
          || user.email.toLowerCase().contains(enteredKeyword.toLowerCase())
          || user.profileName!.toLowerCase().contains(enteredKeyword.toLowerCase())
          : user.username.toLowerCase().contains(enteredKeyword.toLowerCase())
          || user.email.toLowerCase().contains(enteredKeyword.toLowerCase())
      )
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
      type: 'your friends',
      body: Stack(
        children: [
          Column(
            children: [
              Column(children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.07,

                    child: TextField(
                        onChanged: (value) {
                          _runFilter(value);
                          value.isNotEmpty
                              ? searching = true
                              : searching = false;
                        },
                        decoration: const InputDecoration(
                          hintText: "Find friend",
                        ))
                ),
                const SizedBox(height: 15),
              ]),
              Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: Text("Found ${_foundFriends.length} results")
              ),
              Expanded(
                child: _foundFriends.isNotEmpty
                    ? buildList()
                    : buildEmpty(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
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
                height: MediaQuery.of(context).size.height * 0.13,
                decoration: BoxDecoration(color: ColorsConstants.whiteAccent, borderRadius: BorderRadius.circular(14)),
                child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14), // Image border
                        child: SizedBox.fromSize(
                          size: Size.square(MediaQuery.of(context).size.height*0.1),
                          child: _foundFriends[index].profilePicture != null
                              ? Image.network(_foundFriends[index].profilePicture!,
                              fit: BoxFit.fill)
                              : Image.asset(Assets.avatarPlaceholder,
                              fit: BoxFit.fill),
                        ),
                      ),
                      _foundFriends[index].profileName != null
                          ? Text(_foundFriends[index].profileName!, style: TextStyles.paragraphRegularSemiBold18(Colors.black),)
                          : Text("@${_foundFriends[index].username}", style: TextStyles.paragraphRegularSemiBold18(Colors.black)),
                    ]
                )
            )
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget buildEmpty(){
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
        ),
        searching
            ? Text(
              "It seems user with such \n name isn't your friend",
              style: TextStyles.paragraphRegularSemiBold20(ColorsConstants.grey),
              textAlign: TextAlign.center,
            )
            : Text(
              "You don't have friends yet",
              style: TextStyles.paragraphRegularSemiBold20(ColorsConstants.grey),
              textAlign: TextAlign.center,
            ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/mountains.png"),
                fit: BoxFit.fitWidth,
                opacity: 0.5
            ),
          ),
        ),
      ],
    );
  }
}



