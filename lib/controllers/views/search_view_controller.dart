import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/note.dart';
import '../../services/note_service.dart';

class SearchViewController {
  final WidgetRef ref;

  late ValueNotifier<bool> showClearButton;
  late ValueNotifier<List<Note>> searchedNotes;

  late List<Note> cachedAllNotes;
  late TextEditingController textEditingController;

  SearchViewController(this.ref) {
    searchedNotes = ValueNotifier([]);
    showClearButton = ValueNotifier(false);
    textEditingController = TextEditingController();
    cachedAllNotes = GetIt.I<NoteService>().getAll();
  }

  void initState(bool mounted) {
    GetIt.I<NoteService>().listenable.addListener(() {
      if (mounted) cachedAllNotes = GetIt.I<NoteService>().getAll();
    });
  }

  void dispose() {
    textEditingController.dispose();
    GetIt.I<NoteService>().listenable.removeListener(() {});
  }

  void onChanged(String text) {
    showClearButton.value = text.isNotEmpty;
    searchedNotes.value = GetIt.I<NoteService>().search(text, cachedAllNotes);
  }

  void onTapClear() {
    textEditingController.clear();
    searchedNotes.value = [];
    showClearButton.value = false;
  }
}
