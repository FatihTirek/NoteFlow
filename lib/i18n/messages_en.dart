// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, always_declare_return_types

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(errorCode) => "Error code: ${errorCode}";

  static m1(version) => "Version ${version}";

  static m2(num) => "${Intl.plural(num, one: 'Delete Note', other: 'Delete Notes')}";

  static m3(num) => "${Intl.plural(num, one: 'Are you sure you want to delete this note?', other: 'Are you sure you want to delete selected notes?')}";

  static m4(num) => "${Intl.plural(num, one: 'Notification', other: 'Notifications')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {
    "m1" : m0,
    "m2" : m1,
    "p0" : m2,
    "p1" : m3,
    "p3" : m4,
    "w0" : MessageLookupByLibrary.simpleMessage("Yesterday"),
    "w1" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "w10" : MessageLookupByLibrary.simpleMessage("Reminder cannot set past"),
    "w102" : MessageLookupByLibrary.simpleMessage("Note: If you already have a backup file you should override it. Otherwise, system will create it as a new file that will consume your storage space unnecessarily. To override, simply tap on it and then press save button"),
    "w103" : MessageLookupByLibrary.simpleMessage("Select Color"),
    "w104" : MessageLookupByLibrary.simpleMessage("Today"),
    "w105" : MessageLookupByLibrary.simpleMessage("Unlock all fonts"),
    "w106" : MessageLookupByLibrary.simpleMessage("Unlock restore option"),
    "w107" : MessageLookupByLibrary.simpleMessage("Unlimited labels"),
    "w108" : MessageLookupByLibrary.simpleMessage("Android app widget"),
    "w109" : MessageLookupByLibrary.simpleMessage("Support Noteflow development"),
    "w11" : MessageLookupByLibrary.simpleMessage("Folders"),
    "w110" : MessageLookupByLibrary.simpleMessage("Buy Now"),
    "w111" : MessageLookupByLibrary.simpleMessage("Get Premium"),
    "w112" : MessageLookupByLibrary.simpleMessage("As a sole developer behind this app, creating a top-notched experience requires dedication and time. Your Premium upgrade isn\'t just a feature unlock. Instead, it\'s a source of motivation that empowers me to continue expanding Noteflow."),
    "w113" : MessageLookupByLibrary.simpleMessage("Need more labels to organize your notes? No problem!"),
    "w114" : MessageLookupByLibrary.simpleMessage("Bored of re-entering the app to see your notes? Just use widget!"),
    "w115" : MessageLookupByLibrary.simpleMessage("Noteflow relies on the support of its amazing users!"),
    "w116" : MessageLookupByLibrary.simpleMessage("This note is already exists"),
    "w117" : MessageLookupByLibrary.simpleMessage("Upgrade to premium"),
    "w118" : MessageLookupByLibrary.simpleMessage("Startup folder"),
    "w119" : MessageLookupByLibrary.simpleMessage("Select Note"),
    "w12" : MessageLookupByLibrary.simpleMessage("Search"),
    "w120" : MessageLookupByLibrary.simpleMessage("Your payment is pending"),
    "w121" : MessageLookupByLibrary.simpleMessage("Purchases restored"),
    "w122" : MessageLookupByLibrary.simpleMessage("Premium activated"),
    "w123" : MessageLookupByLibrary.simpleMessage("Tomorrow"),
    "w124" : MessageLookupByLibrary.simpleMessage("Couldn\'t fetch product details"),
    "w125" : MessageLookupByLibrary.simpleMessage("Check your internet connection"),
    "w126" : MessageLookupByLibrary.simpleMessage("Reset"),
    "w127" : MessageLookupByLibrary.simpleMessage("Cancel Reminder"),
    "w128": MessageLookupByLibrary.simpleMessage("Filter"),
    "w129": MessageLookupByLibrary.simpleMessage("Show only used labels in filter sections"),
    "w16" : MessageLookupByLibrary.simpleMessage("Search in notes"),
    "w17" : MessageLookupByLibrary.simpleMessage("Select Folder"),
    "w18" : MessageLookupByLibrary.simpleMessage("Set Reminder"),
    "w19" : MessageLookupByLibrary.simpleMessage("Delete Folder"),
    "w2" : MessageLookupByLibrary.simpleMessage("Done"),
    "w20" : MessageLookupByLibrary.simpleMessage("Are you sure you want to delete this folder and all of its notes?"),
    "w21" : MessageLookupByLibrary.simpleMessage("Edit Folder"),
    "w22" : MessageLookupByLibrary.simpleMessage("Notes"),
    "w23" : MessageLookupByLibrary.simpleMessage("Move"),
    "w24" : MessageLookupByLibrary.simpleMessage("Delete"),
    "w26" : MessageLookupByLibrary.simpleMessage("Settings"),
    "w27" : MessageLookupByLibrary.simpleMessage("How can we help?"),
    "w28" : MessageLookupByLibrary.simpleMessage("Report an issue"),
    "w29" : MessageLookupByLibrary.simpleMessage("Request a feature"),
    "w3" : MessageLookupByLibrary.simpleMessage("Folder name"),
    "w30" : MessageLookupByLibrary.simpleMessage("Report translation error"),
    "w31" : MessageLookupByLibrary.simpleMessage("Contribute to translation"),
    "w32" : MessageLookupByLibrary.simpleMessage("Select Language"),
    "w33" : MessageLookupByLibrary.simpleMessage("General"),
    "w34" : MessageLookupByLibrary.simpleMessage("Theme"),
    "w35" : MessageLookupByLibrary.simpleMessage("Font"),
    "w36" : MessageLookupByLibrary.simpleMessage("Language"),
    "w38" : MessageLookupByLibrary.simpleMessage("Edited (Newest First)"),
    "w39" : MessageLookupByLibrary.simpleMessage("Edited (Oldest First)"),
    "w4" : MessageLookupByLibrary.simpleMessage("Create Folder"),
    "w40" : MessageLookupByLibrary.simpleMessage("Backup and Restore"),
    "w41" : MessageLookupByLibrary.simpleMessage("Backup to device storage"),
    "w42" : MessageLookupByLibrary.simpleMessage("Backed up data is located in the device\'s downloads folder as nf_backup.json. You can send it to another phone via email, bluetooth etc."),
    "w43" : MessageLookupByLibrary.simpleMessage("Restore from device storage"),
    "w44" : MessageLookupByLibrary.simpleMessage("Please ensure the backup file located at device\'s downloads folder as nf_backup.json"),
    "w45" : MessageLookupByLibrary.simpleMessage("About"),
    "w46" : MessageLookupByLibrary.simpleMessage("Send feedback"),
    "w47" : MessageLookupByLibrary.simpleMessage("Rate it"),
    "w49" : MessageLookupByLibrary.simpleMessage("Successful"),
    "w5" : MessageLookupByLibrary.simpleMessage("All Notes"),
    "w50" : MessageLookupByLibrary.simpleMessage("An unknown error occurred"),
    "w52" : MessageLookupByLibrary.simpleMessage("An error occurred while reading file"),
    "w53" : MessageLookupByLibrary.simpleMessage("Backup file couldn\'t found"),
    "w54" : MessageLookupByLibrary.simpleMessage("Enjoying our app?"),
    "w55" : MessageLookupByLibrary.simpleMessage("Having trouble with notifications?"),
    "w56" : MessageLookupByLibrary.simpleMessage("Allow NoteFlow to run in the background to get notification on time"),
    "w57" : MessageLookupByLibrary.simpleMessage("System notification settings"),
    "w58" : MessageLookupByLibrary.simpleMessage("Notification sound"),
    "w6" : MessageLookupByLibrary.simpleMessage("Title"),
    "w60" : MessageLookupByLibrary.simpleMessage("Sort type"),
    "w66" : MessageLookupByLibrary.simpleMessage("Reminder canceled"),
    "w67" : MessageLookupByLibrary.simpleMessage("System"),
    "w68" : MessageLookupByLibrary.simpleMessage("Dark"),
    "w69" : MessageLookupByLibrary.simpleMessage("Light"),
    "w7" : MessageLookupByLibrary.simpleMessage("Type something..."),
    "w70" : MessageLookupByLibrary.simpleMessage("Select Theme"),
    "w71" : MessageLookupByLibrary.simpleMessage("Share"),
    "w72" : MessageLookupByLibrary.simpleMessage("Body"),
    "w73" : MessageLookupByLibrary.simpleMessage("Contribute"),
    "w74" : MessageLookupByLibrary.simpleMessage("Got it"),
    "w75" : MessageLookupByLibrary.simpleMessage("NoteFlow made by independent developer and it needs to be translated to other languages. If you want to contribute to the translation please email me from feedback section. It really helps to other people and also me :)"),
    "w76" : MessageLookupByLibrary.simpleMessage("Primary"),
    "w77" : MessageLookupByLibrary.simpleMessage("Accent"),
    "w78" : MessageLookupByLibrary.simpleMessage("Custom"),
    "w79" : MessageLookupByLibrary.simpleMessage("Clear"),
    "w8" : MessageLookupByLibrary.simpleMessage("Reminder set successfully"),
    "w80" : MessageLookupByLibrary.simpleMessage("Edit Label"),
    "w81" : MessageLookupByLibrary.simpleMessage("Create Label"),
    "w82" : MessageLookupByLibrary.simpleMessage("Label name"),
    "w83" : MessageLookupByLibrary.simpleMessage("Labels"),
    "w84" : MessageLookupByLibrary.simpleMessage("Unpin"),
    "w85" : MessageLookupByLibrary.simpleMessage("Pin"),
    "w86" : MessageLookupByLibrary.simpleMessage("Filter Notes"),
    "w89" : MessageLookupByLibrary.simpleMessage("Pinned"),
    "w9" : MessageLookupByLibrary.simpleMessage("Reminder cannot set for an empty note"),
    "w90" : MessageLookupByLibrary.simpleMessage("Show only title on card"),
    "w91" : MessageLookupByLibrary.simpleMessage("Show labels in note and on card"),
    "w94" : MessageLookupByLibrary.simpleMessage("Select Labels"),
    "w95" : MessageLookupByLibrary.simpleMessage("Sort By"),
    "w96" : MessageLookupByLibrary.simpleMessage("Alphabetically (A-Z)"),
    "w97" : MessageLookupByLibrary.simpleMessage("Alphabetically (Z-A)"),
    "w98" : MessageLookupByLibrary.simpleMessage("Created (Newest First)"),
    "w99" : MessageLookupByLibrary.simpleMessage("Created (Oldest First)")
  };
}
