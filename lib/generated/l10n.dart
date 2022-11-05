// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: depend_on_referenced_packages

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

  /// `Language selection`
  String get language_selection {
    return Intl.message(
      'Language selection',
      name: 'language_selection',
      desc: '',
      args: [],
    );
  }

  /// `Change language`
  String get change_language {
    return Intl.message(
      'Change language',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }

  /// `Vietnamese`
  String get vietnamese {
    return Intl.message(
      'Vietnamese',
      name: 'vietnamese',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Service upgrade`
  String get service_upgrade {
    return Intl.message(
      'Service upgrade',
      name: 'service_upgrade',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get log_out {
    return Intl.message(
      'Log out',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Type service`
  String get type_service {
    return Intl.message(
      'Type service',
      name: 'type_service',
      desc: '',
      args: [],
    );
  }

  /// `Number installed device`
  String get number_device_installed {
    return Intl.message(
      'Number installed device',
      name: 'number_device_installed',
      desc: '',
      args: [],
    );
  }

  /// `Number installed Room`
  String get number_room_installed {
    return Intl.message(
      'Number installed Room',
      name: 'number_room_installed',
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

  /// `Dashboard`
  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `All device`
  String get all_device {
    return Intl.message(
      'All device',
      name: 'all_device',
      desc: '',
      args: [],
    );
  }

  /// `config room`
  String get config_room {
    return Intl.message(
      'config room',
      name: 'config_room',
      desc: '',
      args: [],
    );
  }

  /// `Config device`
  String get config_device {
    return Intl.message(
      'Config device',
      name: 'config_device',
      desc: '',
      args: [],
    );
  }

  /// `Good everning!`
  String get good_everning {
    return Intl.message(
      'Good everning!',
      name: 'good_everning',
      desc: '',
      args: [],
    );
  }

  /// `Good afternoon!`
  String get good_afternoon {
    return Intl.message(
      'Good afternoon!',
      name: 'good_afternoon',
      desc: '',
      args: [],
    );
  }

  /// `Good morning!`
  String get good_morning {
    return Intl.message(
      'Good morning!',
      name: 'good_morning',
      desc: '',
      args: [],
    );
  }

  /// `No device installed!`
  String get No_device_installed {
    return Intl.message(
      'No device installed!',
      name: 'No_device_installed',
      desc: '',
      args: [],
    );
  }

  /// `No room installed!`
  String get No_room_installed {
    return Intl.message(
      'No room installed!',
      name: 'No_room_installed',
      desc: '',
      args: [],
    );
  }

  /// `Click here to add a new device!`
  String get click_add_device {
    return Intl.message(
      'Click here to add a new device!',
      name: 'click_add_device',
      desc: '',
      args: [],
    );
  }

  /// `No devices connected to the room yet!`
  String get no_devices_connected_to_the_room_yet {
    return Intl.message(
      'No devices connected to the room yet!',
      name: 'no_devices_connected_to_the_room_yet',
      desc: '',
      args: [],
    );
  }

  /// `Mailbox`
  String get mailbox {
    return Intl.message(
      'Mailbox',
      name: 'mailbox',
      desc: '',
      args: [],
    );
  }

  /// `Try reload page...`
  String get try_reload_page {
    return Intl.message(
      'Try reload page...',
      name: 'try_reload_page',
      desc: '',
      args: [],
    );
  }

  /// `Enter the new room name:`
  String get enter_new_name_room {
    return Intl.message(
      'Enter the new room name:',
      name: 'enter_new_name_room',
      desc: '',
      args: [],
    );
  }

  /// `Add more rooms`
  String get add_room {
    return Intl.message(
      'Add more rooms',
      name: 'add_room',
      desc: '',
      args: [],
    );
  }

  /// `Total number rooms:`
  String get total_number_room {
    return Intl.message(
      'Total number rooms:',
      name: 'total_number_room',
      desc: '',
      args: [],
    );
  }

  /// `Maximum room:`
  String get max_room {
    return Intl.message(
      'Maximum room:',
      name: 'max_room',
      desc: '',
      args: [],
    );
  }

  /// `List of available rooms:`
  String get list_room_available {
    return Intl.message(
      'List of available rooms:',
      name: 'list_room_available',
      desc: '',
      args: [],
    );
  }

  /// `Change name the room`
  String get change_name_room {
    return Intl.message(
      'Change name the room',
      name: 'change_name_room',
      desc: '',
      args: [],
    );
  }

  /// `Delete room`
  String get delete_room {
    return Intl.message(
      'Delete room',
      name: 'delete_room',
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

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `You definitely want to delete:`
  String get are_y_want_delete {
    return Intl.message(
      'You definitely want to delete:',
      name: 'are_y_want_delete',
      desc: '',
      args: [],
    );
  }

  /// `This room already exists!`
  String get this_room_already_exists {
    return Intl.message(
      'This room already exists!',
      name: 'this_room_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Room limit reached, please upgrade service!`
  String get room_limit_please_upgrade_service {
    return Intl.message(
      'Room limit reached, please upgrade service!',
      name: 'room_limit_please_upgrade_service',
      desc: '',
      args: [],
    );
  }

  /// `Empty!`
  String get empty {
    return Intl.message(
      'Empty!',
      name: 'empty',
      desc: '',
      args: [],
    );
  }

  /// `Enter a new name:`
  String get enter_new_name {
    return Intl.message(
      'Enter a new name:',
      name: 'enter_new_name',
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
      Locale.fromSubtags(languageCode: 'vi'),
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
