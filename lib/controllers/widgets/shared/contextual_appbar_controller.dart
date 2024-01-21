import 'package:animations/animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../constants.dart';
import '../../../services/folder_service.dart';
import '../../../widgets/sheets/folder_picker.dart';
import '../../../i18n/localizations.dart';
import '../../../models/note.dart';
import '../../../services/note_service.dart';
import '../../../utils.dart';
import '../../../widgets/dialogs/delete_dialog.dart';

class ContextualAppBarState {
  final List<Note> notes;
  final bool active;

  const ContextualAppBarState({required this.notes, this.active = false});

  ContextualAppBarState copyWith({List<Note>? notes, bool? active}) {
    return ContextualAppBarState(
      notes: notes ?? this.notes,
      active: active ?? this.active,
    );
  }
}

class ContextualBarController extends AutoDisposeNotifier<ContextualAppBarState> with Utils {
  @override
  ContextualAppBarState build() => ContextualAppBarState(notes: []);

  void closeBarIfNeeded() {
    if (state.active) closeBar();
  }

  void openBar() => state = state.copyWith(active: true);

  void closeBar() => state = state.copyWith(active: false, notes: []);

  void onTapCard(Note note) {
    if (state.notes.contains(note))
      state = state.copyWith(notes: state.notes..remove(note));
    else
      state = state.copyWith(notes: state.notes..add(note));
  }

  void onTapSelectAll(List<Note> notes) {
    if (notes.length == state.notes.length)
      state = state.copyWith(notes: []);
    else
      state = state.copyWith(notes: notes);
  }

  void onTapPin() {
    state.notes.forEach((note) {
      GetIt.I<NoteService>().write(note.copyWith(edited: DateTime.now(), pinned: true));
    });

    closeBar();
  }

  void onTapMove(WidgetRef ref) async {
    final value = await showSheet(ref.context, FolderPicker());

    if (value != null) {
      state.notes.forEach((note) {
        if (note.folderID != value) {
          final result = note.copyWith(folderID: value, acceptNullFolderID: value == StringConstants.clearFlag);

          GetIt.I<NoteService>().write(result);
          GetIt.I<FolderService>().updateCountIfNeeded(note.folderID);

          if (value != StringConstants.clearFlag) GetIt.I<FolderService>().updateCountIfNeeded(value, increase: true);
        }
      });

      closeBar();
    }
  }

  void onTapDelete(WidgetRef ref) {
    showModal(
      context: ref.context,
      builder: (_) => DeleteDialog(
        title: AppLocalizations.instance.p0(2),
        content: AppLocalizations.instance.p1(2),
        onDelete: () {
          state.notes.forEach((note) {
            GetIt.I<NoteService>().delete(note.id, note.notificationID);
            GetIt.I<FolderService>().updateCountIfNeeded(note.folderID);
          });

          closeBar();
        },
      ),
    );
  }
}

final contextualBarController = NotifierProvider.autoDispose<ContextualBarController, ContextualAppBarState>(() => ContextualBarController());
