import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../constants.dart';
import '../../models/folder.dart';
import '../../models/label.dart';
import '../../views/premium_view.dart';
import '../../widgets/dialogs/feedback_dialog.dart';
import '../../widgets/dialogs/language_picker.dart';
import '../../widgets/dialogs/theme_picker.dart';
import '../../widgets/sheets/folder_picker.dart';
import '../../widgets/sheets/font_picker.dart';
import '../../i18n/localizations.dart';
import '../../models/note.dart';
import '../../services/folder_service.dart';
import '../../services/label_service.dart';
import '../../services/note_service.dart';
import '../../utils.dart';
import '../../widgets/sheets/sort_type_picker.dart';
import '../main_controller.dart';
import '../widgets/shared/app_theme_controller.dart';

class SettingsViewController with Utils {
  final WidgetRef ref;

  const SettingsViewController(this.ref);

  void pop() => Navigator.pop(ref.context);

  void goPremiumView() => goToView(PremiumView());

  void showFeedbackDialog() =>
      showModal(context: ref.context, builder: (_) => FeedBackDialog());

  void showThemePicker() =>
      showModal(context: ref.context, builder: (_) => ThemePicker(ref));

  void showLanguagePicker() =>
      showModal(context: ref.context, builder: (_) => LanguagePicker(ref));

  void showFontPicker() => showSheet(ref.context, FontPicker());

  void showSortPicker() async {
    final value = await showSheet(ref.context, SortTypePicker(SortTypePickerMode.Note));
    if (value != null) ref.read(appThemeController.notifier).setNoteSortType(value);
  }

  void openNotificationSettings() => channelMain.invokeMethod('openNotificationSettings');

  void openStore() => StoreRedirect.redirect();

  void ignoreBatteryOptimizations() async {
    if (!await Permission.ignoreBatteryOptimizations.isGranted)
      Permission.ignoreBatteryOptimizations.request();
  }

  void changeNotificationSound() async {
    final soundUri = await channelMain
        .invokeMethod('getSoundUri', {'soundUri': ref.read(appThemeController).soundUri});
    if (soundUri != null) ref.read(appThemeController.notifier).setSoundUri(soundUri);
  }

  void changeStartupFolder() async {
    final id = ref.read(appThemeController).startupFolderID;
    final value = await showSheet(ref.context, FolderPicker(folderID: id));

    if (value != null) {
      if (value == StringConstants.clearFlag)
        ref.read(appThemeController.notifier).setStartupFolderID(null);
      else
        ref.read(appThemeController.notifier).setStartupFolderID(value);
    }
  }

  void onTapBackup() async {
    if (await _isGranted()) {
      final map = <String, dynamic>{};

      map[StringConstants.dbNotes] = GetIt.I<NoteService>().getAllRaw();
      map[StringConstants.dbLabels] = GetIt.I<LabelService>().getAllRaw();
      map[StringConstants.dbFolders] = GetIt.I<FolderService>().getAllRaw();

      if (androidDeviceInfo.version.sdkInt >= 30) {
        await channelMain.invokeMethod('createFile', {
          'json': jsonEncode(map),
          'error': AppLocalizations.instance.w50,
          'success': AppLocalizations.instance.w49,
        });
      } else {
        final file = File('/storage/emulated/0/Download/nf_backup.json');
        await file.create(recursive: true)
          ..writeAsString(jsonEncode(map)).then(
            (_) => showToast(AppLocalizations.instance.w49),
            onError: (_) => showToast(AppLocalizations.instance.w50),
          );
      }
    }
  }

  void onTapRestore() async {
    final isPremiumUser =
        await ref.read(appThemeController.notifier).isPremiumUser(ref.context);

    if (isPremiumUser && await _isGranted()) {
      final file = File('/storage/emulated/0/Download/nf_backup.json');

      if (await file.exists()) {
        Map json;

        if (androidDeviceInfo.version.sdkInt >= 30)
          json = jsonDecode(await channelMain.invokeMethod('openFile'));
        else
          json = jsonDecode(await file.readAsString());

        json[StringConstants.dbNotes].forEach((e) async {
          final note = Note.fromMap(e);

          if (note.reminder?.isAfter(DateTime.now()) ?? false) {
            final copy = note.copyWith(
                notificationID: await GetIt.I<NoteService>().generateNotificationID());
            GetIt.I<NoteService>().scheduleNotification(copy, ref);
          }

          GetIt.I<NoteService>().write(note);
        });
        json[StringConstants.dbFolders]
            .forEach((e) => GetIt.I<FolderService>().write(Folder.fromMap(e)));
        json[StringConstants.dbLabels]
            .forEach((e) => GetIt.I<LabelService>().write(Label.fromMap(e)));

        showToast(AppLocalizations.instance.w49);
      } else {
        showToast(AppLocalizations.instance.w53);
      }
    }
  }

  Future<bool> _isGranted() async {
    if (androidDeviceInfo.version.sdkInt < 33) {
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
        if (await Permission.storage.isGranted) return true;
      }

      return true;
    }

    return true;
  }
}
