import 'package:flutter/material.dart';

class BottomModal extends StatelessWidget {
  const BottomModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              'https://www.kindacode.com/wp-content/uploads/2021/01/blue.jpg',
            ),
          )),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Card(
              elevation: 10,
              color: Colors.white,
              child: Container(
                width: 300,
                height: 300,
                alignment: Alignment.center,
                child: const Text('www.kindacode.com',
                    style: TextStyle(fontSize: 24)),
              ),
            ),
          )),
    );
  }
}