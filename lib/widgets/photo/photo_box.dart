import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/managers/photo_tapped_manager.dart';
import 'package:provider/provider.dart';
import 'package:extended_image/extended_image.dart';

class PhotoBox extends StatelessWidget {
  final WardrobeItem? object;
  final bool? scrollVertically;

  const PhotoBox({Key? key, this.object, required this.scrollVertically})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? photoURL = object!.photoURL;
    String? name = object!.name;
    String? id = object!.reference;
    return !scrollVertically!
        ? buildPhotoBoxForOutfits(context, photoURL, id)
        : buildPhotoBoxForWardrobe(photoURL, name, context);
  }

  Widget buildPhotoBoxForWardrobe(
      String? photoURL, String name, BuildContext context) {
    return GestureDetector(
        child: Wrap(runSpacing: 5, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // Image border
            child: SizedBox.fromSize(
                size: const Size.fromRadius(100),
                child: ExtendedImage.network(
                  photoURL!,
                  fit: BoxFit.fill,
                  cacheWidth: 100 * window.devicePixelRatio.ceil(),
                  cacheHeight: 140 * window.devicePixelRatio.ceil(),
                  cache: true,
                  enableMemoryCache: false,
                  enableLoadState: true,
                )),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child:
                  Text(name, style: TextStyles.paragraphRegularSemiBold14())),
        ]),
        onTap: () => {context.pushNamed('wardrobe-item', extra: object)});
  }

  Widget buildPhotoBoxForOutfits(
      BuildContext context, String? photoURL, String? id) {
    return GestureDetector(
      onTap: () async {
        Provider.of<PhotoTapped>(context, listen: false)
            .addToMap(photoURL!, id!.toString());
      },
      child: Card(
        elevation: 0,
        color: ColorsConstants.mint.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // Image border
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(40), // Image radius
                  child: Image.network(photoURL!, fit: BoxFit.fill),
                ),
              )),
        ]),
      ),
    );
  }
}
