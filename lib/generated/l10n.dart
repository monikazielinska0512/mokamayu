// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// ` Sign up`
  String get sign_up {
    return Intl.message(
      ' Sign up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// ` Sign out`
  String get sign_out {
    return Intl.message(
      ' Sign out',
      name: 'sign_out',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get sign_in {
    return Intl.message(
      'Sign in',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get no_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'no_account',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get enter_password {
    return Intl.message(
      'Password',
      name: 'enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get enter_username {
    return Intl.message(
      'Username',
      name: 'enter_username',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get enter_email {
    return Intl.message(
      'Email',
      name: 'enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter text`
  String get please_enter_test {
    return Intl.message(
      'Please enter text',
      name: 'please_enter_test',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwords_dont_match {
    return Intl.message(
      'Passwords do not match',
      name: 'passwords_dont_match',
      desc: '',
      args: [],
    );
  }

  /// `The email address is badly formatted`
  String get bad_email {
    return Intl.message(
      'The email address is badly formatted',
      name: 'bad_email',
      desc: '',
      args: [],
    );
  }

  /// `Password should be at least 6 characters long`
  String get bad_password {
    return Intl.message(
      'Password should be at least 6 characters long',
      name: 'bad_password',
      desc: '',
      args: [],
    );
  }

  /// `Your email or password is wrong`
  String get wrong_password {
    return Intl.message(
      'Your email or password is wrong',
      name: 'wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `The email address is already in use by another account`
  String get email_already_used {
    return Intl.message(
      'The email address is already in use by another account',
      name: 'email_already_used',
      desc: '',
      args: [],
    );
  }

  /// `User does not exist`
  String get user_not_exist {
    return Intl.message(
      'User does not exist',
      name: 'user_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again later`
  String get error_message {
    return Intl.message(
      'An error occurred. Please try again later',
      name: 'error_message',
      desc: '',
      args: [],
    );
  }

  /// `DISMISS`
  String get dismiss {
    return Intl.message(
      'DISMISS',
      name: 'dismiss',
      desc: '',
      args: [],
    );
  }

  /// `Wardrobe`
  String get wardrobe {
    return Intl.message(
      'Wardrobe',
      name: 'wardrobe',
      desc: '',
      args: [],
    );
  }

  /// `Outfits`
  String get outfits {
    return Intl.message(
      'Outfits',
      name: 'outfits',
      desc: '',
      args: [],
    );
  }

  /// `Social`
  String get social {
    return Intl.message(
      'Social',
      name: 'social',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Your Wardrobe`
  String get wardrobe_page_title {
    return Intl.message(
      'Your Wardrobe',
      name: 'wardrobe_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Search by name`
  String get searchbar_wardrobe_item {
    return Intl.message(
      'Search by name',
      name: 'searchbar_wardrobe_item',
      desc: '',
      args: [],
    );
  }

  /// `Skirt`
  String get skirt {
    return Intl.message(
      'Skirt',
      name: 'skirt',
      desc: '',
      args: [],
    );
  }

  /// `T-Shirt`
  String get tshirt {
    return Intl.message(
      'T-Shirt',
      name: 'tshirt',
      desc: '',
      args: [],
    );
  }

  /// `Dress`
  String get dress {
    return Intl.message(
      'Dress',
      name: 'dress',
      desc: '',
      args: [],
    );
  }

  /// `Shoes`
  String get shoes {
    return Intl.message(
      'Shoes',
      name: 'shoes',
      desc: '',
      args: [],
    );
  }

  /// `Hat`
  String get hat {
    return Intl.message(
      'Hat',
      name: 'hat',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'pl'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
