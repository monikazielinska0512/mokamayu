import 'package:firebase_auth/firebase_auth.dart';
import 'package:mokamayu/models/models.dart';
import 'package:mokamayu/services/authentication/authentication.dart';

class AuthService {
  late final FirebaseAuth auth;

  AuthService() {
    auth = FirebaseAuth.instance;
  }

  AuthService.withAuth({required this.auth});

  late AuthStatus _status;

  FirebaseUser? _firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }

  Stream<FirebaseUser?> get user {
    return auth.authStateChanges().map(_firebaseUser);
  }

  User? get currentUser => auth.currentUser;

  AuthStatus? get status => _status;

  Future<AuthStatus> signInEmailPassword(LoginUser login) async {
    await auth
        .signInWithEmailAndPassword(
            email: login.email.toString(), password: login.password.toString())
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));
    return _status;
  }

  Future register(LoginUser login) async {
    await auth
        .createUserWithEmailAndPassword(
            email: login.email.toString(), password: login.password.toString())
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));
    return _status;
  }

  Future resetPassword(String email) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));
    return _status;
  }

  Future signOut() async {
    try {
      _status = AuthStatus.unknown;
      return await auth.signOut();
    } catch (e) {
      return null;
    }
  }

  String getCurrentUserID() {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    return uid.toString();
  }
}
