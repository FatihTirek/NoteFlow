import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/folder.dart';
import '../theme/app_theme_state.dart';
import 'note_service.dart';

class FolderService {
  ValueListenable get listenable => Hive.box(StringConstants.dbFolders).listenable();

  Future init() => Hive.openBox(StringConstants.dbFolders);

  Folder get(String id) => Folder.fromMap(Hive.box(StringConstants.dbFolders).get(id));

  List<Folder> getAll() => Hive.box(StringConstants.dbFolders).values.map((e) => Folder.fromMap(e)).toList();

  List<Map> getAllRaw() => Hive.box(StringConstants.dbFolders).values.toList().cast<Map>();

  List<Folder> getAllSorted(FolderSortType folderSortType) {
    return getAll()
      ..sort((a, b) {
        switch (folderSortType) {
          case FolderSortType.AlphabeticallyAZ:
            return a.name.compareTo(b.name);
          case FolderSortType.AlphabeticallyZA:
            return b.name.compareTo(a.name);
          case FolderSortType.CreatedNF:
            return b.created.compareTo(a.created);
          case FolderSortType.CreatedOF:
            return a.created.compareTo(b.created);
        }
      });
  }

  void write(Folder folder) => Hive.box(StringConstants.dbFolders).put(folder.id, folder.toMap());

  void delete(String id) {
    Hive.box(StringConstants.dbFolders).delete(id);
    GetIt.I<NoteService>().deleteFromFolderID(id);
  }

  void updateCountIfNeeded(String? id, {bool increase = false}) {
    if (id != null) {
      final folder = get(id);
      write(increase ? folder.increaseNumber() : folder.decreaseNumber());
    }
  }

  List<Folder> search(String text, List<Folder> items) {
    final trimmed = text.trim().toLowerCase();
    final contains = (String s) => s.toLowerCase().contains(trimmed);

    if (trimmed.isNotEmpty) return items.where((folder) => contains(folder.name)).toList();

    return [];
  }

  Future<void> migrateIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final isMigratedV1 = prefs.getBool('migrations.folder.MIGRATED_V1') ?? false;

    if (!isMigratedV1) {
      getAll().forEach((folder) {
        final notes = GetIt.I<NoteService>().getAllFromFolderID(folder.id);
        write(folder.copyWith(numberOfNotes: notes.length));
      });

      prefs.setBool('migrations.folder.MIGRATED_V1', true);
    }
  }
}
