import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:noteflow/theme/app_theme_state.dart';

import '../../models/note.dart';
import '../../services/note_service.dart';
import '../../utils.dart';
import '../../widgets/sheets/sort_type_picker.dart';
import '../widgets/shared/app_theme_controller.dart';

class FolderViewController with Utils {
  late List<Note> cachedNotes;

  ValueListenable listenable() => GetIt.I<NoteService>().listenable;

  List<Note> getNotesFromFolderID(NoteSortType noteSortType, String id) {
    final notes = GetIt.I<NoteService>().getFromFolderID(id);
    final result = GetIt.I<NoteService>().sort(notes, noteSortType);

    cachedNotes = result;
    return result;
  }

  void showSortPicker(WidgetRef ref) async {
    final value = await showSheet(ref.context, SortTypePicker(SortTypePickerMode.Note));
    if (value != null) ref.read(appThemeController.notifier).setNoteSortType(value);
  }
}
