import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mokamayu/models/login_user.dart';
import 'package:mokamayu/services/authentication/auth.dart';
import 'package:mokamayu/services/authentication/auth_exception_handler.dart';

import 'authentication_test.mocks.dart';

@GenerateMocks([FirebaseAuth, UserCredential])
void main() {
  late MockFirebaseAuth auth;
  late AuthService authService;
  LoginUser testLoginData =
      LoginUser(email: "test@test.com", password: "password");

  group('authentication test', () {
    setUp(() {
      auth = MockFirebaseAuth();
      authService = AuthService.withAuth(auth: auth);

      when(auth.signInWithEmailAndPassword(
              email: 'test@test.com', password: 'password'))
          .thenAnswer((_) async => MockUserCredential());
      when(auth.createUserWithEmailAndPassword(
              email: 'test@test.com', password: 'password'))
          .thenAnswer((_) async => MockUserCredential());
    });

    test("sign in with email and password", () async {
      AuthStatus? authStatus =
          await authService.signInEmailPassword(testLoginData);
      expect(authStatus, AuthStatus.successful);
    });

    test("register with email and password", () async {
      AuthStatus? authStatus = await authService.register(testLoginData);
      expect(authStatus, AuthStatus.successful);
    });

    test('sign out', () async {
      await authService.signInEmailPassword(testLoginData);
      expect(authService.status, AuthStatus.successful);

      await authService.signOut();
      expect(authService.status, AuthStatus.unknown);
    });
  });
}
