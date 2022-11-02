import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/reusable_widgets/photo_grid/photo_box.dart';
import 'package:mokamayu/services/database/database_service.dart';
import '../../res/custom_colors.dart';
import '../reusable_snackbar.dart';

class PhotoGrid extends StatefulWidget {
  PhotoGrid({Key? key}) : super(key: key);

  @override
  _PhotoGridState createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
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
              childAspectRatio: 2.0,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2,
              mainAxisExtent: 300,
            ),
          ));
        }
        return const Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            CustomColors.primary,
          ),
        ));
      },
    );
  }
}
