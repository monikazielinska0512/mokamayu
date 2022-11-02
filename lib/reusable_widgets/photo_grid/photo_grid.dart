import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/photo_grid/photo_box.dart';
import '../../res/custom_colors.dart';
import '../reusable_snackbar.dart';

class PhotoGrid extends StatelessWidget {
  const PhotoGrid(
      {Key? key, required this.stream, required this.flagHorizontal})
      : super(key: key);

  final Stream<QuerySnapshot> stream;
  final bool flagHorizontal;

  Axis checkIfHorizontal() {
    if (flagHorizontal) {
      return Axis.horizontal;
    }
    return Axis.vertical;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          CustomSnackBar.showErrorSnackBar(context);
        } else if (snapshot.hasData || snapshot.data != null) {
          return GridView.builder(
            scrollDirection: checkIfHorizontal(),
            itemCount: snapshot.data!.docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              var clothesInfo = snapshot.data!.docs[index];
              String docID = snapshot.data!.docs[index].id;
              String name = clothesInfo['name'];
              String photoUrl = clothesInfo['photo_url'];
              return PhotoBox(photoUrl);
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              CustomColors.firebaseOrange,
            ),
          ),
        );
      },
    );
  }
}
