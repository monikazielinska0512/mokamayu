import 'package:flutter/material.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';

class PostList extends StatefulWidget {
  final List<Post> postList;
  final List<UserData> userList;

  const PostList({
    Key? key,
    required this.postList,
    required this.userList,
  }) : super(key: key);


  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return
      // widget.postList.isNotEmpty
      // ? buildFeed()
      // :
      buildEmpty();
  }


  // Widget buildFeed(){
  //   return ListView.separated(
  //       itemBuilder: (BuildContext context, int index) {
  //         return Container(
  //           width: MediaQuery.of(context).size.width * 0.45,
  //           decoration: BoxDecoration(
  //             color: ColorsConstants.whiteAccent,
  //             borderRadius: BorderRadius.circular(20)
  //           ),
  //           padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
  //           child: GestureDetector(
  //             onTap: () {},
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisSize: MainAxisSize.max,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     ClipRRect(
  //                       borderRadius: BorderRadius.circular(5), // Image border
  //                       child: SizedBox.fromSize(
  //                         size: const Size.square(50),
  //                         child: widget.userList.singleWhere((element) => element.uid == widget.postList[index].createdBy).profilePicture != null
  //                             ? Image.network(widget.userList.singleWhere((element) => element.uid == widget.postList[index].createdBy).profilePicture!,
  //                             fit: BoxFit.fill)
  //                             : Image.asset(Assets.avatarPlaceholder,
  //                             width: MediaQuery.of(context).size.width * 0.7),
  //                       ),
  //                     ),
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(widget.userList.singleWhere((element) => element.uid == widget.postList[index].createdBy).profileName != null
  //                             ? widget.userList.singleWhere((element) => element.uid == widget.postList[index].createdBy).profileName!
  //                             : widget.userList.singleWhere((element) => element.uid == widget.postList[index].createdBy).username,
  //                             style: TextStyles.paragraphRegularSemiBold16()),
  //                         Text("Posted ${
  //                             DateFormat('dd/MM/yyyy HH:mm')
  //                                 .format(DateTime.fromMillisecondsSinceEpoch(widget.postList[index].creationDate))}",
  //                             style: TextStyles.paragraphRegular14(ColorsConstants.grey)
  //                         ),
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         Text(widget.postList[index].likes!.length.toString(), style: TextStyles.paragraphRegular14(ColorsConstants.grey)),
  //                         widget.userList.singleWhere((element) => element.uid == widget.postList[index].createdBy).uid != AuthService().getCurrentUserID()
  //                         ? widget.postList[index].likes!.contains(AuthService().getCurrentUserID())
  //                           ?IconButton(
  //                             onPressed: (){
  //                               widget.postList[index].likes!.remove(AuthService().getCurrentUserID());
  //                               Provider.of<PostManager>(context, listen: false).likePost(widget.postList[index].reference!, widget.postList[index].createdBy, widget.postList[index].likes!);
  //                               setState(() {});
  //                               },
  //                             icon: Icon(Icons.favorite, color: ColorsConstants.darkBrick,))
  //                           :IconButton(
  //                               onPressed: (){
  //                                 widget.postList[index].likes!.add(AuthService().getCurrentUserID());
  //                                 Provider.of<PostManager>(context, listen: false).likePost(widget.postList[index].reference!, widget.postList[index].createdBy, widget.postList[index].likes!);
  //                                 setState(() {});
  //                                 },
  //                               icon: Icon(Icons.favorite_border, color: ColorsConstants.darkBrick,))
  //                         : Icon(Icons.favorite_border, color: ColorsConstants.darkBrick,),
  //                       ],
  //                     ),
  //
  //                   ],
  //                 ),
  //                 Image.network(widget.postList[index].cover, fit: BoxFit.fill),
  //                 TextField(
  //                   controller: myController,
  //                   onSubmitted: (String comment){
  //                     print("add comment");
  //                     widget.postList[index].comments!.add({"author": AuthService().getCurrentUserID(), "content": comment});
  //                     Provider.of<PostManager>(context, listen: false).commentPost(widget.postList[index].reference!, widget.postList[index].createdBy, widget.postList[index].comments!);
  //                     myController.clear();
  //                     setState(() {});
  //                   },
  //                   decoration: const InputDecoration(
  //                     hintText: "Comment post",
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     suffixIcon: Icon(Icons.arrow_forward_ios_rounded, color: ColorsConstants.darkBrick,),
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.all(Radius.circular(14)),
  //                       borderSide: BorderSide(
  //                         width: 0,
  //                         style: BorderStyle.none,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 TextButton(onPressed: (){
  //                   Navigator.push(
  //                     context, MaterialPageRoute(builder:
  //                     (BuildContext context) => PostScreen(
  //                       post: widget.postList[index],
  //                       user: widget.userList.singleWhere((element) => element.uid == widget.postList[index].createdBy),
  //                       userList: widget.userList,
  //                     )));
  //                     },
  //                   child: Text(
  //                     " View all comments",
  //                     style: TextStyles.paragraphRegular12(ColorsConstants.darkBrick),
  //                   ),
  //                 )
  //           ],
  //             ),
  //           ),
  //         );
  //       },
  //       separatorBuilder: (BuildContext context, int index) => const Divider(),
  //       itemCount: widget.postList.length);
  // }

  Widget buildEmpty() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.07,
        ),
        Text(
          "Social feed is empty \n Add some friends",
          style: TextStyles.paragraphRegularSemiBold20(ColorsConstants.grey),
          textAlign: TextAlign.center,
        ),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.7,
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
