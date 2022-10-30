import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'auth.dart';

class StorageService{
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  final String uid = AuthService().getCurrentUserUID();

  Future<String> uploadFile(File? file) async {
    final fileName = basename(file!.path);
    final destination = '$uid/clothes/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      await ref.putFile(file);
      var downloadURL = await ref.getDownloadURL();
      print("URL: " + downloadURL.toString());
      return downloadURL;
    } catch (e) {
      return "error";
    }
  }

  firebase_storage.FirebaseStorage open()  {
    return firebase_storage.FirebaseStorage.instance;
  }

  Future<String> uploadAndGetURLFile(File? file) async {
    String stringFuture = await uploadFile(file);
    return stringFuture.toString();
  }
}