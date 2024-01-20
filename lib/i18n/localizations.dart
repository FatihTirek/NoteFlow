import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final localeName = Intl.canonicalizedLocale(locale.languageCode);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations get instance =>
      AppLocalizationsDelegate.instance ?? AppLocalizations();

  String p0(int num) => Intl.plural(
        num,
        one: 'Delete Note',
        other: 'Delete Notes',
        args: [num],
        name: 'p0',
      );
  String p1(int num) => Intl.plural(
        num,
        one: 'Are you sure you want to delete this note?',
        other: 'Are you sure you want to delete selected notes?',
        args: [num],
        name: 'p1',
      );
  String p3(int num) => Intl.plural(
        num,
        one: 'Notification',
        other: 'Notifications',
        args: [num],
        name: 'p3',
      );

  String m1(String errorCode) => Intl.message(
        'Error code: $errorCode',
        args: [errorCode],
        name: 'm1',
      );
  String m2(String version) => Intl.message(
        'Version $version',
        args: [version],
        name: 'm2',
      );

  String get w0 => Intl.message(
        'Yesterday',
        name: 'w0',
      );
  String get w1 => Intl.message(
        'Cancel',
        name: 'w1',
      );
  String get w2 => Intl.message(
        'Done',
        name: 'w2',
      );
  String get w3 => Intl.message(
        'Folder name',
        name: 'w3',
      );
  String get w4 => Intl.message(
        'Create Folder',
        name: 'w4',
      );
  String get w5 => Intl.message(
        'All Notes',
        name: 'w5',
      );
  String get w6 => Intl.message(
        'Title',
        name: 'w6',
      );
  String get w7 => Intl.message(
        'Type something...',
        name: 'w7',
      );
  String get w8 => Intl.message(
        'Reminder set successfully',
        name: 'w8',
      );
  String get w9 => Intl.message(
        'Reminder cannot set for an empty note',
        name: 'w9',
      );
  String get w10 => Intl.message(
        'Reminder cannot set past',
        name: 'w10',
      );
  String get w11 => Intl.message(
        'Folders',
        name: 'w11',
      );
  String get w12 => Intl.message(
        'Search',
        name: 'w12',
      );
  String get w16 => Intl.message(
        'Search in notes',
        name: 'w16',
      );
  String get w17 => Intl.message(
        'Select Folder',
        name: 'w17',
      );
  String get w18 => Intl.message(
        'Set Reminder',
        name: 'w18',
      );
  String get w19 => Intl.message(
        'Delete Folder',
        name: 'w19',
      );
  String get w20 => Intl.message(
        'Are you sure you want to delete this folder and all of its notes?',
        name: 'w20',
      );
  String get w21 => Intl.message(
        'Edit Folder',
        name: 'w21',
      );
  String get w22 => Intl.message(
        'Notes',
        name: 'w22',
      );
  String get w23 => Intl.message(
        'Move',
        name: 'w23',
      );
  String get w24 => Intl.message(
        'Delete',
        name: 'w24',
      );
  String get w26 => Intl.message(
        'Settings',
        name: 'w26',
      );
  String get w27 => Intl.message(
        'How can we help?',
        name: 'w27',
      );
  String get w28 => Intl.message(
        'Report an issue',
        name: 'w28',
      );
  String get w29 => Intl.message(
        'Request a feature',
        name: 'w29',
      );
  String get w30 => Intl.message(
        'Report translation error',
        name: 'w30',
      );
  String get w31 => Intl.message(
        'Contribute to translation',
        name: 'w31',
      );
  String get w32 => Intl.message(
        'Select Language',
        name: 'w32',
      );
  String get w33 => Intl.message(
        'General',
        name: 'w33',
      );
  String get w34 => Intl.message(
        'Theme',
        name: 'w34',
      );
  String get w35 => Intl.message(
        'Font',
        name: 'w35',
      );
  String get w36 => Intl.message(
        'Language',
        name: 'w36',
      );
  String get w38 => Intl.message(
        'Edited (Newest First)',
        name: 'w38',
      );
  String get w39 => Intl.message(
        'Edited (Oldest First)',
        name: 'w39',
      );
  String get w40 => Intl.message(
        'Backup and Restore',
        name: 'w40',
      );
  String get w41 => Intl.message(
        'Backup to device storage',
        name: 'w41',
      );
  String get w42 => Intl.message(
        'Backed up data is located in the device\'s downloads folder as nf_backup.json. You can send it to another phone via email, bluetooth etc.',
        name: 'w42',
      );
  String get w43 => Intl.message(
        'Restore from device storage',
        name: 'w43',
      );
  String get w44 => Intl.message(
        'Please ensure the backup file located at device\'s downloads folder as nf_backup.json',
        name: 'w44',
      );
  String get w45 => Intl.message(
        'About',
        name: 'w45',
      );
  String get w46 => Intl.message(
        'Send feedback',
        name: 'w46',
      );
  String get w47 => Intl.message(
        'Rate it',
        name: 'w47',
      );
  String get w49 => Intl.message(
        'Successful',
        name: 'w49',
      );
  String get w50 => Intl.message(
        'An unknown error occurred',
        name: 'w50',
      );
  String get w52 => Intl.message(
        'An error occurred while reading file',
        name: 'w52',
      );
  String get w53 => Intl.message(
        'Backup file couldn\'t found',
        name: 'w53',
      );
  String get w54 => Intl.message(
        'Enjoying our app?',
        name: 'w54',
      );
  String get w55 => Intl.message(
        'Having trouble with notifications?',
        name: 'w55',
      );
  String get w56 => Intl.message(
        'Allow NoteFlow to run in the background to get notification on time',
        name: 'w56',
      );
  String get w57 => Intl.message(
        'System notification settings',
        name: 'w57',
      );
  String get w58 => Intl.message(
        'Notification sound',
        name: 'w58',
      );
  String get w60 => Intl.message(
        'Sort type',
        name: 'w60',
      );
  String get w66 => Intl.message(
        'Reminder canceled',
        name: 'w66',
      );
  String get w67 => Intl.message(
        'System',
        name: 'w67',
      );
  String get w68 => Intl.message(
        'Dark',
        name: 'w68',
      );
  String get w69 => Intl.message(
        'Light',
        name: 'w69',
      );
  String get w70 => Intl.message(
        'Select Theme',
        name: 'w70',
      );
  String get w71 => Intl.message(
        'Share',
        name: 'w71',
      );
  String get w72 => Intl.message(
        'Body',
        name: 'w72',
      );
  String get w73 => Intl.message(
        'Contribute',
        name: 'w73',
      );
  String get w74 => Intl.message(
        'Got it',
        name: 'w74',
      );
  String get w75 => Intl.message(
        'NoteFlow made by independent developer and it needs to be translated to other languages. So, If you want to contribute to the translation please email me from feedback section. It really helps to other people and also me :)',
        name: 'w75',
      );
  String get w76 => Intl.message(
        'Primary',
        name: 'w76',
      );
  String get w77 => Intl.message(
        'Accent',
        name: 'w77',
      );
  String get w78 => Intl.message(
        'Custom',
        name: 'w78',
      );
  String get w79 => Intl.message(
        'Clear',
        name: 'w79',
      );
  String get w80 => Intl.message(
        'Edit Label',
        name: 'w80',
      );
  String get w81 => Intl.message(
        'Create Label',
        name: 'w81',
      );
  String get w82 => Intl.message(
        'Label name',
        name: 'w82',
      );
  String get w83 => Intl.message(
        'Labels',
        name: 'w83',
      );
  String get w84 => Intl.message(
        'Unpin',
        name: 'w84',
      );
  String get w85 => Intl.message(
        'Pin',
        name: 'w85',
      );
  String get w86 => Intl.message(
        'Filter Notes',
        name: 'w86',
      );
  String get w89 => Intl.message(
        'Pinned',
        name: 'w89',
      );
  String get w90 => Intl.message(
        'Show only title on card',
        name: 'w90',
      );
  String get w91 => Intl.message(
        'Show labels in note and on card',
        name: 'w91',
      );
  String get w94 => Intl.message(
        'Select Labels',
        name: 'w94',
      );
  String get w95 => Intl.message(
        'Sort By',
        name: 'w95',
      );
  String get w96 => Intl.message(
        'Alphabetically (A-Z)',
        name: 'w96',
      );
  String get w97 => Intl.message(
        'Alphabetically (Z-A)',
        name: 'w97',
      );
  String get w98 => Intl.message(
        'Created (Newest First)',
        name: 'w98',
      );
  String get w99 => Intl.message(
        'Created (Oldest First)',
        name: 'w99',
      );
  String get w102 => Intl.message(
        'Note: If you already have backup file you need to override it. Otherwise, the system will create it as a new file that will consume your storage space unnecessarily. To override, simply tap on it and then press save button',
        name: 'w102',
      );
  String get w103 => Intl.message(
        'Select Color',
        name: 'w103',
      );
  String get w104 => Intl.message(
        'Today',
        name: 'w104',
      );
  String get w105 => Intl.message(
        'Unlock all fonts',
        name: 'w105',
      );
  String get w106 => Intl.message(
        'Unlock restore option',
        name: 'w106',
      );
  String get w107 => Intl.message(
        'Unlimited labels',
        name: 'w107',
      );
  String get w108 => Intl.message(
        'Android app widget',
        name: 'w108',
      );
  String get w109 => Intl.message(
        'Support Noteflow development',
        name: 'w109',
      );
  String get w110 => Intl.message(
        'Buy Now',
        name: 'w110',
      );
  String get w111 => Intl.message(
        'Get Premium',
        name: 'w111',
      );
  String get w112 => Intl.message(
        'As a sole developer behind this app, creating a top-notched experience requires dedication and time. Your Premium upgrade isn\'t just a feature unlock. Instead, it\'s a source of motivation that empowers me to continue expanding Noteflow.',
        name: 'w112',
      );
  String get w113 => Intl.message(
        'Need more labels to organize your notes? No problem!',
        name: 'w113',
      );
  String get w114 => Intl.message(
        'Bored of re-entering the app to see your notes? Just use widget!',
        name: 'w114',
      );
  String get w115 => Intl.message(
        'Noteflow relies on the support of its amazing users!',
        name: 'w115',
      );
  String get w116 => Intl.message(
        'This note is already exists',
        name: 'w116',
      );
  String get w117 => Intl.message(
        'Upgrade to premium',
        name: 'w117',
      );
  String get w118 => Intl.message(
        'Startup folder',
        name: 'w118',
      );
  String get w119 => Intl.message(
        'Select Note',
        name: 'w119',
      );
  String get w120 => Intl.message(
        'Your payment is pending',
        name: 'w120',
      );
  String get w121 => Intl.message(
        'Purchases restored',
        name: 'w121',
      );
  String get w122 => Intl.message(
        'Premium activated',
        name: 'w122',
      );
  String get w123 => Intl.message(
        'Tomorrow',
        name: 'w123',
      );
  String get w124 => Intl.message(
        'Couldn\'t fetch product details',
        name: 'w124',
      );
  String get w125 => Intl.message(
        'Check your internet connection',
        name: 'w125',
      );
  String get w126 => Intl.message(
        'Reset',
        name: 'w126',
      );
  String get w127 => Intl.message(
        'Cancel Reminder',
        name: 'w127',
      );
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  static AppLocalizations? instance;
  static const locales = ['en', 'tr'];

  @override
  bool isSupported(Locale locale) {
    return locales.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localization = await AppLocalizations.load(locale);
    instance = localization;

    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
