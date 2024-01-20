import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/label.dart';
import '../../models/note.dart';
import '../../services/label_service.dart';
import '../../services/note_service.dart';
import '../widgets/shared/app_theme_controller.dart';

class FilterViewController {
  late ValueNotifier<List<String>> selectedLabelIDs;
  late ValueNotifier<List<int?>> selectedBackgroundIndexes;

  late List<Note> cachedNotes;

  FilterViewController() {
    selectedLabelIDs = ValueNotifier([]);
    selectedBackgroundIndexes = ValueNotifier([]);
  }

  ValueListenable labelListenable() => GetIt.I<LabelService>().listenable;

  ValueListenable noteListenable() => GetIt.I<NoteService>().listenable;

  List<Label> getAllLabels(WidgetRef ref) =>
      GetIt.I<LabelService>().getAllAndSort(ref.read(appThemeController).labelSortType);

  List<Note> getNotesFromBackgroundIndexesAndLabelIDs(WidgetRef ref) {
    final notes = GetIt.I<NoteService>().getFromBgIndexesAndLabelIDs(
        selectedLabelIDs.value, selectedBackgroundIndexes.value);
    final result =
        GetIt.I<NoteService>().sort(notes, ref.read(appThemeController).noteSortType);

    cachedNotes = result;
    return result;
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
