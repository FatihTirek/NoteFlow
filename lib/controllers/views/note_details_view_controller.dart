import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../models/label.dart';
import '../../services/label_service.dart';
import '../../widgets/dialogs/delete_dialog.dart';
import '../../widgets/sheets/folder_picker.dart';
import '../../widgets/sheets/label_picker.dart';
import '../../widgets/sheets/note_background_picker.dart';
import '../../widgets/sheets/reminder_picker.dart';
import '../../i18n/localizations.dart';
import '../../models/app_widget_launch_details.dart';
import '../../models/note.dart';
import '../../services/note_service.dart';
import '../../services/note_widget_service.dart';
import '../../services/folder_service.dart';
import '../../utils.dart';
import '../main_controller.dart';

class NoteDetailsViewController with Utils {
  final WidgetRef ref;
  final AnimationController animationController;

  late ValueNotifier<bool> pinned;
  late ValueNotifier<bool> anyFocus;
  late ValueNotifier<String?> selectedFolderID;
  late ValueNotifier<Color?> selectedTitleColor;
  late ValueNotifier<DateTime?> selectedReminder;
  late ValueNotifier<Color?> selectedContentColor;
  late ValueNotifier<int?> selectedBackgroundIndex;
  late ValueNotifier<List<String>> selectedLabelIDs;

  late String currentNoteID;
  late bool isPreviouslySaved;
  late DateTime currentCreated;
  late FutureOr<int> currentNotificationID;
  late TextEditingController titleController;
  late TextEditingController contentController;
  late UndoHistoryController titleHistoryController;
  late UndoHistoryController contentHistoryController;

  NoteDetailsViewController(
    this.ref,
    Note? note,
    String? folderID,
    this.animationController,
  ) {
    anyFocus = ValueNotifier(false);
    pinned = ValueNotifier(note?.pinned ?? false);
    selectedReminder = ValueNotifier(note?.reminder);
    selectedTitleColor = ValueNotifier(note?.titleColor);
    selectedLabelIDs = ValueNotifier(note?.labelIDs ?? []);
    selectedContentColor = ValueNotifier(note?.contentColor);
    selectedFolderID = ValueNotifier(folderID ?? note?.folderID);
    selectedBackgroundIndex = ValueNotifier(note?.backgroundIndex);

    currentNoteID = note?.id ?? Uuid().v4();
    isPreviouslySaved = note?.id != null;
    currentCreated = note?.created ?? DateTime.now();
    titleHistoryController = UndoHistoryController();
    contentHistoryController = UndoHistoryController();
    titleController = TextEditingController(text: note?.title);
    contentController = TextEditingController(text: note?.content);
    currentNotificationID = (note?.notificationID ??
        GetIt.I<NoteService>().generateNotificationID()) as FutureOr<int>;
  }

  List<Label> getCurrentLabels() =>
      GetIt.I<LabelService>().getFromIDs(selectedLabelIDs.value);

  void dispose() {
    titleController.dispose();
    contentController.dispose();
    animationController.dispose();
    titleHistoryController.dispose();
    contentHistoryController.dispose();
  }

  void onTapExit({bool write = true}) {
    if (write) _writeOrDeleteOrPass(schedule: true, update: true);

    final value = notificationAppLaunchDetails!.didNotificationLaunchApp ||
        noteWidgetLaunchDetails.launchAction != NoteWidgetLaunchAction.None;

    if (value)
      SystemNavigator.pop();
    else
      Navigator.pop(ref.context);
  }

  void onTapPin() {
    pinned.value = !pinned.value;
    _writeOrDeleteOrPass();
  }

  void onTapReminder() async {
    final value = selectedReminder.value?.isAfter(DateTime.now()) ?? false
        ? selectedReminder.value
        : null;

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
        .requestExactAlarmsPermission();

    final datetime = await showSheet(ref.context, ReminderPicker(reminder: value));

    if (datetime != null) {
      if (datetime == 'clear') {
        flutterLocalNotificationsPlugin.cancel(await currentNotificationID);
        selectedReminder.value = null;
        _writeOrDeleteOrPass();

        showToast(AppLocalizations.instance.w66);
      } else {
        if (datetime.isAfter(DateTime.now())) {
          final title = titleController.text.trim();
          final content = contentController.text.trim();

          if (title.isNotEmpty || content.isNotEmpty) {
            selectedReminder.value = datetime;
            _writeOrDeleteOrPass(schedule: true);

            showToast(AppLocalizations.instance.w8);
          } else {
            showToast(AppLocalizations.instance.w9);
          }
        } else {
          showToast(AppLocalizations.instance.w10);
        }
      }
    }
  }

  void onTapFolder() async {
    final value =
        await showSheet(ref.context, FolderPicker(folderID: selectedFolderID.value));

    if (value != null && selectedFolderID.value != value) {
      if (isPreviouslySaved) {
        GetIt.I<FolderService>().updateCountIfNeeded(selectedFolderID.value);
        if (value != StringConstants.clearFlag)
          GetIt.I<FolderService>().updateCountIfNeeded(value, increase: true);
      }

      if (value == StringConstants.clearFlag)
        selectedFolderID.value = null;
      else
        selectedFolderID.value = value;

      _writeOrDeleteOrPass(schedule: true);
    }
  }

  void onTapLabel() async {
    final value =
        await showSheet(ref.context, LabelPicker(labelIDs: selectedLabelIDs.value));

    if (value != null && value != selectedLabelIDs.value) {
      selectedLabelIDs.value = value;
      _writeOrDeleteOrPass();
    }
  }

  void onTapShare() {
    final text =
        '${AppLocalizations.instance.w6}: ${titleController.text} \n${AppLocalizations.instance.w72}: ${contentController.text}';
    Share.share(text, subject: titleController.text);
  }

  void onTapDelete() {
    showModal(
      context: ref.context,
      builder: (_) => DeleteDialog(
        title: AppLocalizations.instance.p0(1),
        content: AppLocalizations.instance.p1(1),
        onDelete: () async {
          if (isPreviouslySaved) {
            GetIt.I<NoteService>().delete(currentNoteID, await currentNotificationID);
            GetIt.I<FolderService>().updateCountIfNeeded(selectedFolderID.value);
          }

          onTapExit(write: false);
        },
      ),
    );
  }

  void onTapBackground() async {
    final result = await showSheet(
      ref.context,
      NoteBackgroundPicker(
        titleColor: selectedTitleColor.value,
        contentColor: selectedContentColor.value,
        backgroundIndex: selectedBackgroundIndex.value,
      ),
    );

    if (result != null) {
      final map = {
        'titleColor': selectedTitleColor.value,
        'contentColor': selectedContentColor.value,
        'backgroundIndex': selectedBackgroundIndex.value,
      };

      if (!mapEquals(result, map)) {
        selectedTitleColor.value = result['titleColor'];
        selectedContentColor.value = result['contentColor'];
        selectedBackgroundIndex.value = result['backgroundIndex'];

        _writeOrDeleteOrPass(update: true);
      }
    }
  }

  void onTapTextField() async {
    if (!anyFocus.value) {
      await animationController.reverse();
      anyFocus.value = true;
      await animationController.forward();
    }
  }

  void onKeyboardClose() async {
    FocusScope.of(ref.context).unfocus();
    await animationController.reverse();
    anyFocus.value = false;
    await animationController.forward();
    _writeOrDeleteOrPass(schedule: true, update: true);
  }

  void _writeOrDeleteOrPass({bool schedule = false, bool update = false}) async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    final currentlyHasText = title.isNotEmpty || content.isNotEmpty;

    if (currentlyHasText) {
      final note = Note(
        title: title,
        content: content,
        id: currentNoteID,
        pinned: pinned.value,
        edited: DateTime.now(),
        created: currentCreated,
        folderID: selectedFolderID.value,
        reminder: selectedReminder.value,
        labelIDs: selectedLabelIDs.value,
        titleColor: selectedTitleColor.value,
        contentColor: selectedContentColor.value,
        notificationID: await currentNotificationID,
        backgroundIndex: selectedBackgroundIndex.value,
      );

      if (!isPreviouslySaved) {
        isPreviouslySaved = true;
        GetIt.I<FolderService>()
            .updateCountIfNeeded(selectedFolderID.value, increase: true);
      }

      GetIt.I<NoteService>().write(note);

      if (schedule) GetIt.I<NoteService>().scheduleNotification(note, ref);
      if (update) GetIt.I<NoteWidgetService>().updateWidgetIfExist(note, ref);
    } else if (isPreviouslySaved && !currentlyHasText) {
      isPreviouslySaved = false;
      GetIt.I<NoteService>().delete(currentNoteID, await currentNotificationID);
      GetIt.I<FolderService>().updateCountIfNeeded(selectedFolderID.value);
    }
  }
}
