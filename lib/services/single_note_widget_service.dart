import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../controllers/widgets/shared/app_theme_controller.dart';
import '../i18n/localizations.dart';
import '../models/single_note_widget_launch_details.dart';
import '../models/note.dart';
import '../utils.dart';

class SingleNoteWidgetService with Utils {
  void initWidget(Note note, WidgetRef ref) async {
    if (!await isWidgetExist(note.id))
      channelMain.invokeMethod('initSingleNoteWidget', _toMap(note, ref));
    else
      showToast(AppLocalizations.instance.w116);
  }

  void updateWidgetIfExist(Note note, WidgetRef ref) async {
    if (await isWidgetExist(note.id))
      channelMain.invokeMethod('updateSingleNoteWidget', _toMap(note, ref));
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
    if (await isWidgetExist(id))
      channelMain.invokeMethod('deleteSingleNoteWidget', id);
  }

  Future<SingleNoteWidgetLaunchDetails> getLaunchDetails() async =>
      SingleNoteWidgetLaunchDetails.fromMap(
          await channelMain.invokeMethod('getSingleNoteWidgetLaunchDetails'));

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
    map['contentCIndex'] = note.backgroundIndex == null ? 0 : 1;
    map['backgroundCIndex'] = note.backgroundIndex == null ? 0: note.backgroundIndex! + 1;

    return map;
  }
}
