import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/constants/text_styles.dart';
import 'package:mokamayu/services/photo_tapped.dart';
import 'package:mokamayu/widgets/drag_target_container.dart';
import 'package:provider/provider.dart';

import '../../models/wardrobe/clothes.dart';

class PhotoCard extends StatelessWidget {
  final Clothes object;
  final bool scrollVertically;

  PhotoCard({Key? key, required this.object, required this.scrollVertically})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? photoUrl = object.photoURL;
    String? name = object.name;
    return !scrollVertically
        ? GestureDetector(
            onTap: () async {
              Provider.of<PhotoTapped>(context, listen: false).setId(photoUrl!);
            },
            child: Card(
              elevation: 4,
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
                        size: scrollVertically
                            ? const Size.fromRadius(100)
                            : const Size.fromRadius(60), // Image radius

                        child: Image.network(photoUrl!, fit: BoxFit.fill),
                      ),
                    )),
              ]),
            ),
          )
        : Card(
            elevation: 4,
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
                      size: scrollVertically
                          ? const Size.fromRadius(100)
                          : const Size.fromRadius(60), // Image radius

                      child: Image.network(photoUrl!, fit: BoxFit.fill),
                    ),
                  )),
              Text(name!, style: TextStyles.paragraphRegularSemiBold14()),
            ]),
          );
  }
}
