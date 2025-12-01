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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Change Language`
  String get change_language {
    return Intl.message(
      'Change Language',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }

  /// `Mazen Ahmed`
  String get name {
    return Intl.message('Mazen Ahmed', name: 'name', desc: '', args: []);
  }

  /// `Sign out`
  String get signout {
    return Intl.message('Sign out', name: 'signout', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get donthaveaccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'donthaveaccount',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Logout Success`
  String get logoutsuccess {
    return Intl.message(
      'Logout Success',
      name: 'logoutsuccess',
      desc: '',
      args: [],
    );
  }

  /// `Logout Failure`
  String get logoutfailure {
    return Intl.message(
      'Logout Failure',
      name: 'logoutfailure',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
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

  /// `Let's Start`
  String get lets_start {
    return Intl.message('Let\'s Start', name: 'lets_start', desc: '', args: []);
  }

  /// `Ready to conquer your tasks? Let's Do \n It together.`
  String get onbording_subtitle {
    return Intl.message(
      'Ready to conquer your tasks? Let\'s Do \n It together.',
      name: 'onbording_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome To\n Tasky !`
  String get welcome_tasky {
    return Intl.message(
      'Welcome To\n Tasky !',
      name: 'welcome_tasky',
      desc: '',
      args: [],
    );
  }

  /// `Please verify your email 📧`
  String get please_verify_your_email {
    return Intl.message(
      'Please verify your email 📧',
      name: 'please_verify_your_email',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password provided.`
  String get wrong_password {
    return Intl.message(
      'Wrong password provided.',
      name: 'wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `User not found.`
  String get user_not_found {
    return Intl.message(
      'User not found.',
      name: 'user_not_found',
      desc: '',
      args: [],
    );
  }

  /// `No user found for that email.`
  String get no_user_found {
    return Intl.message(
      'No user found for that email.',
      name: 'no_user_found',
      desc: '',
      args: [],
    );
  }

  /// `Login successful ✅`
  String get loginsuccess {
    return Intl.message(
      'Login successful ✅',
      name: 'loginsuccess',
      desc: '',
      args: [],
    );
  }

  /// `Login failed ❌`
  String get login_failed {
    return Intl.message(
      'Login failed ❌',
      name: 'login_failed',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred. Please try again later.`
  String get unknown_error {
    return Intl.message(
      'An unknown error occurred. Please try again later.',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `The password provided is too weak.`
  String get weak_password {
    return Intl.message(
      'The password provided is too weak.',
      name: 'weak_password',
      desc: '',
      args: [],
    );
  }

  /// `The account already exists.`
  String get account_already_exists {
    return Intl.message(
      'The account already exists.',
      name: 'account_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `There are no tasks yet,\n     Press the button \n    to add a new task.`
  String get not_task {
    return Intl.message(
      'There are no tasks yet,\n     Press the button \n    to add a new task.',
      name: 'not_task',
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
      Locale.fromSubtags(languageCode: 'ar'),
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
