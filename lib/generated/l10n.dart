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

  /// `Outfits`
  String get outfits_by_me {
    return Intl.message(
      'Outfits',
      name: 'outfits_by_me',
      desc: '',
      args: [],
    );
  }

  /// `By friends`
  String get outfits_by_friends {
    return Intl.message(
      'By friends',
      name: 'outfits_by_friends',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get posts {
    return Intl.message(
      'Posts',
      name: 'posts',
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

  /// `Dress`
  String get dress {
    return Intl.message(
      'Dress',
      name: 'dress',
      desc: '',
      args: [],
    );
  }

  /// `Top`
  String get top {
    return Intl.message(
      'Top',
      name: 'top',
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

  /// `Trousers`
  String get trousers {
    return Intl.message(
      'Trousers',
      name: 'trousers',
      desc: '',
      args: [],
    );
  }

  /// `Jeans`
  String get jeans {
    return Intl.message(
      'Jeans',
      name: 'jeans',
      desc: '',
      args: [],
    );
  }

  /// `Sweatshirt`
  String get sweatshirt {
    return Intl.message(
      'Sweatshirt',
      name: 'sweatshirt',
      desc: '',
      args: [],
    );
  }

  /// `Hoodie`
  String get hoodie {
    return Intl.message(
      'Hoodie',
      name: 'hoodie',
      desc: '',
      args: [],
    );
  }

  /// `Jacket`
  String get jacket {
    return Intl.message(
      'Jacket',
      name: 'jacket',
      desc: '',
      args: [],
    );
  }

  /// `Blazer`
  String get blazer {
    return Intl.message(
      'Blazer',
      name: 'blazer',
      desc: '',
      args: [],
    );
  }

  /// `Coat`
  String get coat {
    return Intl.message(
      'Coat',
      name: 'coat',
      desc: '',
      args: [],
    );
  }

  /// `Sweater`
  String get sweater {
    return Intl.message(
      'Sweater',
      name: 'sweater',
      desc: '',
      args: [],
    );
  }

  /// `Cardigan`
  String get cardigan {
    return Intl.message(
      'Cardigan',
      name: 'cardigan',
      desc: '',
      args: [],
    );
  }

  /// `Swimsuit`
  String get swimsuit {
    return Intl.message(
      'Swimsuit',
      name: 'swimsuit',
      desc: '',
      args: [],
    );
  }

  /// `Sportswear`
  String get sports {
    return Intl.message(
      'Sportswear',
      name: 'sports',
      desc: '',
      args: [],
    );
  }

  /// `Shorts`
  String get shorts {
    return Intl.message(
      'Shorts',
      name: 'shorts',
      desc: '',
      args: [],
    );
  }

  /// `Pyjama`
  String get pyjama {
    return Intl.message(
      'Pyjama',
      name: 'pyjama',
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

  /// `See details`
  String get see_details {
    return Intl.message(
      'See details',
      name: 'see_details',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get friends {
    return Intl.message(
      'Friends',
      name: 'friends',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get edit_profile {
    return Intl.message(
      'Edit profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `Friends requests`
  String get friend_requests {
    return Intl.message(
      'Friends requests',
      name: 'friend_requests',
      desc: '',
      args: [],
    );
  }

  /// `Current weather`
  String get show_current_weather {
    return Intl.message(
      'Current weather',
      name: 'show_current_weather',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get current_weather {
    return Intl.message(
      'Current',
      name: 'current_weather',
      desc: '',
      args: [],
    );
  }

  /// `Enter city`
  String get enter_city {
    return Intl.message(
      'Enter city',
      name: 'enter_city',
      desc: '',
      args: [],
    );
  }

  /// `Looks for`
  String get looks_for {
    return Intl.message(
      'Looks for',
      name: 'looks_for',
      desc: '',
      args: [],
    );
  }

  /// `Plan outfits for`
  String get add_looks_for {
    return Intl.message(
      'Plan outfits for',
      name: 'add_looks_for',
      desc: '',
      args: [],
    );
  }

  /// `Pick outfits`
  String get pick_outfits {
    return Intl.message(
      'Pick outfits',
      name: 'pick_outfits',
      desc: '',
      args: [],
    );
  }

  /// `Summary`
  String get summary {
    return Intl.message(
      'Summary',
      name: 'summary',
      desc: '',
      args: [],
    );
  }

  /// `Pick some wardrobe items first`
  String get pick_clothes_error {
    return Intl.message(
      'Pick some wardrobe items first',
      name: 'pick_clothes_error',
      desc: '',
      args: [],
    );
  }

  /// `Pick some outfits first`
  String get pick_outfits_error {
    return Intl.message(
      'Pick some outfits first',
      name: 'pick_outfits_error',
      desc: '',
      args: [],
    );
  }

  /// `Accessories`
  String get accessories {
    return Intl.message(
      'Accessories',
      name: 'accessories',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any items in your wardrobe!`
  String get empty_wardrobe {
    return Intl.message(
      'You don\'t have any items in your wardrobe!',
      name: 'empty_wardrobe',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get filters {
    return Intl.message(
      'Filters',
      name: 'filters',
      desc: '',
      args: [],
    );
  }

  /// `Clothing type`
  String get clothing_types {
    return Intl.message(
      'Clothing type',
      name: 'clothing_types',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message(
      'Size',
      name: 'size',
      desc: '',
      args: [],
    );
  }

  /// `Style`
  String get style {
    return Intl.message(
      'Style',
      name: 'style',
      desc: '',
      args: [],
    );
  }

  /// `Apply filters`
  String get apply_filters {
    return Intl.message(
      'Apply filters',
      name: 'apply_filters',
      desc: '',
      args: [],
    );
  }

  /// `No outfits have been created yet!`
  String get empty_outfits {
    return Intl.message(
      'No outfits have been created yet!',
      name: 'empty_outfits',
      desc: '',
      args: [],
    );
  }

  /// `It seems that you don't have any added friend yet!`
  String get empty_feed {
    return Intl.message(
      'It seems that you don\'t have any added friend yet!',
      name: 'empty_feed',
      desc: '',
      args: [],
    );
  }

  /// `Find your friend`
  String get search_friend {
    return Intl.message(
      'Find your friend',
      name: 'search_friend',
      desc: '',
      args: [],
    );
  }

  /// `No pending invitations`
  String get no_pending_invitation {
    return Intl.message(
      'No pending invitations',
      name: 'no_pending_invitation',
      desc: '',
      args: [],
    );
  }

  /// `No pending invitations from such user`
  String get no_pending_invitation_user {
    return Intl.message(
      'No pending invitations from such user',
      name: 'no_pending_invitation_user',
      desc: '',
      args: [],
    );
  }

  /// `Requests`
  String get friends_request {
    return Intl.message(
      'Requests',
      name: 'friends_request',
      desc: '',
      args: [],
    );
  }

  /// `All your friends`
  String get all_friends {
    return Intl.message(
      'All your friends',
      name: 'all_friends',
      desc: '',
      args: [],
    );
  }

  /// `Found`
  String get found {
    return Intl.message(
      'Found',
      name: 'found',
      desc: '',
      args: [],
    );
  }

  /// `results`
  String get results {
    return Intl.message(
      'results',
      name: 'results',
      desc: '',
      args: [],
    );
  }

  /// `You don't have friends yet`
  String get no_friends {
    return Intl.message(
      'You don\'t have friends yet',
      name: 'no_friends',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `No matched friends`
  String get no_found_friends {
    return Intl.message(
      'No matched friends',
      name: 'no_found_friends',
      desc: '',
      args: [],
    );
  }

  /// `You haven't gotten any notification yet!`
  String get empty_notifications {
    return Intl.message(
      'You haven\'t gotten any notification yet!',
      name: 'empty_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Create your virtual wardrobe!`
  String get initial_title {
    return Intl.message(
      'Create your virtual wardrobe!',
      name: 'initial_title',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get get_started {
    return Intl.message(
      'Get Started',
      name: 'get_started',
      desc: '',
      args: [],
    );
  }

  /// `Check your inbox!`
  String get check_inbox {
    return Intl.message(
      'Check your inbox!',
      name: 'check_inbox',
      desc: '',
      args: [],
    );
  }

  /// `Email for reset password has been sent, please check your email.`
  String get email_sent {
    return Intl.message(
      'Email for reset password has been sent, please check your email.',
      name: 'email_sent',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Planned outfits`
  String get planned_outfits {
    return Intl.message(
      'Planned outfits',
      name: 'planned_outfits',
      desc: '',
      args: [],
    );
  }

  /// `There's no planned outfits for this day`
  String get empty_planned_outfits {
    return Intl.message(
      'There\'s no planned outfits for this day',
      name: 'empty_planned_outfits',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Enter your item name`
  String get enter_name {
    return Intl.message(
      'Enter your item name',
      name: 'enter_name',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `School`
  String get school {
    return Intl.message(
      'School',
      name: 'school',
      desc: '',
      args: [],
    );
  }

  /// `Classic`
  String get classic {
    return Intl.message(
      'Classic',
      name: 'classic',
      desc: '',
      args: [],
    );
  }

  /// `Sport`
  String get sport {
    return Intl.message(
      'Sport',
      name: 'sport',
      desc: '',
      args: [],
    );
  }

  /// `Elegant`
  String get elegant {
    return Intl.message(
      'Elegant',
      name: 'elegant',
      desc: '',
      args: [],
    );
  }

  /// `Vintage`
  String get vintage {
    return Intl.message(
      'Vintage',
      name: 'vintage',
      desc: '',
      args: [],
    );
  }

  /// `Smart Casual`
  String get smart_casual {
    return Intl.message(
      'Smart Casual',
      name: 'smart_casual',
      desc: '',
      args: [],
    );
  }

  /// `Minimalistic`
  String get minimalism {
    return Intl.message(
      'Minimalistic',
      name: 'minimalism',
      desc: '',
      args: [],
    );
  }

  /// `Retro`
  String get retro {
    return Intl.message(
      'Retro',
      name: 'retro',
      desc: '',
      args: [],
    );
  }

  /// `Glamour`
  String get glamour {
    return Intl.message(
      'Glamour',
      name: 'glamour',
      desc: '',
      args: [],
    );
  }

  /// `Romantic`
  String get romantic {
    return Intl.message(
      'Romantic',
      name: 'romantic',
      desc: '',
      args: [],
    );
  }

  /// `Military`
  String get military {
    return Intl.message(
      'Military',
      name: 'military',
      desc: '',
      args: [],
    );
  }

  /// `Streetwear`
  String get streetwear {
    return Intl.message(
      'Streetwear',
      name: 'streetwear',
      desc: '',
      args: [],
    );
  }

  /// `Boho`
  String get boho {
    return Intl.message(
      'Boho',
      name: 'boho',
      desc: '',
      args: [],
    );
  }

  /// `Hippie`
  String get hippe {
    return Intl.message(
      'Hippie',
      name: 'hippe',
      desc: '',
      args: [],
    );
  }

  /// `Item has been added to wardrobe!`
  String get item_added {
    return Intl.message(
      'Item has been added to wardrobe!',
      name: 'item_added',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Some attribute are still to choose`
  String get empty_paramaters {
    return Intl.message(
      'Some attribute are still to choose',
      name: 'empty_paramaters',
      desc: '',
      args: [],
    );
  }

  /// `Photo hasn't been chosen!`
  String get photo_not_added {
    return Intl.message(
      'Photo hasn\'t been chosen!',
      name: 'photo_not_added',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Item has been updated!`
  String get updated_item {
    return Intl.message(
      'Item has been updated!',
      name: 'updated_item',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get something_went_wrong {
    return Intl.message(
      'Something went wrong',
      name: 'something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Item has been deleted`
  String get deleted_item {
    return Intl.message(
      'Item has been deleted',
      name: 'deleted_item',
      desc: '',
      args: [],
    );
  }

  /// `Do you want delete\n`
  String get ask_deletion {
    return Intl.message(
      'Do you want delete\n',
      name: 'ask_deletion',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  /// `Party`
  String get party {
    return Intl.message(
      'Party',
      name: 'party',
      desc: '',
      args: [],
    );
  }

  /// `Casual`
  String get casual {
    return Intl.message(
      'Casual',
      name: 'casual',
      desc: '',
      args: [],
    );
  }

  /// `Wedding`
  String get wedding {
    return Intl.message(
      'Wedding',
      name: 'wedding',
      desc: '',
      args: [],
    );
  }

  /// `Create outfit`
  String get create_outfit {
    return Intl.message(
      'Create outfit',
      name: 'create_outfit',
      desc: '',
      args: [],
    );
  }

  /// `Use your creativity!`
  String get use_creativity {
    return Intl.message(
      'Use your creativity!',
      name: 'use_creativity',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Summer`
  String get summer {
    return Intl.message(
      'Summer',
      name: 'summer',
      desc: '',
      args: [],
    );
  }

  /// `Winter`
  String get winter {
    return Intl.message(
      'Winter',
      name: 'winter',
      desc: '',
      args: [],
    );
  }

  /// `Autumn`
  String get autumn {
    return Intl.message(
      'Autumn',
      name: 'autumn',
      desc: '',
      args: [],
    );
  }

  /// `Spring`
  String get spring {
    return Intl.message(
      'Spring',
      name: 'spring',
      desc: '',
      args: [],
    );
  }

  /// `Season`
  String get season {
    return Intl.message(
      'Season',
      name: 'season',
      desc: '',
      args: [],
    );
  }

  /// `for yourself`
  String get for_yourself {
    return Intl.message(
      'for yourself',
      name: 'for_yourself',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get tags {
    return Intl.message(
      'Tags',
      name: 'tags',
      desc: '',
      args: [],
    );
  }

  /// `Do you want delete this outfit?`
  String get delete_outfit {
    return Intl.message(
      'Do you want delete this outfit?',
      name: 'delete_outfit',
      desc: '',
      args: [],
    );
  }

  /// `Items`
  String get items {
    return Intl.message(
      'Items',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `Attributes`
  String get attributes {
    return Intl.message(
      'Attributes',
      name: 'attributes',
      desc: '',
      args: [],
    );
  }

  /// `Outfit for friend has been created`
  String get outfit_created_for_friend {
    return Intl.message(
      'Outfit for friend has been created',
      name: 'outfit_created_for_friend',
      desc: '',
      args: [],
    );
  }

  /// `Outfit has been created`
  String get outfit_created {
    return Intl.message(
      'Outfit has been created',
      name: 'outfit_created',
      desc: '',
      args: [],
    );
  }

  /// `Invitations`
  String get requests {
    return Intl.message(
      'Invitations',
      name: 'requests',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get users {
    return Intl.message(
      'Users',
      name: 'users',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `2 weeks`
  String get two_weeks {
    return Intl.message(
      '2 weeks',
      name: 'two_weeks',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message(
      'Week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `See all comments`
  String get see_all_comments {
    return Intl.message(
      'See all comments',
      name: 'see_all_comments',
      desc: '',
      args: [],
    );
  }

  /// `Posted`
  String get posted {
    return Intl.message(
      'Posted',
      name: 'posted',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `liked your post!`
  String get liked_your_post {
    return Intl.message(
      'liked your post!',
      name: 'liked_your_post',
      desc: '',
      args: [],
    );
  }

  /// `commented on your post!`
  String get commented_on_your_post {
    return Intl.message(
      'commented on your post!',
      name: 'commented_on_your_post',
      desc: '',
      args: [],
    );
  }

  /// `created ourfit for you!`
  String get created_outfit_for_you {
    return Intl.message(
      'created ourfit for you!',
      name: 'created_outfit_for_you',
      desc: '',
      args: [],
    );
  }

  /// `You and user`
  String get you_and_user {
    return Intl.message(
      'You and user',
      name: 'you_and_user',
      desc: '',
      args: [],
    );
  }

  /// `are now friends!`
  String get are_now_friends {
    return Intl.message(
      'are now friends!',
      name: 'are_now_friends',
      desc: '',
      args: [],
    );
  }

  /// `Private`
  String get private {
    return Intl.message(
      'Private',
      name: 'private',
      desc: '',
      args: [],
    );
  }

  /// `Private profile`
  String get private_profile {
    return Intl.message(
      'Private profile',
      name: 'private_profile',
      desc: '',
      args: [],
    );
  }

  /// `Change photo`
  String get change_photo {
    return Intl.message(
      'Change photo',
      name: 'change_photo',
      desc: '',
      args: [],
    );
  }

  /// `Delete photo`
  String get delete_photo {
    return Intl.message(
      'Delete photo',
      name: 'delete_photo',
      desc: '',
      args: [],
    );
  }

  /// `My profile`
  String get my_profile {
    return Intl.message(
      'My profile',
      name: 'my_profile',
      desc: '',
      args: [],
    );
  }

  /// `Profile name`
  String get profile_name {
    return Intl.message(
      'Profile name',
      name: 'profile_name',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Added comment`
  String get added_comment {
    return Intl.message(
      'Added comment',
      name: 'added_comment',
      desc: '',
      args: [],
    );
  }

  /// `This post has no comments`
  String get no_comments {
    return Intl.message(
      'This post has no comments',
      name: 'no_comments',
      desc: '',
      args: [],
    );
  }

  /// `Created by `
  String get created_by {
    return Intl.message(
      'Created by ',
      name: 'created_by',
      desc: '',
      args: [],
    );
  }

  /// `Outfit has been deleted`
  String get deleted_outfit {
    return Intl.message(
      'Outfit has been deleted',
      name: 'deleted_outfit',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get no_data {
    return Intl.message(
      'No data',
      name: 'no_data',
      desc: '',
      args: [],
    );
  }

  /// `Friend`
  String get friend {
    return Intl.message(
      'Friend',
      name: 'friend',
      desc: '',
      args: [],
    );
  }

  /// `Friend request has been sent`
  String get friend_request_sent {
    return Intl.message(
      'Friend request has been sent',
      name: 'friend_request_sent',
      desc: '',
      args: [],
    );
  }

  /// `Answer`
  String get answer {
    return Intl.message(
      'Answer',
      name: 'answer',
      desc: '',
      args: [],
    );
  }

  /// `Add friend`
  String get add_friend {
    return Intl.message(
      'Add friend',
      name: 'add_friend',
      desc: '',
      args: [],
    );
  }

  /// `Decline`
  String get decline {
    return Intl.message(
      'Decline',
      name: 'decline',
      desc: '',
      args: [],
    );
  }

  /// `Remove friend`
  String get remove_friend {
    return Intl.message(
      'Remove friend',
      name: 'remove_friend',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `There are no posts to display`
  String get no_posts {
    return Intl.message(
      'There are no posts to display',
      name: 'no_posts',
      desc: '',
      args: [],
    );
  }

  /// `Post author not found`
  String get post_author_not_found {
    return Intl.message(
      'Post author not found',
      name: 'post_author_not_found',
      desc: '',
      args: [],
    );
  }

  /// `No users found`
  String get no_users_found {
    return Intl.message(
      'No users found',
      name: 'no_users_found',
      desc: '',
      args: [],
    );
  }

  /// `Tights`
  String get tights {
    return Intl.message(
      'Tights',
      name: 'tights',
      desc: '',
      args: [],
    );
  }

  /// `Socks`
  String get socks {
    return Intl.message(
      'Socks',
      name: 'socks',
      desc: '',
      args: [],
    );
  }

  /// `Black`
  String get black {
    return Intl.message(
      'Black',
      name: 'black',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get blue {
    return Intl.message(
      'Blue',
      name: 'blue',
      desc: '',
      args: [],
    );
  }

  /// `Brown`
  String get brown {
    return Intl.message(
      'Brown',
      name: 'brown',
      desc: '',
      args: [],
    );
  }

  /// `Gold`
  String get gold {
    return Intl.message(
      'Gold',
      name: 'gold',
      desc: '',
      args: [],
    );
  }

  /// `Gray`
  String get gray {
    return Intl.message(
      'Gray',
      name: 'gray',
      desc: '',
      args: [],
    );
  }

  /// `Green`
  String get green {
    return Intl.message(
      'Green',
      name: 'green',
      desc: '',
      args: [],
    );
  }

  /// `Navy`
  String get navy {
    return Intl.message(
      'Navy',
      name: 'navy',
      desc: '',
      args: [],
    );
  }

  /// `Orange`
  String get orange {
    return Intl.message(
      'Orange',
      name: 'orange',
      desc: '',
      args: [],
    );
  }

  /// `Pink`
  String get pink {
    return Intl.message(
      'Pink',
      name: 'pink',
      desc: '',
      args: [],
    );
  }

  /// `Purple`
  String get purple {
    return Intl.message(
      'Purple',
      name: 'purple',
      desc: '',
      args: [],
    );
  }

  /// `Red`
  String get red {
    return Intl.message(
      'Red',
      name: 'red',
      desc: '',
      args: [],
    );
  }

  /// `Silver`
  String get silver {
    return Intl.message(
      'Silver',
      name: 'silver',
      desc: '',
      args: [],
    );
  }

  /// `White`
  String get white {
    return Intl.message(
      'White',
      name: 'white',
      desc: '',
      args: [],
    );
  }

  /// `Yellow`
  String get yellow {
    return Intl.message(
      'Yellow',
      name: 'yellow',
      desc: '',
      args: [],
    );
  }

  /// `Cashmere`
  String get cashmere {
    return Intl.message(
      'Cashmere',
      name: 'cashmere',
      desc: '',
      args: [],
    );
  }

  /// `Cotton`
  String get cotton {
    return Intl.message(
      'Cotton',
      name: 'cotton',
      desc: '',
      args: [],
    );
  }

  /// `Denim`
  String get denim {
    return Intl.message(
      'Denim',
      name: 'denim',
      desc: '',
      args: [],
    );
  }

  /// `Leather`
  String get leather {
    return Intl.message(
      'Leather',
      name: 'leather',
      desc: '',
      args: [],
    );
  }

  /// `Linen`
  String get linen {
    return Intl.message(
      'Linen',
      name: 'linen',
      desc: '',
      args: [],
    );
  }

  /// `Silk`
  String get silk {
    return Intl.message(
      'Silk',
      name: 'silk',
      desc: '',
      args: [],
    );
  }

  /// `Synthetic`
  String get synthetic {
    return Intl.message(
      'Synthetic',
      name: 'synthetic',
      desc: '',
      args: [],
    );
  }

  /// `Wool`
  String get wool {
    return Intl.message(
      'Wool',
      name: 'wool',
      desc: '',
      args: [],
    );
  }

  /// `Canvas`
  String get canvas {
    return Intl.message(
      'Canvas',
      name: 'canvas',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Material`
  String get material {
    return Intl.message(
      'Material',
      name: 'material',
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
