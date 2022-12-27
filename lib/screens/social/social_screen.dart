import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/widgets/fundamental/basic_page.dart';
import 'package:mokamayu/constants/assets.dart';
import 'package:mokamayu/widgets/widgets.dart';


class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  @override
  Widget build(BuildContext context) {
    return BasicScreen(
      type: 'social',
      leftButtonType: "dots",
      rightButtonType: "search-notif",
      context: context,
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return const FeedElement();
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemCount: 30),
          ),
        ],
      ),

    );
  }
}


class FeedElement extends StatelessWidget{
  const FeedElement({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20)
      ),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Image border
                  child: SizedBox.fromSize(
                    size: const Size.square(50),
                    child: Image.asset(Assets.avatarPlaceholder,
                        width: MediaQuery.of(context).size.width * 0.7),
                  ),
                ),
                Column(
                  children: [
                    Text('nick'),
                    Text('data')
                  ],
                ),
                Text('likes'),
              ],
            ),
            Image.asset(Assets.avatarPlaceholder, scale: 0.7),
            Text('comments')
          ],
        ),
      ),
    );
  }
}