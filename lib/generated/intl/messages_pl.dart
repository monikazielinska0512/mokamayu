// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pl locale. All the
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
  String get localeName => 'pl';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "confirm_password":
            MessageLookupByLibrary.simpleMessage("Potwierdź hasło"),
        "enter_email":
            MessageLookupByLibrary.simpleMessage("Wprowadź adres email"),
        "enter_password":
            MessageLookupByLibrary.simpleMessage("Wprowadź hasło"),
        "enter_username":
            MessageLookupByLibrary.simpleMessage("Wprowadź nazwę użytkownika"),
        "forgot_password":
            MessageLookupByLibrary.simpleMessage("Zapomniałeś hasła?"),
        "no_account": MessageLookupByLibrary.simpleMessage("Nie masz konta?"),
        "passwords_dont_match":
            MessageLookupByLibrary.simpleMessage("Hasła nie są identyczne"),
        "please_enter_test":
            MessageLookupByLibrary.simpleMessage("Proszę wprowadzić tekst"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Zresetuj hasło"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Zaloguj się"),
        "sign_up": MessageLookupByLibrary.simpleMessage(" Zarejestruj się")
      };
}
