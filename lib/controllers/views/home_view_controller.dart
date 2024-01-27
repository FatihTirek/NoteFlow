import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../views/all_folders_view.dart';
import '../../views/all_labels_view.dart';
import '../../views/filter_view.dart';
import '../../views/search_view.dart';
import '../../views/settings.dart';
import '../../models/folder.dart';
import '../../models/note.dart';
import '../../services/folder_service.dart';
import '../../services/note_service.dart';
import '../../utils.dart';
import '../../widgets/sheets/sort_type_picker.dart';
import '../widgets/shared/app_theme_controller.dart';

class HomeViewController with Utils {
  final WidgetRef ref;

  late ValueNotifier<List<Note>> allNotes;
  late ValueNotifier<List<Folder>> allFolders;

  HomeViewController(this.ref) {
    allNotes = ValueNotifier(
      GetIt.I<NoteService>().sort(
        GetIt.I<NoteService>().getAll(),
        ref.read(appThemeController).noteSortType,
      ),
    );
    allFolders = ValueNotifier(GetIt.I<FolderService>().getAllSorted(ref.read(appThemeController).folderSortType));
  }

  void initState(bool mounted) {
    ref.listenManual(appThemeController, (previous, next) {
      if (previous?.folderSortType != next.folderSortType)
        allFolders.value = GetIt.I<FolderService>().getAllSorted(next.folderSortType);

      if (previous?.noteSortType != next.noteSortType)
        allNotes.value = GetIt.I<NoteService>().sort(allNotes.value, next.noteSortType);
    });

    GetIt.I<FolderService>().listenable.addListener(() {
      if (mounted)
        allFolders.value = GetIt.I<FolderService>().getAllSorted(ref.read(appThemeController).folderSortType);
    });

    GetIt.I<NoteService>().listenable.addListener(() {
      if (mounted) {
        allNotes.value = GetIt.I<NoteService>().sort(
          GetIt.I<NoteService>().getAll(),
          ref.read(appThemeController).noteSortType,
        );
      }
    });
  }

  void dispose() {
    GetIt.I<FolderService>().listenable.removeListener(() {});
    GetIt.I<NoteService>().listenable.removeListener(() {});
  }

  List<Note> getNotesFromFolderID(String? id) => id != null ? allNotes.value.where((note) => note.folderID == id).toList() : allNotes.value;

  List<Note> getCurrentNotes(int index) => getNotesFromFolderID(index == 0 ? null : allFolders.value[index - 1].id);

  int getStartupFolderIndex() {
    final folderID = ref.read(appThemeController).startupFolderID;

    if (folderID == null) return 0;
    return allFolders.value.indexWhere((folder) => folder.id == folderID) + 1;
  }

  void showSortPicker() async {
    final value = await showSheet(ref.context, SortTypePicker(SortTypePickerMode.Note));
    if (value != null) ref.read(appThemeController.notifier).setNoteSortType(value);
  }

  void goAllFoldersView() => goToView(AllFoldersView());

  void goAllLabelsView() => goToView(AllLabelsView());

  void goSettingsView() => goToView(SettingsView());

  void goFilterView() => goToView(FilterView());

  void goSearchView() => goToView(SearchView());
}
