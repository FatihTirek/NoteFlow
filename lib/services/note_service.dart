import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as timezone;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../controllers/main_controller.dart';
import '../controllers/widgets/shared/app_theme_controller.dart';
import '../i18n/localizations.dart';
import '../models/note.dart';
import '../theme/app_theme_state.dart';
import '../utils.dart';
import 'folder_service.dart';
import 'note_widget_service.dart';

class NoteService with Utils {
  ValueListenable get listenable => Hive.box(StringConstants.dbNotes).listenable();

  Future init() => Hive.openBox(StringConstants.dbNotes);

  Note get(String id) => Note.fromMap(Hive.box(StringConstants.dbNotes).get(id));

  List<Note> getAll() =>
      Hive.box(StringConstants.dbNotes).values.map((e) => Note.fromMap(e)).toList();

  List<Map> getAllRaw() => Hive.box(StringConstants.dbNotes).values.toList().cast<Map>();

  List<Note> getFromFolderID(String id) =>
      getAll().where((note) => note.folderID == id).toList();

  List<Note> getFromLabelIDs(List<String> ids) {
    if (ids.isEmpty) return [];
    return getAll().where((note) => note.labelIDs.toSet().containsAll(ids)).toList();
  }

  List<Note> getFromBgIndexesAndLabelIDs(List<String> ids, List<int?> indexes) {
    if (ids.isNotEmpty || indexes.isNotEmpty) {
      bool Function(Note note) test;

      if (ids.isEmpty)
        test = (note) => indexes.contains(note.backgroundIndex);
      else if (indexes.isEmpty)
        test = (note) => note.labelIDs.toSet().containsAll(ids);
      else
        test = (note) =>
            indexes.contains(note.backgroundIndex) &&
            note.labelIDs.toSet().containsAll(ids);

      return getAll().where(test).toList();
    }

    return [];
  }

  void write(Note note) => Hive.box(StringConstants.dbNotes).put(note.id, note.toMap());

  void delete(String id, int notificationID) {
    Hive.box(StringConstants.dbNotes).delete(id);
    GetIt.I<NoteWidgetService>().deleteWidgetIfExist(id);
    flutterLocalNotificationsPlugin.cancel(notificationID);
  }

  void deleteFromFolderID(String id) =>
      getFromFolderID(id).forEach((note) => delete(note.id, note.notificationID));

  List<Note> sort(List<Note> notes, NoteSortType noteSortType) {
    return [...notes]..sort((a, b) {
        switch (noteSortType) {
          case NoteSortType.CreatedNF:
            return b.created.compareTo(a.created);
          case NoteSortType.CreatedOF:
            return a.created.compareTo(b.created);
          case NoteSortType.EditedNF:
            return b.edited.compareTo(a.edited);
          case NoteSortType.EditedOF:
            return a.edited.compareTo(b.edited);
          case NoteSortType.Pinned:
            if (a.pinned == b.pinned)
              return 0;
            else if (a.pinned)
              return -1;
            else
              return 1;
        }
      });
  }

  List<Note> search(String text, List<Note> items) {
    final trimmed = text.trim().toLowerCase();
    final contains = (String s) => s.toLowerCase().contains(trimmed);

    if (trimmed.isNotEmpty) {
      return items
          .where((note) => contains(note.title) || contains(note.content))
          .toList();
    }

    return [];
  }

  void scheduleNotification(Note note, WidgetRef ref) {
    if (note.reminder != null && note.reminder!.isAfter(DateTime.now())) {
      final soundUri = ref.read(appThemeController).soundUri;
      final Int64List vibrationPattern = Int64List(5);
      vibrationPattern[0] = 0;
      vibrationPattern[1] = 250;
      vibrationPattern[2] = 250;
      vibrationPattern[3] = 250;
      vibrationPattern[4] = 250;

      final details = AndroidNotificationDetails(
        'Note_Notification_ID',
        AppLocalizations.instance.w22,
        ledOnMs: 1000,
        ledOffMs: 1000,
        showWhen: true,
        playSound: true,
        autoCancel: true,
        enableLights: true,
        enableVibration: true,
        priority: Priority.high,
        ledColor: Colors.white,
        importance: Importance.high,
        vibrationPattern: vibrationPattern,
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.reminder,
        color: getNoteBackgroundColor(ref, note.backgroundIndex, true),
        sound: soundUri != null ? UriAndroidNotificationSound(soundUri) : null,
        styleInformation: BigTextStyleInformation(
          note.content.isEmpty ? note.title : note.content,
          contentTitle: note.title.isEmpty ? note.content : note.title,
          summaryText: note.folderID != null
              ? GetIt.I<FolderService>().get(note.folderID!).name
              : null,
        ),
      );

      flutterLocalNotificationsPlugin.zonedSchedule(
        note.notificationID,
        note.title.isEmpty ? note.content : note.title,
        note.content.isEmpty ? note.title : note.content,
        timezone.TZDateTime.from(note.reminder!, timezone.local),
        NotificationDetails(android: details),
        payload: jsonEncode(note.id),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<int> generateNotificationID() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt('Notification_ID') ?? -65536;

    if (value == 65536) {
      prefs.setInt('Notification_ID', -65536);
      return -65536;
    }

    prefs.setInt('Notification_ID', value + 1);
    return value;
  }
}
