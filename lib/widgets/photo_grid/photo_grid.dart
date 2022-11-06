import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/widgets/photo_grid/photo_box.dart';
import '../../constants/colors.dart';
import '../reusable_snackbar.dart';

class PhotoGrid extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final bool scrollVertically;

  PhotoGrid({Key? key, required this.stream, this.scrollVertically = true})
      : super(key: key);

  Axis getScrollDirection() =>
      scrollVertically ? Axis.vertical : Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          CustomSnackBar.showErrorSnackBar(context);
        } else if (snapshot.hasData || snapshot.data != null) {
          return Center(
              child: GridView.builder(
            scrollDirection: getScrollDirection(),
            shrinkWrap: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var clothesInfo = snapshot.data!.docs[index];
              return PhotoCard(
                  object: clothesInfo, scrollVertically: scrollVertically);
            },
            gridDelegate: scrollVertically
                ? const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.0,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2,
                    mainAxisExtent: 300,
                  )
                : const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.0,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2,
                    mainAxisExtent: 150,
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
