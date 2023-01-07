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

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<UserData> userList = [];
  List<UserData> _foundUsers = [];

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    Provider.of<UserListManager>(context, listen: false).readUserOnce()
      .then((List<UserData> temp){
        temp.removeWhere((element) => element.uid == AuthService().getCurrentUserID());
        setState(() => userList = temp);
        setState(() => _foundUsers = userList );
      });
  }

  void _runFilter(String enteredKeyword) {
    List<UserData> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = userList;
    } else {
      results = userList
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
      _foundUsers = results;
    });
  }


  @override
  Widget build(BuildContext context) {
    return BasicScreen(
      context: context,
      type: 'find-users',
      body: Stack(
        children: [
          Column(
            children: [
              Column(children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.07,

                    child: TextField(
                        onChanged: (value) => _runFilter(value),
                        decoration: const InputDecoration(
                          hintText: "Find user",
                        ))
                ),
                const SizedBox(height: 15),
              ]),
              Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: Text("Found ${_foundUsers.length} results")
              ),
              Expanded(
                child: _foundUsers.isNotEmpty
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
      itemCount: _foundUsers.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              context.pushNamed(
                "profile",
                queryParams: {
                  'uid': _foundUsers[index].uid,
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
                          child: _foundUsers[index].profilePicture != null
                              ? Image.network(_foundUsers[index].profilePicture!,
                              fit: BoxFit.fill)
                              : Image.asset(Assets.avatarPlaceholder,
                              fit: BoxFit.fill),
                        ),
                      ),
                      _foundUsers[index].profileName != null
                          ? Text(_foundUsers[index].profileName!, style: TextStyles.paragraphRegularSemiBold18(Colors.black),)
                          : Text("@${_foundUsers[index].username}", style: TextStyles.paragraphRegularSemiBold18(Colors.black)),
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
        Text(
          "It seems user with such \n name doesn't exist",
          style: TextStyles.paragraphRegularSemiBold20(ColorsConstants.grey),
          textAlign: TextAlign.center,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6,
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



