import 'package:flutter/material.dart';
import 'package:mokamayu/services/auth.dart';
import '../../models/wardrobe/clothes.dart';
import '../../screens/wardrobe/form/edit_clothes_form.dart';
import '../../services/database/database_service.dart';

GestureDetector PhotoBox(String id, String photoUrl, BuildContext context) {
  return GestureDetector(
      onTap: () async {
        final ref = database.collection("users").doc(AuthService().getCurrentUserUID())
            .collection("clothes").doc(id)
            .withConverter(
          fromFirestore: Clothes.fromFirestore,
          toFirestore: (Clothes city, _) => city.toFirestore(),
        );
        final docSnap = await ref.get();
        final city = docSnap.data(); // Convert to City object
        if (city != null) {
          print(city.toFirestore().toString());
        } else {
          print("No such document.");
        }

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => (EditClothesForm(clothes: city, clothesID: id,))));
      },
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(
              maxWidth: 300,
              maxHeight: 400,
            ),
            child: Image.network(photoUrl, fit: BoxFit.fill),
          ),
        )));
}
