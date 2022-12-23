import 'package:firebase_auth/firebase_auth.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/authentication/authentication.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late AuthStatus _status;

  FirebaseUser? _firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }

  Stream<FirebaseUser?> get user {
    return _auth.authStateChanges().map(_firebaseUser);
  }

  User? get currentUser => _auth.currentUser;

  Future signInEmailPassword(LoginUser _login) async {
    await _auth
        .signInWithEmailAndPassword(
            email: _login.email.toString(),
            password: _login.password.toString())
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));
    return _status;
  }

  Future register(LoginUser _login) async {
    await _auth
        .createUserWithEmailAndPassword(
            email: _login.email.toString(),
            password: _login.password.toString())
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));
    return _status;
  }

  Future resetPassword(String email) async {
    await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));
    return _status;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  String getCurrentUserID() {
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    return uid.toString();
  }
}
