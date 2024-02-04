import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../animations/animatable_card.dart';
import '../../../models/folder.dart';
import '../../../services/folder_service.dart';

class FolderDialogController {
  final WidgetRef ref;

  late ValueNotifier<bool> colorize;
  late TextEditingController textEditingController;

  FolderDialogController(this.ref, Folder? folder) {
    colorize = ValueNotifier(folder != null);
    textEditingController = TextEditingController(text: folder?.name);
  }

  void dispose() => textEditingController.dispose();

  void onFocusChanged(bool value) {
    if (value)
      colorize.value = true;
    else
      colorize.value = textEditingController.text.isNotEmpty;
  }

  void onTapDone(Folder? folder) {
    final name = textEditingController.text.trim();

    if (name.isNotEmpty) {
      if (folder == null) {
        final folder = Folder(name: name, id: Uuid().v4(), created: DateTime.now());
        AnimatableCardEntranceController.instance.add(folder.id);
        GetIt.I<FolderService>().write(folder);
      } else {
        GetIt.I<FolderService>().write(folder.copyWith(name: name));
      }
    }

    Navigator.pop(ref.context);
  }
}
