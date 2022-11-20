import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  String get username =>
      currentUser?.displayName ?? currentUser?.email ?? 'Username';
}
