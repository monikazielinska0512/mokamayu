// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "bad_email": MessageLookupByLibrary.simpleMessage(
            "The email address is badly formatted"),
        "bad_password": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters long"),
        "confirm_password":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "enter_email": MessageLookupByLibrary.simpleMessage("Enter Email"),
        "enter_password":
            MessageLookupByLibrary.simpleMessage("Enter Password"),
        "enter_username":
            MessageLookupByLibrary.simpleMessage("Enter Username"),
        "forgot_password":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "no_account":
            MessageLookupByLibrary.simpleMessage("Don\'t have account?"),
        "passwords_dont_match":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "please_enter_test":
            MessageLookupByLibrary.simpleMessage("Please enter text"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Reset Password"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Log in"),
        "sign_up": MessageLookupByLibrary.simpleMessage(" Sign up")
      };
}
