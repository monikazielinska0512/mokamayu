import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/res/colors.dart';
import 'package:mokamayu/res/text_styles.dart';

class PhotoCard extends StatelessWidget {
  QueryDocumentSnapshot<Object?> object;

  PhotoCard({Key? key, required this.object}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: CustomColors.soft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15), // Image border
              child: SizedBox.fromSize(
                size: const Size.fromRadius(120), // Image radius
                child: Image.network(object['photoURL'], fit: BoxFit.fill),
              ),
            )),
        Text(object['name'], style: TextStyles.paragraphRegularSemiBold14()),
      ]),
    );
  }
}
