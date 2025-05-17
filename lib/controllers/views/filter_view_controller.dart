import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:noteflow/theme/app_theme_state.dart';

import '../../models/folder.dart';
import '../../models/label.dart';
import '../../models/note.dart';
import '../../services/label_service.dart';
import '../../services/note_service.dart';
import '../../utils.dart';
import '../../widgets/sheets/sort_type_picker.dart';
import '../widgets/shared/app_theme_controller.dart';

class FilterViewController with Utils {
  late Folder? folder;
  late ValueNotifier<NoteSortType> selectedSortType;
  late ValueNotifier<List<String>> selectedLabelIDs;
  late ValueNotifier<List<int?>> selectedBackgroundIndexes;

  // This is done purely for performance reasons. On the first page load, getOnlyUsedLabels() runs before 
  // getFilteredNotes(). Afterwards, the order of these calls reverses. However, I'm not certain if this order is 
  // guaranteed to always be the same. Either way, this won't break the app, only cause minor inconvenience.
  bool isGetOnlyUsedLabelsEverRun = false;

  List<Note> cachedAllNotesOfCurrentPage = [];
  List<Note> cachedCurrentDisplayedNotes = [];

  FilterViewController(WidgetRef ref, Folder? folder) {
    this.folder = folder;
    selectedLabelIDs = ValueNotifier([]);
    selectedBackgroundIndexes = ValueNotifier([]);
    selectedSortType = ValueNotifier(ref.read(appThemeController).noteSortType);
  }

  ValueListenable noteListenable() => GetIt.I<NoteService>().listenable;

  List<Label> getAllLabels(WidgetRef ref) => GetIt.I<LabelService>().getAllSorted(ref.read(appThemeController).labelSortType);

  List<Label> getOnlyUsedLabels(WidgetRef ref) {
    final usedLabelIDs = <String>{};

    if (!isGetOnlyUsedLabelsEverRun) {
      cachedAllNotesOfCurrentPage = folder != null 
        ? GetIt.I<NoteService>().getAllFromFolderID(folder!.id) 
        : GetIt.I<NoteService>().getAll();
      isGetOnlyUsedLabelsEverRun = true;
    }

    for (final note in cachedAllNotesOfCurrentPage) {
      usedLabelIDs.addAll(note.labelIDs);
    }

    return getAllLabels(ref).where((label) => usedLabelIDs.contains(label.id)).toList();
  }

  List<Note> getFilteredNotes() {
    cachedAllNotesOfCurrentPage = folder != null 
      ? GetIt.I<NoteService>().getAllFromFolderID(folder!.id) 
      : GetIt.I<NoteService>().getAll();

    List<Note> result = folder != null ? cachedAllNotesOfCurrentPage : [];

    if (selectedLabelIDs.value.isNotEmpty || selectedBackgroundIndexes.value.isNotEmpty) {
      result = cachedAllNotesOfCurrentPage.where((note) {
        if (selectedLabelIDs.value.isEmpty)
          return selectedBackgroundIndexes.value.contains(note.backgroundIndex);
        else if (selectedBackgroundIndexes.value.isEmpty)
          return note.labelIDs.toSet().containsAll(selectedLabelIDs.value);
        else
          return selectedBackgroundIndexes.value.contains(note.backgroundIndex) && note.labelIDs.toSet().containsAll(selectedLabelIDs.value);
      }).toList();
    }

    result = GetIt.I<NoteService>().sort(result, selectedSortType.value);
    cachedCurrentDisplayedNotes = result;
    return result;
  }

  void showSortPicker(WidgetRef ref) async {
    final value = await showSheet(ref.context, SortTypePicker(SortTypePickerMode.Note, initialSortType: selectedSortType.value));
    if (value != null) selectedSortType.value = value as NoteSortType;
  }

  void onSelectLabel(bool selected, Label label) {
    final list = [...selectedLabelIDs.value];

    if (selected)
      list.add(label.id);
    else
      list.remove(label.id);

    selectedLabelIDs.value = list;
  }

  void onSelectColor(bool contains, int? index) {
    final list = [...selectedBackgroundIndexes.value];

    if (!contains)
      list.add(index);
    else
      list.remove(index);

    selectedBackgroundIndexes.value = list;
  }
}
