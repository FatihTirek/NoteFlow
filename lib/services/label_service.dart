import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import '../models/label.dart';
import '../theme/app_theme_state.dart';
import 'note_service.dart';

class LabelService {
  ValueListenable get listenable => Hive.box(StringConstants.dbLabels).listenable();

  Future init() => Hive.openBox(StringConstants.dbLabels);

  Label get(String id) => Label.fromMap(Hive.box(StringConstants.dbLabels).get(id));

  List<Label> getAllFromIDs(List<String> ids) => ids.map((e) => get(e)).toList();

  List<Label> getAll() => Hive.box(StringConstants.dbLabels).values.map((e) => Label.fromMap(e)).toList();

  List<Label> getAllSorted(LabelSortType labelSortType) {
    return getAll()
      ..sort((a, b) {
        switch (labelSortType) {
          case LabelSortType.AlphabeticallyAZ:
            return a.name.compareTo(b.name);
          case LabelSortType.AlphabeticallyZA:
            return b.name.compareTo(a.name);
          case LabelSortType.CreatedNF:
            return b.created.compareTo(a.created);
          case LabelSortType.CreatedOF:
            return a.created.compareTo(b.created);
        }
      });
  }

  List<Map> getAllRaw() => Hive.box(StringConstants.dbLabels).values.toList().cast<Map>();

  void write(Label label) => Hive.box(StringConstants.dbLabels).put(label.id, label.toMap());

  void delete(String id) {
    Hive.box(StringConstants.dbLabels).delete(id);
    GetIt.I<NoteService>().getAllFromLabelIDs([id]).forEach((note) {
      GetIt.I<NoteService>().write(note.removeLabel(id));
    });
  }

  List<Label> search(String text, List<Label> items) {
    final trimmed = text.trim().toLowerCase();
    final contains = (String s) => s.toLowerCase().contains(trimmed);

    if (trimmed.isNotEmpty) return items.where((label) => contains(label.name)).toList();

    return [];
  }
}
