import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mokamayu/widgets/fundamental/fundamentals.dart';
import 'authentication/auth.dart';

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;
  final String uid = AuthService().getCurrentUserID();

  Future<String> uploadFile(BuildContext context, String filePath) async {
    String downloadUrl = "";
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(uid).child(filePath);

    final uploadedFile = ref.putFile(File(filePath));

    uploadedFile.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          const CircularProgressIndicator();
          break;
        case TaskState.paused:
          CustomSnackBar.showWarningSnackBar(
              context: context, message: "Upload is paused.");
          break;
        case TaskState.canceled:
          CustomSnackBar.showErrorSnackBar(
              context: context, message: "Upload was canceled");
          break;
        case TaskState.error:
          CustomSnackBar.showErrorSnackBar(
              context: context, message: "Something went wrong");
          break;
        case TaskState.success:
          break;
      }
    });
    final snapshot = await uploadedFile.whenComplete(() => null);
    final urlImageUser = await snapshot.ref.getDownloadURL();
    return urlImageUser;
  }

  Future<void> deleteFromStorage(String filePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(uid).child(filePath);
    await ref.delete();
  }
}
