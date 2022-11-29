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
      elevation: 0,
      color: ColorsConstants.soft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15), // Image border
              child: SizedBox.fromSize(
                size: const Size.fromRadius(50),
                child: Image.network(photoUrl!, fit: BoxFit.fill),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Column(
              children: [
                Text(
                  name!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                    child: const Text(
                      "See details",
                      style: TextStyle(
                          color: ColorsConstants.primary,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    onPressed: () => {
                          //TODO
                        }),
              ],
            ),
            SizedBox(
              width: 50,
            ),
            Image.asset(
              "assets/images/trash.png",
              fit: BoxFit.fitWidth,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
