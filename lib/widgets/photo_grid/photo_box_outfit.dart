import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/models/outfit.dart';
import 'package:mokamayu/widgets/photo_grid/photo_tapped.dart';
import 'package:provider/provider.dart';

class PhotoCardOutfit extends StatelessWidget {
  final Outfit object;

  PhotoCardOutfit({Key? key, required this.object}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? photoUrl = object.cover;
    String? id = object.reference;
    print(id!);
    final List<int> codeUnits = photoUrl!.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);
    //print(unit8List);
    return GestureDetector(
      onTap: () async {},
      child: Card(
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
                    child: Text(id!)
                    // Image.memory(unit8List, fit: BoxFit.fill),
                    ),
              )),
        ]),
      ),
    );
  }
}
