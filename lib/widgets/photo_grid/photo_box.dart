import 'package:flutter/material.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/widgets/photo_grid/photo_tapped.dart';
import 'package:provider/provider.dart';

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
              Provider.of<PhotoTapped>(context, listen: false)
                  .addToMap(photoUrl!);
            },
            child: Card(
              // semanticContainer: true,
              // clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 4,
              color: ColorsConstants.soft,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15), // Image border
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(40), // Image radius
                        child: Image.network(photoUrl!, fit: BoxFit.fill),
                      ),
                    )),
              ]),
            ),
          )
        : Card(
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
