import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  userNotFound,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      case "user-not-found":
        status = AuthStatus.userNotFound;
        break;
      default:
        status = AuthStatus.unknown;
    }

    return status;
  }

  static String generateErrorMessage(error, BuildContext context) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = S.of(context).bad_email;
        break;
      case AuthStatus.weakPassword:
        errorMessage = S.of(context).bad_password;
        break;
      case AuthStatus.wrongPassword:
        errorMessage = S.of(context).wrong_password;
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage = S.of(context).email_already_used;
        break;
      case AuthStatus.userNotFound:
        errorMessage = S.of(context).user_not_exist;
        break;
      default:
        errorMessage = S.of(context).error_message;
    }
    return errorMessage;
  }
}
