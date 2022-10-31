import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/photo_grid/photo_box.dart';
import 'package:mokamayu/services/database/database_service.dart';
import '../../res/custom_colors.dart';
import '../reusable_snackbar.dart';

class PhotoGrid extends StatelessWidget {
  const PhotoGrid(
      {Key? key, required this.stream, this.scrollVertically = true})
      : super(key: key);

  final Stream<QuerySnapshot> stream;
  final bool scrollVertically;

  Axis getScrollDirection() =>
      scrollVertically ? Axis.vertical : Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService.readClothes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          CustomSnackBar.showErrorSnackBar(context);
        } else if (snapshot.hasData || snapshot.data != null) {
          return GridView.builder(
            scrollDirection: getScrollDirection(),
            itemCount: snapshot.data!.docs.length,
          return Center(
              child: GridView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var clothesInfo = snapshot.data!.docs[index];
              return PhotoCard(object: clothesInfo);
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              var clothesInfo = snapshot.data!.docs[index];
              String docID = snapshot.data!.docs[index].id;
              String name = clothesInfo['name'];
              String photoURL = clothesInfo['photoURL'];
              return PhotoBox(docID, photoURL, context);
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
