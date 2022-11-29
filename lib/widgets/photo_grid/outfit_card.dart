import 'package:flutter/material.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/widgets/photo_grid/photo_tapped.dart';
import 'package:provider/provider.dart';

class OutfitCard extends StatelessWidget {
  final WardrobeItem object;

  OutfitCard({Key? key, required this.object}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? photoUrl = object.photoURL;
    String? name = object.name;
    String? id = object.reference;
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 4,
      color: ColorsConstants.soft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15), // Image border
              child: SizedBox.fromSize(
                size: const Size.fromRadius(100),
                child: Image.network(photoUrl!, fit: BoxFit.fill),
              ),
            )),
        Text(name!, style: TextStyles.paragraphRegularSemiBold14()),
      ]),
    );
  }
}
