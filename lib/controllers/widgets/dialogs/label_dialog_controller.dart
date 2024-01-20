import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../models/label.dart';
import '../../../services/label_service.dart';

class LabelDialogController {
  final WidgetRef ref;

  late ValueNotifier<bool> colorize;
  late TextEditingController textEditingController;

  LabelDialogController(this.ref, Label? label) {
    colorize = ValueNotifier(label != null);
    textEditingController = TextEditingController(text: label?.name);
  }

  void dispose() => textEditingController.dispose();

  void onFocusChanged(bool value) {
    if (value)
      colorize.value = true;
    else
      colorize.value = textEditingController.text.isNotEmpty;
  }

  void onTapDelete(Label label) {
    GetIt.I<LabelService>().delete(label.id);
    Navigator.pop(ref.context);
  }

  void onTapDone(Label? label) {
    final name = textEditingController.text.trim();

    if (name.isNotEmpty) {
      if (label == null) {
        final label = Label(name: name, id: Uuid().v4(), created: DateTime.now());
        GetIt.I<LabelService>().write(label);
      } else {
        GetIt.I<LabelService>().write(label.copyWith(name: name));
      }
    }

    Navigator.pop(ref.context);
  }
}
