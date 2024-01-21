import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/note.dart';
import '../../services/note_service.dart';
import '../widgets/shared/app_theme_controller.dart';

class FolderViewController {
  late List<Note> cachedNotes;

  ValueListenable listenable() => GetIt.I<NoteService>().listenable;

  List<Note> getNotesFromFolderID(WidgetRef ref, String id) {
    final notes = GetIt.I<NoteService>().getFromFolderID(id);
    final result = GetIt.I<NoteService>().sort(notes, ref.read(appThemeController).noteSortType);

    cachedNotes = result;
    return result;
  }
}
