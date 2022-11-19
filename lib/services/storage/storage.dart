import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mokamayu/services/authentication/authentication.dart';
import 'package:path/path.dart';

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;
  final String uid = AuthService().getCurrentUserID();
  String photoURL = "";

  Future<String> uploadPhoto(File? file) async {
    final fileName = basename(file!.path);
    final metadata = SettableMetadata(contentType: "image/jpeg");

    Reference clothesRef = storage
        .ref()
        .child(uid)
        .child("clothes")
        .child('vibes')
        .child(fileName);

    final uploadTask = clothesRef.putFile(file, metadata);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
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
          print("Upload is success.");
      }
    });
    photoURL = await clothesRef.getDownloadURL();
    print("URLLLL" + photoURL);

    return storage.ref().child('$uid/clothes/$fileName').getDownloadURL();
  }
}
