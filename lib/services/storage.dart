import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'authentication/auth.dart';

class StorageService {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final String uid = AuthService().getCurrentUserID();
  String photoURL = "";

  Future<String> uploadPhoto(File? file) async {
    final fileName = basename(file!.path);
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final uploadTask =
        storage.ref().child('$uid/clothes/$fileName').putFile(file, metadata);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      String url = await taskSnapshot.ref.getDownloadURL();
      photoURL = url;
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
          print("Something went wrong");
          break;
        case TaskState.success:
          print("Photo was added");
          break;
      }
    });
    return photoURL;
  }
}
