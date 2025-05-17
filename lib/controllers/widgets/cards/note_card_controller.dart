import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../models/single_note_widget_launch_details.dart';
import '../../../models/label.dart';
import '../../../models/note.dart';
import '../../../services/label_service.dart';
import '../../../services/single_note_widget_service.dart';
import '../../main_controller.dart';
import '../shared/contextual_appbar_controller.dart';

class NoteCardController {
  const NoteCardController();

  List<Label> getCurrentLabels(Note note, int limit) =>
      GetIt.I<LabelService>().getAllFromIDs(note.labelIDs.sublist(0, min(limit, note.labelIDs.length)));

  void onTapCard(WidgetRef ref, Note note) {
    if (singleNoteWidgetLaunchDetails.launchAction == SingleNoteWidgetLaunchAction.Select) {
      GetIt.I<SingleNoteWidgetService>().initWidget(note, ref);
      SystemNavigator.pop();
    } else if (ref.read(contextualBarController).active) {
      ref.read(contextualBarController.notifier).onTapCard(note);
    }
  }

  void onLongPressCard(WidgetRef ref, Note note) {
    final isNotActive = !ref.read(contextualBarController).active;
    final isActionNotSelect = singleNoteWidgetLaunchDetails.launchAction != SingleNoteWidgetLaunchAction.Select;

    if (isActionNotSelect && isNotActive) {
      ref.read(contextualBarController.notifier).openBar();
      ref.read(contextualBarController.notifier).onTapCard(note);
    }
  }
}
