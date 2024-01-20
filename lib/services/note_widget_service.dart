import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../controllers/widgets/shared/app_theme_controller.dart';
import '../i18n/localizations.dart';
import '../models/app_widget_launch_details.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../utils.dart';
import '../extensions/color_extension.dart';
import 'note_service.dart';

class NoteWidgetService with Utils {
  void initWidget(Note note, WidgetRef ref) async {
    if (!await isWidgetExist(note.id))
      channelMain.invokeMethod('initNoteWidget', _toMap(note, ref));
    else
      showToast(AppLocalizations.instance.w116);
  }

  void updateWidgetIfExist(Note note, WidgetRef ref) async {
    if (await isWidgetExist(note.id))
      channelMain.invokeMethod('updateNoteWidget', _toMap(note, ref));
  }

  void updateAppWidgetIfThemeChanged(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt('PlatformBrightness');
    final brightness = MediaQuery.of(ref.context).platformBrightness.index;

    if (value != null) {
      if (value != brightness) {
        GetIt.I<NoteService>().getAll().forEach((note) => updateWidgetIfExist(note, ref));
        prefs.setInt('PlatformBrightness', brightness);
      }
    } else {
      prefs.setInt('PlatformBrightness', brightness);
    }
  }

  void unlockWidget() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('UnlockWidget', true);
  }

  void unlockWidgetIfDonatedBefore(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('UnlockWidgetDonateChecked') ?? true) {
      final isPremium = ref.read(appThemeController).isPremium;
      await prefs.setBool('UnlockWidgetDonateChecked', true);
      if (isPremium) unlockWidget();
    }
  }

  void deleteWidgetIfExist(String id) async {
    if (await isWidgetExist(id)) channelMain.invokeMethod('deleteNoteWidget', id);
  }

  Future<NoteWidgetLaunchDetails> getLaunchDetails() async =>
      NoteWidgetLaunchDetails.fromMap(
          await channelMain.invokeMethod('getNoteWidgetLaunchDetails'));

  Future<bool> isWidgetExist(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final appWidgetID = prefs.getInt(id);

    return appWidgetID != null;
  }

  Map<String, dynamic> _toMap(Note note, WidgetRef ref) {
    final map = <String, dynamic>{};

    map['id'] = note.id;
    map['title'] = note.title;
    map['content'] = note.content;
    map['backgroundColor'] =
        getNoteBackgroundColor(ref, note.backgroundIndex, true).getHexValue();
    map['contentColor'] = note.backgroundIndex == null
        ? AppTheme.mediumEmphasise(ref.context, true).getHexValue()
        : AppTheme.onMediumEmphasise(ref.context, true).getHexValue();

    return map;
  }
}
