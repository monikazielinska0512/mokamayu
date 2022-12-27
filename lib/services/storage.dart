import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          // Handle successful uploads on complete
          // ...
          break;
      }
    });
    downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteFromStorage(String filePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(uid).child(filePath);
    await ref.delete();
  }
}
